#' Load the Tidied College Scorecard Data Set
#' 
#' @description
#' Loads a tidied version of the U.S. College Scorecard data set, either 
#' individually or as a list with two data frames: `scorecard` and `school`.
#' The data set contain only colleges that participate in Title IV federal
#' financial aid programs. In the tidy data set, column names have been changed
#' for readability and consistency.
#' 
#' You can find the original data set at the U.S. Department of Education's
#' [College Scorecard website](https://collegescorecard.ed.gov/data/). The
#' code for the data transformation process is available at
#' <https://github.com/gadenbuie/scorecard-db>.
#' 
#' @examples
#' c(scorecard, school) %<-% college_load_tidy_all()
#' scorecard <- college_load_tidy_scorecard()
#' school <- college_load_tidy_school()
#'
#' @return A list with two data frames: `scorecard` and `school`.
#' @name college_load_tidy
NULL

#' @describeIn college_load_tidy Load both the tidied scorecard and school data
#'   sets.
#' @export
college_load_tidy_all <- function() {
  list(
    scorecard = ,
    school = readRDS(path_pkg("scorecard-tidy", "school.rds"))
  )
}

#' @describeIn college_load_tidy Load the tidy scorecard data set.
#' @export
college_load_tidy_scorecard <- function() {
  readRDS(path_pkg("scorecard-tidy", "scorecard.rds"))
}

#' @describeIn college_load_tidy Load the tidy school data set.
#' @export
college_load_tidy_school <- function() {
  readRDS(path_pkg("scorecard-tidy", "school.rds"))
}