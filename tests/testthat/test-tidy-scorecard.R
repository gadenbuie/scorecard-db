test_that("net prices preserve private-first coalescing for all income brackets", {
	data <- scorecard_site_fixture()
	raw_vars <- c("npt4", paste0("npt4", 1:5))
	tidy_vars <- c(
		"cost_avg",
		"cost_avg_income_0_30k",
		"cost_avg_income_30_48k",
		"cost_avg_income_48_75k",
		"cost_avg_income_75_110k",
		"cost_avg_income_110k_plus"
	)
	for (i in seq_along(raw_vars)) {
		data[[paste0("cost_", raw_vars[i], "_priv")]] <-
			c(NA, 12000, 15000, NA, 9000) + i
		data[[paste0("cost_", raw_vars[i], "_pub")]] <-
			c(8000, NA, 7000, NA, NA) + i
	}
	path <- withr::local_tempfile(fileext = ".rds")
	saveRDS(data, path)

	result <- tidy_scorecard(path, tibble(id = 1:4))

	expect_identical(result$id, 1:4)
	for (i in seq_along(tidy_vars)) {
		expect_equal(
			result[[tidy_vars[i]]],
			c(8000, 12000, 15000, NA) + i,
			label = tidy_vars[i]
		)
	}
})

test_that("attendance costs and 150 percent completion retain separate sources", {
	data <- scorecard_site_fixture()
	data$cost_costt4_a <- c(27153, NA, 30000, NA, 50000)
	data$cost_costt4_p <- c(NA, 17000, 19000, NA, 40000)
	data$completion_c100_4 <- c(0.117, NA, 0.3, NA, 0.4)
	data$completion_c150_4 <- c(0.24, NA, 0.5, NA, 0.6)
	data$completion_c150_l4 <- c(NA, 0.7, 0.8, NA, 0.9)
	data$cost_npt4_pub <- c(17621, NA, 18000, NA, NA)
	path <- withr::local_tempfile(fileext = ".rds")
	saveRDS(data, path)

	result <- tidy_scorecard(path, tibble(id = 1:4))

	expect_equal(result$cost_attendance_academic_year, c(27153, NA, 30000, NA))
	expect_equal(result$cost_attendance_program_year, c(NA, 17000, 19000, NA))
	expect_equal(result$rate_completion, c(0.117, NA, 0.3, NA))
	expect_equal(result$rate_completion_150_4yr, c(0.24, NA, 0.5, NA))
	expect_equal(result$rate_completion_150_lt4yr, c(NA, 0.7, 0.8, NA))
	expect_equal(result$cost_avg, c(17621, NA, 18000, NA))
})

test_that("new raw metrics are registered as site extras and documented", {
	sources <- c(
		cost_attendance_academic_year = "COSTT4_A",
		cost_attendance_program_year = "COSTT4_P",
		rate_completion_150_4yr = "C150_4",
		rate_completion_150_lt4yr = "C150_L4"
	)
	expect_setequal(unname(sources), intersect(unname(sources), site_extra_vars))
	for (name in names(sources)) {
		expect_identical(.doc_get_col_source("scorecard", name), sources[[name]])
	}
})

test_that("net price documentation identifies both public and private sources", {
	tidy_vars <- c(
		"cost_avg",
		"cost_avg_income_0_30k",
		"cost_avg_income_30_48k",
		"cost_avg_income_48_75k",
		"cost_avg_income_75_110k",
		"cost_avg_income_110k_plus"
	)
	sources <- c("NPT4", paste0("NPT4", 1:5))
	for (i in seq_along(tidy_vars)) {
		description <- .doc_get_col_source("scorecard", tidy_vars[i])
		expect_match(description, "net price", info = tidy_vars[i])
		expect_match(
			description,
			paste0(sources[i], "_PUB"),
			fixed = TRUE,
			info = tidy_vars[i]
		)
		expect_match(
			description,
			paste0(sources[i], "_PRIV"),
			fixed = TRUE,
			info = tidy_vars[i]
		)
		expect_match(
			description,
			"private value when available, otherwise the public value",
			fixed = TRUE
		)
	}
})

test_that("the expanded scorecard schema preserves and documents all original columns", {
	data <- scorecard_site_fixture()
	path <- withr::local_tempfile(fileext = ".rds")
	saveRDS(data, path)

	result <- tidy_scorecard(path, tibble(id = 1:4))

	expected_columns <- c(
		"id",
		"academic_year",
		"n_undergrads",
		"cost_tuition_in",
		"cost_tuition_out",
		"cost_books",
		"cost_room_board_on",
		"cost_room_board_off",
		"cost_attendance_academic_year",
		"cost_attendance_program_year",
		"cost_avg",
		"cost_avg_income_0_30k",
		"cost_avg_income_30_48k",
		"cost_avg_income_48_75k",
		"cost_avg_income_75_110k",
		"cost_avg_income_110k_plus",
		"amnt_earnings_med_10y",
		"rate_completion",
		"rate_completion_150_4yr",
		"rate_completion_150_lt4yr",
		"rate_admissions",
		"score_sat_avg",
		"score_act_p25",
		"score_act_p75",
		"score_sat_verbal_p25",
		"score_sat_verbal_p75",
		"score_sat_math_p25",
		"score_sat_math_p75"
	)
	expect_named(result, expected_columns)
	for (name in expected_columns) {
		expect_type(.doc_get_col_source("scorecard", name), "character")
	}
	expect_identical(
		.doc_get_col_source("scorecard", "rate_completion"),
		"C100_4"
	)
})
