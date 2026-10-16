library(dplyr)

source(testthat::test_path("..", "..", "R", "tidy.R"), local = TRUE)
source(testthat::test_path("..", "..", "R", "out_used_on_site.R"), local = TRUE)
source(
	testthat::test_path("..", "..", "pkg", "R", "collegeScorecard-package.R"),
	local = TRUE
)

scorecard_site_fixture <- function() {
	numeric_vars <- c(
		"student_ugds",
		"cost_tuitionfee_in",
		"cost_tuitionfee_out",
		"cost_booksupply",
		"cost_roomboard_on",
		"cost_roomboard_off",
		"cost_costt4_a",
		"cost_costt4_p",
		"cost_npt4_priv",
		"cost_npt4_pub",
		"cost_npt41_priv",
		"cost_npt41_pub",
		"cost_npt42_priv",
		"cost_npt42_pub",
		"cost_npt43_priv",
		"cost_npt43_pub",
		"cost_npt44_priv",
		"cost_npt44_pub",
		"cost_npt45_priv",
		"cost_npt45_pub",
		"earnings_md_earn_wne_p10",
		"completion_c100_4",
		"completion_c150_4",
		"completion_c150_l4",
		"admissions_adm_rate_all",
		"admissions_sat_avg",
		"admissions_actcm25",
		"admissions_actcm75",
		"admissions_satvr25",
		"admissions_satvr75",
		"admissions_satmt25",
		"admissions_satmt75"
	)
	data <- tibble(
		unitid = 1:5,
		academic_year = rep("2024-25", 5),
		latitude = NA_real_,
		longitude = NA_real_,
		admissions_admcon7 = NA_character_
	)
	for (name in numeric_vars) {
		data[[name]] <- rep(NA_real_, 5)
	}
	data
}
