.globals <- new.env(parent = emptyenv())

global_duckdb <- function() {
	if (!exists("con", .globals)) {
		.globals$con <- duckdb::dbConnect(duckdb::duckdb())
	}
	.globals$con
}

tbl_merged <- function(
	path_data_full_merged = tar_read("path_data_full_merged")
) {
	con <- global_duckdb()
	DBI::dbExecute(
		con,
		glue(
			"CREATE OR REPLACE TABLE merged AS SELECT * FROM read_parquet('{path_data_full_merged}/*.parquet', union_by_name = true);"
		)
	)

	dplyr::tbl(con, "merged")
}

tbl_info <- function(
	path_data_full_info = tar_read("path_data_full_info")
) {
	con <- global_duckdb()
	DBI::dbExecute(
		con,
		glue(
			"CREATE OR REPLACE TABLE info AS ",
			"SELECT * FROM read_parquet('{path_data_full_info}');"
		)
	)
	dplyr::tbl(con, "info")
}

tbl_labels <- function(
	path_data_full_labels = tar_read("path_data_full_labels")
) {
	con <- global_duckdb()
	DBI::dbExecute(
		con,
		glue(
			"CREATE OR REPLACE TABLE labels AS ",
			"SELECT * FROM read_parquet('{path_data_full_labels}');"
		)
	)
	dplyr::tbl(con, "labels")
}
