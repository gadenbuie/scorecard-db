out_full_merged_parquet <- function(
	path_merged = tar_read("path_data_raw_merged"),
	data_dictionary = tar_read("data_dictionary"),
	output_dir = "data/parquet/merged"
) {
	con <- duckdb::dbConnect(duckdb::duckdb())
	withr::defer(DBI::dbDisconnect(con))

	dir_create(output_dir)

	for (file in path_merged) {
		academic_year <- duckdb_load_merged_csv(file, con)

		cli::cli_progress_step("{.field {academic_year}}: saving parquet")
		columns <- DBI::dbGetQuery(con, "SELECT * FROM merged LIMIT 0") |> names()
		cols <- paste(c("ACADEMIC_YEAR", columns), collapse = ", ")
		q_parquet <- glue(
			"COPY (SELECT {cols} FROM merged) ",
			"TO '{output_dir}/{academic_year}.parquet' ",
			"(FORMAT PARQUET, COMPRESSION 'zstd');"
		)
		DBI::dbExecute(con, q_parquet)

		cli::cli_progress_done()
	}


	output_dir
}

duckdb_load_merged_csv <- function(file, con = global_duckdb()) {
	academic_year <- sub(".*(\\d{4}_\\d{2}).*", "\\1", file)
	academic_year <- gsub("_", "-", academic_year)
	cli::cli_progress_step("{.field {academic_year}}: reading csv")

	q_read <- glue("CREATE OR REPLACE TABLE merged AS SELECT * FROM read_csv('{file}', nullstr = ['NA', 'NULL', '', 'PS']);")
	DBI::dbExecute(con, q_read)
	DBI::dbExecute(con, glue("ALTER TABLE merged ADD COLUMN ACADEMIC_YEAR VARCHAR DEFAULT '{academic_year}';"))

	academic_year
}

out_full_info_parquet <- function(
	dd = tar_read(data_dictionary),
	output_file = "data/parquet/dd_info.parquet"
) {
	con <- duckdb::dbConnect(duckdb::duckdb())
	withr::defer(DBI::dbDisconnect(con))

	dir_create(path_dir(output_file))

	DBI::dbWriteTable(con, "dd_info", dd$info, overwrite = TRUE)
	DBI::dbExecute(
		con,
		glue(
			"COPY dd_info TO '{output_file}' ",
			"(FORMAT PARQUET, COMPRESSION 'zstd');"
		)
	)

	output_file
}

out_full_labels_parquet <- function(
	dd = tar_read(data_dictionary),
	output_file = "data/parquet/dd_labels.parquet"
) {
	con <- duckdb::dbConnect(duckdb::duckdb())
	withr::defer(DBI::dbDisconnect(con))

	dir_create(path_dir(output_file))

	DBI::dbWriteTable(con, "dd_labels", dd$labels, overwrite = TRUE)
	DBI::dbExecute(
		con,
		glue(
			"COPY dd_labels TO '{output_file}' ",
			"(FORMAT PARQUET, COMPRESSION 'zstd');"
		)
	)

	output_file
}
