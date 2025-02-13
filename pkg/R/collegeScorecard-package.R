#' @section Updated:
#'
#' The data were last updated on **January 16, 2025** from
#' <https://collegescorecard.ed.gov/data/>. Please visit
#' <https://github.com/gadenbuie/scorecard-db> for the code used to process
#' and transform the released data into the tidy data sets available in this
#' package.
#'
#' @keywords internal
"_PACKAGE"

#' College Scorecard: Scorecard Data
#'
#' @description
#' Historical data from the U.S. College Scorecard dataset. The data includes
#' historical information on the number of students, average cost, median
#' earnings after graduations, rates of admission and completion, and ACT and
#' SAT test scores.
#'
#' The data set contain only colleges that participate in Title IV federal
#' financial aid programs. In the tidy data set, column names have been changed
#' for readability and consistency.
#'
#' You can find the original data set at the U.S. Department of Education's
#' [College Scorecard website](https://collegescorecard.ed.gov/data/). The
#' code for the data transformation process is available at
#' <https://github.com/gadenbuie/scorecard-db>.
#'
#' @references <https://collegescorecard.ed.gov/data/>
#'
#' @format A data frame with `r .docs_df_shape(scorecard)`. Original column
#'   names from the source dataset are noted in parenthesis.
#'
#' `r .doc_column_info("scorecard")`
"scorecard"

#' College Scorecard: School Data
#'
#' @description
#' Information about institutions in the U.S. College Scorecard dataset. The
#' uses the most recent report for each institution. The `school` dataset can be
#' used to filter the `scorecard` dataset. Join the two datasets using the `id`
#' column.
#'
#' The data set contain only colleges that participate in Title IV federal
#' financial aid programs. In the tidy data set, column names have been changed
#' for readability and consistency.
#'
#' You can find the original data set at the U.S. Department of Education's
#' [College Scorecard website](https://collegescorecard.ed.gov/data/). The
#' code for the data transformation process is available at
#' <https://github.com/gadenbuie/scorecard-db>.
#'
#' @references <https://collegescorecard.ed.gov/data/>
#'
#' @format A data frame with `r .docs_df_shape(school)`. Original column names
#'   from the source dataset are noted in parenthesis.
#'
#' `r .doc_column_info("school")`
"school"

.docs_df_shape <- function(df) {
	n <- format(nrow(df), big.mark = ",")
	p <- format(ncol(df), big.mark = ",")
	sprintf("%s rows and %s variables", n, p)
}

.doc_column_info <- function(name) {
	df <- get(name)
	dd <- readRDS(path_pkg("scorecard-data-dictionary.rds"))

	col_item <- vapply(names(df), FUN.VALUE = character(1), function(col_name) {
		# \item{\code{id}}{`[integer]` A unique identifier for each institution. (`UNITID`)}
		sprintf(
			"  \\item{\\code{%s}}{%s%s}",
			col_name,
			.doc_col_type(df[[col_name]]),
			.doc_col_desc(.doc_get_col_source(name, col_name), dd)
		)
	})

	paste(c("\\describe{", col_item, "}"), collapse = "\n")
}

.doc_get_col_source <- function(name, col) {
	ret <- .docs_var_map[[name]][[col]]

	if (is.null(ret)) {
		stop(
			"No source column mapping found for ",
			col,
			" in the ",
			name,
			" dataset."
		)
	}

	ret
}

.doc_col_desc <- function(x, dd) {
	if (!x %in% dd$info$variable_name) {
		return(x)
	}

	desc <- dd$info[["name_of_data_element"]][dd$info$variable_name == x]
	desc <- sub("\n.+$", "", desc)
	desc <- trimws(desc)
	desc <- sub("[.]$", "", desc)

	sprintf("%s. (`%s`)", desc, x)
}

.doc_col_type <- function(x) {
	if (is.character(x)) {
		"`[character]` "
	} else if (is.factor(x)) {
		"`[factor]` "
	} else if (is.integer(x)) {
		"`[integer]` "
	} else if (is.numeric(x)) {
		"`[numeric]` "
	} else if (is.logical(x)) {
		"`[logical]` "
	} else {
		""
	}
}

.docs_var_map <- list(
	school = list(
		id = "A unique identifier for each institution. (`UNITID`)",
		name = "INSTNM",
		city = "CITY",
		state = "STABBR",
		zip = "ZIP",
		latitude = "LATITUDE",
		longitude = "LONGITUDE",
		url = "INSTURL",
		deg_predominant = "PREDDEG",
		deg_highest = "HIGHDEG",
		control = "CONTROL",
		locale_type = "LOCALE",
		locale_size = "LOCALE",
		adm_req_test = "ADMCON7",
		is_hbcu = "HBCU",
		is_pbi = "PBI",
		is_annhi = "ANNHI",
		is_tribal = "TRIBAL",
		is_aanapii = "AANAPII",
		is_hsi = "HSI",
		is_nanti = "NANTI",
		is_only_men = "MENONLY",
		is_only_women = "WOMENONLY",
		is_only_distance = "DISTANCEONLY",
		religious_affiliation = "Religious affiliation of the institution. (`RELAFFIL`)" # fix spelling
	),
	scorecard = list(
		id = "A unique identifier for each institution. (`UNITID`)",
		academic_year = "The academic year of the record.",
		n_undergrads = "UGDS",
		cost_tuition_in = "TUITIONFEE_IN",
		cost_tuition_out = "TUITIONFEE_OUT",
		cost_books = "BOOKSUPPLY",
		cost_room_board_on = "ROOMBOARD_ON",
		cost_room_board_off = "ROOMBOARD_OFF",
		cost_avg = "NPT4_PRIV",
		cost_avg_income_0_30k = "NPT41_PRIV",
		cost_avg_income_30_48k = "NPT42_PRIV",
		cost_avg_income_48_75k = "NPT43_PRIV",
		cost_avg_income_75_110k = "NPT44_PRIV",
		cost_avg_income_110k_plus = "NPT45_PRIV",
		amnt_earnings_med_10y = "MD_EARN_WNE_P10",
		rate_completion = "C100_4",
		rate_admissions = "ADM_RATE_ALL",
		score_sat_avg = "SAT_AVG",
		score_act_p25 = "ACTCM25",
		score_act_p50 = "ACTCM50",
		score_act_p75 = "ACTCM75",
		score_sat_verbal_p25 = "SATVR25",
		score_sat_verbal_p50 = "SATVR50",
		score_sat_verbal_p75 = "SATVR75",
		score_sat_math_p25 = "SATMT25",
		score_sat_math_p50 = "SATMT50",
		score_sat_math_p75 = "SATMT75"
	)
)
