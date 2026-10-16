#' @section Updated:
#'
#' The data were last updated on **October 14, 2026** from
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
#' historical information on the number of students, costs of attendance and
#' average net prices, median earnings after entry, rates of admission and
#' completion, and ACT and SAT test scores.
#'
#' Schools are included only if their most recent record has `OPEFLAG = 1`
#' (participates in Title IV federal financial aid programs). Branch campuses
#' with `OPEFLAG = 2`, deferment-only institutions, and nonparticipating
#' institutions are excluded. Column names have been changed for readability and
#' consistency.
#'
#' `cost_avg` and `cost_avg_income_*` are average net prices, not costs of
#' attendance. The `cost_attendance_*` columns report costs of attendance for
#' academic-year and program-year institutions separately. `rate_completion` is
#' the four-year institution completion rate within 100% of normal time;
#' `rate_completion_150_4yr` and `rate_completion_150_lt4yr` report completion
#' within 150% of normal time for four-year and less-than-four-year
#' institutions.
#'
#' The Most Recent Institution bulk file can draw different metrics from
#' different academic years. A single `academic_year` in this dataset need not
#' match every metric in that file.
#'
#' You can find the original data set at the U.S. Department of Education's
#' [College Scorecard website](https://collegescorecard.ed.gov/data/). The code
#' for the data transformation process is available at
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
#' Information about institutions in the U.S. College Scorecard dataset. This
#' uses the most recent report for each institution. The `school` dataset can be
#' used to filter the `scorecard` dataset. Join the two datasets using the `id`
#' column.
#'
#' Schools are included only if their most recent record has `OPEFLAG = 1`
#' (participates in Title IV federal financial aid programs). Branch campuses
#' with `OPEFLAG = 2`, deferment-only institutions, and nonparticipating
#' institutions are excluded. Column names have been changed for readability
#' and consistency.
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
		cost_attendance_academic_year = "COSTT4_A",
		cost_attendance_program_year = "COSTT4_P",
		cost_avg = "Average net price for Title IV institutions (public, private nonprofit, and private for-profit). Uses the private value when available, otherwise the public value. (`NPT4_PRIV`, `NPT4_PUB`)",
		cost_avg_income_0_30k = "Average net price for $0-$30,000 family income (public and private institutions). Uses the private value when available, otherwise the public value. (`NPT41_PRIV`, `NPT41_PUB`)",
		cost_avg_income_30_48k = "Average net price for $30,001-$48,000 family income (public and private institutions). Uses the private value when available, otherwise the public value. (`NPT42_PRIV`, `NPT42_PUB`)",
		cost_avg_income_48_75k = "Average net price for $48,001-$75,000 family income (public and private institutions). Uses the private value when available, otherwise the public value. (`NPT43_PRIV`, `NPT43_PUB`)",
		cost_avg_income_75_110k = "Average net price for $75,001-$110,000 family income (public and private institutions). Uses the private value when available, otherwise the public value. (`NPT44_PRIV`, `NPT44_PUB`)",
		cost_avg_income_110k_plus = "Average net price for $110,000+ family income (public and private institutions). Uses the private value when available, otherwise the public value. (`NPT45_PRIV`, `NPT45_PUB`)",
		amnt_earnings_med_10y = "MD_EARN_WNE_P10",
		rate_completion = "C100_4",
		rate_completion_150_4yr = "C150_4",
		rate_completion_150_lt4yr = "C150_L4",
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
