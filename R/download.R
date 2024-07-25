URL_COLLEGE_SCORECARD <- "https://collegescorecard.ed.gov/data/"

cs_url_data_zip <- function() {
	readLines(URL_COLLEGE_SCORECARD) |>
		paste(collapse = "\n") |>
		xml2::read_html() |>
		xml2::xml_find_first("//*[contains(@href, 'Raw_Data')]") |>
		xml2::xml_attr("href")
}

cs_data_raw_download <- function(url, output_dir = "data-raw") {
	dir_create(output_dir)
	# The download can be very very slow, so timeout at 10 minutes instead of 1
	withr::local_options(list(timeout = 60 * 10))

	file <- path(output_dir, path_file(url))
	download.file(url, destfile = file)

	file
}

cs_data_raw_extract <- function(path_zip, output_dir = "data-raw/college-scorecard-raw") {
	dir_create(output_dir)
	zip::unzip(path_zip, exdir = output_dir)

	zip::zip_list(path_zip)$filename
	output_dir
}

cs_data_raw_ls_merged <- function(output_dir) {
	dir_ls(output_dir, glob = "*MERGED*.csv")
}

cs_data_raw_ls_yaml <- function(output_dir) {
	dir_ls(output_dir, glob = "*data.yaml")
}

cs_data_raw_ls_dictionary <- function(output_dir) {
	dir_ls(output_dir, glob = "*DataDictionary.xlsx")
}
