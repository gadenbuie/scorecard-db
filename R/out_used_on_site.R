out_used_on_site_parquet <- function(
  data_dictionary = tar_read("data_dictionary"),
  path_data_full_merged = tar_read("path_data_full_merged"),
  output_file = "data/site/scorecard_used_on_site.parquet"
) {
  dir_create(path_dir(output_file))
  merged <- tbl_merged(path_data_full_merged)
  
  keep <-
    data_dictionary$info |>
      dplyr::filter(shown_use_on_site == "Yes") |>
        dplyr::pull(variable_name) |>
          paste(collapse = ", ")
        
  con <- global_duckdb()
  DBI::dbExecute(con, glue(
    "COPY (SELECT ACADEMIC_YEAR, {keep} FROM merged) TO '{output_file}' ",
    "(FORMAT PARQUET, COMPRESSION 'zstd');"
  ))

  output_file
}

out_used_on_site_sqlite <- function(
  path_data_site_parquet = tar_read("path_data_site_parquet"),
  path_data_full_info = tar_read("path_data_full_info"),
  path_data_full_labels = tar_read("path_data_full_labels"),
  output_file = "data/site/scorecard_used_on_site.db"
) {
  dir_create(path_dir(output_file))

  con <- duckdb::dbConnect(duckdb::duckdb())
  withr::defer(DBI::dbDisconnect(con))
  if (file_exists(output_file)) file_delete(output_file)

  db_execute <- function(con, query) {
    cli::cli_verbatim(query)
    DBI::dbExecute(con, query)
  }

  stopifnot(
    length(path_data_full_info) == 1, 
    length(path_data_full_labels) == 1
  )

  db_execute(con, "INSTALL SQLITE;")
  db_execute(con, "LOAD SQLITE;")
  db_execute(con, glue("ATTACH '{output_file}' AS sqlite_db (TYPE SQLITE);"))
  db_execute(con, glue("CREATE TABLE sqlite_db.scorecard as (SELECT * FROM read_parquet('{path_data_site_parquet}'));"))
  db_execute(con, glue("CREATE TABLE sqlite_db.info as (SELECT * FROM read_parquet('{path_data_full_info}'));"))
  db_execute(con, glue("CREATE TABLE sqlite_db.labels as (SELECT * FROM read_parquet('{path_data_full_labels}'));"))

  output_file
}

out_used_on_site_csv <- function(
  path_data_site_parquet = tar_read("path_data_site_parquet"),
  output_file = "data/site/scorecard_used_on_site.csv"
) {
  dir_create(path_dir(output_file))

  con <-duckdb::dbConnect(duckdb::duckdb())
  withr::defer(DBI::dbDisconnect(con))

  DBI::dbExecute(con, glue(
    "COPY (SELECT * FROM '{path_data_site_parquet}') ",
    "TO '{output_file}' (FORMAT CSV);"
  ))

  output_file
}

out_used_on_site_rds <- function(
  data_dictionary = tar_read("data_dictionary"),
  path_data_full_merged = tar_read("path_data_full_merged"),
  output_file = "data/site/scorecard_used_on_site.rds",
  keep_extra = c("ZIP", "LATITUDE", "LONGITUDE", "C100_4")
) {
  dir_create(path_dir(output_file))

  merged <- tbl_merged(path_data_full_merged)
  con <- global_duckdb()

  info <- data_dictionary$info
  labels <- data_dictionary$labels
  
  keep <-
    info |>
    dplyr::filter(
      shown_use_on_site == "Yes" |
      variable_name %in% !!keep_extra
    ) |>
    dplyr::pull(variable_name)
        
  merged_keep <- 
    merged |>
    dplyr::select("ACADEMIC_YEAR", dplyr::all_of(keep)) |>
    dplyr::collect()

  labelled_vars <- intersect(keep, labels$variable_name)

  for (var in labelled_vars) {
    merged_keep[[var]] <- factor(
      merged_keep[[var]],
      levels = labels |> dplyr::filter(variable_name == var) |> dplyr::pull(value),
      labels = labels |> dplyr::filter(variable_name == var) |> dplyr::pull(label)
    )
  }

  for (var in c("INSTNM", "CITY")) {
    merged_keep[[var]] <- uncap(merged_keep[[var]])
  }

  new_vars <-
    info |>
    dplyr::filter(variable_name %in% keep) |>
    dplyr::mutate(
      new_var = paste0(dev_category, "_", tolower(variable_name)),
      new_var = gsub("[.]", "_", new_var),
      new_var = sub("root_", "", new_var),
    ) |>
    dplyr::select(variable_name, new_var) |>
    purrr::reduce(purrr::set_names) |>
    (\(x) c("academic_year" = "ACADEMIC_YEAR", x))()

  merged_keep <- merged_keep |> dplyr::rename(!!!new_vars)

  merged_keep <- readr::type_convert(merged_keep)

  readr::write_rds(merged_keep, output_file, compress = "gz")

  output_file
}

uncap <- function(str) {
  allcap <- str == toupper(str)
  str[allcap] <- stringr::str_to_title(str[allcap])
  str
}