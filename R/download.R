URL_COLLEGE_SCORECARD <- "https://collegescorecard.ed.gov/data/"

# The data dictionary is no longer included in the raw data zip (releases now
# ship only data.yaml, which doesn't contain the full workbook contents used
# below). The dictionary workbook is still published at this URL, although it
# is no longer linked from the data page.
URL_DATA_DICTIONARY <- "https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary.xlsx"

cs_url_data_zip <- function() {
	r <- rvest::read_html_live(URL_COLLEGE_SCORECARD)
	withr::defer(r$session$close())

	r |>
		rvest::html_element('[href*="Raw_Data"]') |>
		rvest::html_attr("href")
}

cs_data_raw_download <- function(url, output_dir = "data-raw") {
	dir_create(output_dir)
	# The download can be very very slow, so timeout at 10 minutes instead of 1
	withr::local_options(list(timeout = 60 * 10))

	file <- path(output_dir, path_file(url))
	download.file(url, destfile = file)

	file
}

cs_data_raw_extract <- function(
	path_zip,
	output_dir = "data-raw/college-scorecard-raw"
) {
	zip_files <- zip::zip_list(path_zip)$filename

	# Recent releases nest all files in a single top-level folder named for
	# the release, e.g. College_Scorecard_Raw_Data_06032026/ (older releases
	# stored the data files at the root of the archive). Skip the OS-specific
	# __MACOSX folder that macOS users add to the zip.
	zip_dirs <- strsplit(zip_files, "/", fixed = TRUE)
	nested <- zip_dirs[lengths(zip_dirs) > 1]
	release_dirs <- setdiff(
		unique(vapply(nested, `[[`, character(1), 1)),
		"__MACOSX"
	)

	# Always extract into a fresh directory so that files left over from a
	# previous release can never be picked up by the targets below.
	if (dir_exists(output_dir)) {
		dir_delete(output_dir)
	}
	dir_create(output_dir)
	zip::unzip(
		path_zip,
		files = grep("^__MACOSX", zip_files, value = TRUE, invert = TRUE),
		exdir = output_dir
	)

	if (length(release_dirs) == 1) {
		path_data_raw <- path(output_dir, release_dirs)
	} else {
		path_data_raw <- output_dir
	}

	cs_data_raw_validate(path_data_raw, zip_files)

	path_data_raw
}

cs_data_raw_validate <- function(path_data_raw, zip_files) {
	if (!dir_exists(path_data_raw)) {
		stop(
			"Expected the extracted College Scorecard release in ",
			path_data_raw,
			"."
		)
	}

	# Every MERGED data file in the zip must be present in the extracted
	# release folder. Failing loudly here prevents the pipeline from quietly
	# processing files left over from a previous release.
	merged_in_zip <- sum(grepl("MERGED.*[.]csv$", basename(zip_files)))
	merged_files <- dir_ls(path_data_raw, glob = "*MERGED*.csv")

	if (length(merged_files) != merged_in_zip) {
		stop(
			"Expected ",
			merged_in_zip,
			" MERGED data files in ",
			path_data_raw,
			" but found ",
			length(merged_files),
			"."
		)
	}

	invisible(path_data_raw)
}

cs_data_raw_ls <- function(release_dir, glob, what) {
	files <- dir_ls(release_dir, glob = glob)

	if (length(files) == 0) {
		stop("No ", what, " found in ", release_dir, ".")
	}

	files
}

cs_data_raw_ls_merged <- function(release_dir) {
	cs_data_raw_ls(release_dir, glob = "*MERGED*.csv", what = "merged data files")
}

cs_data_raw_ls_yaml <- function(release_dir) {
	cs_data_raw_ls(release_dir, glob = "*data.yaml", what = "data.yaml file")
}
