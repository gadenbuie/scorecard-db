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
#' @format A data frame with 183,306 rows and 23 variables. Original column
#'   names from the source dataset are noted in parenthesis.
#' \describe{
#'   \item{\code{id}}{`[integer]` A unique identifier for each institution. (`UNITID`)}
#'   \item{\code{academic_year}}{`[character]` The academic year of the record.}
#'   \item{\code{n_undergrads}}{`[integer]` Enrollment of undergraduate certificate/degree-seeking students. (`UGDS`)}
#'   \item{\code{cost_avg}}{`[double]` Average net price for Title IV institutions. (`NPT4_PRIV` and `NPT4_PUB`)}
#'   \item{\code{cost_med_similar}}{`[logical]` Median average net price amongst insitituions with the same predominant degree category. (`MDCOST_PD`)}
#'   \item{\code{cost_med_overall}}{`[logical]` Overall median for average net price. (`MDCOST_ALL`)}
#'   \item{\code{cost_avg_income_0_30k}}{`[double]` Average net price for $0-$30,000 family income. (`NPT41_PRIV` and `NPT41_PUB`)}
#'   \item{\code{cost_avg_income_30_48k}}{`[double]` Average net price for $30,001-$48,000 family income. (`NPT42_PRIV` and `NPT42_PUB`)}
#'   \item{\code{cost_avg_income_48_75k}}{`[double]` Average net price for $48,001-$75,000 family income. (`NPT43_PRIV` and `NPT43_PUB`)}
#'   \item{\code{cost_avg_income_75_110k}}{`[double]` Average net price for $75,001-$110,000 family income. (`NPT44_PRIV` and `NPT44_PUB`)}
#'   \item{\code{cost_avg_income_110k_plus}}{`[double]` Average net price for $110,000+ family income. (`NPT45_PRIV` and `NPT45_PUB`)}
#'   \item{\code{amnt_earnings_med_10y}}{`[double]` Median earnings of students working and not enrolled 10 years after entry. (`MD_EARN_WNE_P10`)}
#'   \item{\code{rate_completion}}{`[double]` Completion rate for first-time, full-time students at four-year institutions (100% of expected time to completion)N. (`C100_4`)}
#'   \item{\code{rate_admissions}}{`[double]` Admission rate, suppressed for n<30. (`ADM_RATE_SUPP`)}
#'   \item{\code{score_act_p25}}{`[double]` 25th percentile of the ACT cumulative score. (`ACTCM25`)}
#'   \item{\code{score_act_p50}}{`[double]` 50th percentile of the ACT cumulative score. (`ACTCM50`)}
#'   \item{\code{score_act_p75}}{`[double]` 75th percentile of the ACT cumulative score. (`ACTCM75`)}
#'   \item{\code{score_sat_verbal_p25}}{`[double]` 25th percentile of SAT scores at the institution (critical reading). (`SATVR25`)}
#'   \item{\code{score_sat_verbal_p50}}{`[double]` 50th percentile of SAT scores at the institution (critical reading). (`SATVR50`)}
#'   \item{\code{score_sat_verbal_p75}}{`[double]` 75th percentile of SAT scores at the institution (critical reading). (`SATVR75`)}
#'   \item{\code{score_sat_math_p25}}{`[double]` 25th percentile of SAT scores at the institution (math). (`SATMT25`)}
#'   \item{\code{score_sat_math_p50}}{`[double]` 50th percentile of SAT scores at the institution (math). (`SATMT50`)}
#'   \item{\code{score_sat_math_p75}}{`[double]` 75th percentile of SAT scores at the institution (math). (`SATMT75`)}
#' }
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
#' @format A data frame with 11,300 rows and 25 variables. Original column names
#'   from the source dataset are noted in parenthesis.
#' \describe{
#'   \item{\code{id}}{`[integer]` A unique identifier for each institution. (`UNITID`)}
#'   \item{\code{name}}{`[character]` Institution name. (`INSTNM`)}
#'   \item{\code{city}}{`[character]` City. (`CITY`)}
#'   \item{\code{state}}{`[character]` State abbreviation. (`STABBR`)}
#'   \item{\code{zip}}{`[character]` Zip code. (`ZIP`)}
#'   \item{\code{latitude}}{`[double]` Latitude. (`LATITUDE`)}
#'   \item{\code{longitude}}{`[double]` Longitude. (`LONGITUDE`)}
#'   \item{\code{url}}{`[character]` URL for institution's homepage. (`INSTURL`)}
#'   \item{\code{deg_predominant}}{`[factor]` Predominant undergraduate degree awarded. (`PREDDEG`)}
#'   \item{\code{deg_highest}}{`[factor]` Highest degree awarded. (`HIGHDEG`)}
#'   \item{\code{control}}{`[factor]` Control of institution (IPEDS). (`CONTROL`)}
#'   \item{\code{locale_type}}{`[factor]` Locale of institution (City, suburb, town or rural) (`LOCALE`)}
#'   \item{\code{locale_size}}{`[factor]` Locale of institution (Large, medium, small (for city/suburb) or fringe, distant or remote (for town/rural). (`LOCALE`)}
#'   \item{\code{adm_req_test}}{`[factor]` Test score requirements for admission. (`ADMCON7`)}
#'   \item{\code{is_hbcu}}{`[logical]` Flag for Historically Black College and University. (`HBCU`)}
#'   \item{\code{is_pbi}}{`[logical]` Flag for predominantly black institution. (`PBI`)}
#'   \item{\code{is_annhi}}{`[logical]` Flag for Alaska Native Native Hawaiian serving institution. (`ANNHI`)}
#'   \item{\code{is_tribal}}{`[logical]` Flag for tribal college and university. (`TRIBAL`)}
#'   \item{\code{is_aanapii}}{`[logical]` Flag for Asian American Native American Pacific Islander-serving institution. (`AANAPII`)}
#'   \item{\code{is_hsi}}{`[logical]` Flag for Hispanic-serving institution. (`HSI`)}
#'   \item{\code{is_nanti}}{`[logical]` Flag for Native American non-tribal institution. (`NANTI`)}
#'   \item{\code{is_only_men}}{`[logical]` Flag for men-only college. (`MENONLY`)}
#'   \item{\code{is_only_women}}{`[logical]` Flag for women-only college (`WOMENONLY`)}
#'   \item{\code{is_only_distance}}{`[logical]` Flag for distance-education-only education" (`DISTANCEONLY`)}
#'   \item{\code{religious_affiliation}}{`[integer]` Religous affiliation of the institution. (`RELAFFIL`)}
#' }
"school"
