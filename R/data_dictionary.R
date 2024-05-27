dd_read_institution_cohort_map <- function(
  path = tar_read(path_data_raw_dictionary),
  sheet = "Institution_Cohort_Map"
) {
  path |> 
    readxl::read_excel(sheet, na = "") |>
    tidyr::pivot_longer(
      cols = -"Variable Name",
      names_to = "datafile",
      names_pattern = "(.*) datafile",
      values_to = "notes"
    ) |>
    dplyr::filter(notes != "NA") |>
    janitor::clean_names() |>
    tidyr::separate(
      notes,
      c("academic_year", "notes"),
      sep = ", ",
      extra = "merge"
    ) |> 
    dplyr::mutate(
      datafile = sub("_(\\d{4})-(\\d{2})", "\\1_\\2_PP.csv", datafile),
      academic_year = gsub("[^[:digit:]-]", "", academic_year),
    )
}

dd_read_institution <- function(
  path = tar_read(path_data_raw_dictionary),
  sheet = "Institution_Data_Dictionary"
) {
  data <- 
    path |> 
    readxl::read_excel(sheet, guess_max = 1e6) |>
    janitor::clean_names()

  labels <- 
    data |>
    dplyr::select(variable_name:label, notes) |>
    tidyr::fill(variable_name, .direction = "down") |>
    dplyr::filter(!is.na(value))
  
  info <-
    data |>
    dplyr::filter(!is.na(variable_name) & !is.na(source)) |>
    dplyr::mutate(has_labels = variable_name %in% labels$variable_name) |>
    dplyr::select(-value, -label) |>
    dplyr::mutate(
      data_type = recode(
        api_data_type,
        "autocomplete" = "VARCHAR",
        "string" = "VARCHAR",
        "float" = "FLOAT",
        "integer" = "INTEGER",
        "long" = "BIGINT"
      ),
      .after = api_data_type
    )

  list(
    info = info,
    labels = labels
  )
}