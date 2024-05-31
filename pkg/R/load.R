#' Load the Tidied College Scorecard Data Set
#' 
#' Loads a tidied version of the College Scorecard data set, returning
#' a list with two data frames: `scorecard` and `school`.
#' 
#' @examples
#' c(scorecard, school) %<-% cs_load_tidy()
#' 
#' @return A list with two data frames: `scorecard` and `school`.
#' @export
cs_load_tidy <- function() {
  list(
    scorecard = readRDS(path_pkg("scorecard-tidy", "scorecard.rds")),
    school = readRDS(path_pkg("scorecard-tidy", "school.rds"))
  )
}
