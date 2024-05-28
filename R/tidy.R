tidy_school_vars <- function(scorecard_site) {
	school_vars <- tidyselect::vars_select(
		names(scorecard_site),
		starts_with("school"),
		latitude,
		longitude
	)
	names(school_vars) <- sub("school_", "", names(school_vars))

	c(school_vars, adm_req_test = "admissions_admcon7")
}

tidy_school <- function(path_data_site_rds = tar_read("path_data_site_rds")) {
	scorecard_site <- readr::read_rds(path_data_site_rds)
	school_vars <- tidy_school_vars(scorecard_site)

	school <-
		scorecard_site |>
		slice_max(academic_year, n = 1, by = unitid) |>
		select(academic_year, unitid, all_of(school_vars)) |>
		filter(opeflag == "Participates in Title IV federal financial aid programs") |>
		tidyr::extract(
			locale,
			into = c("locale_type", "locale_size"),
			regex = "(\\w+): (\\w+) .+"
		) |>
		mutate(
			control = recode(
				control,
				"Public" = "Public",
				"Private nonprofit" = "Nonprofit",
				"Private for-profit" = "For-profit"
			),
			preddeg = case_when(
				grepl("certificate", preddeg) ~ "Certificate",
				grepl("associate", preddeg) ~ "Associate",
				grepl("bachelor", preddeg) ~ "Bachelor",
				grepl("graduate", preddeg) ~ "Graduate",
			),
			highdeg = case_when(
				grepl("Certificate", highdeg) ~ "Certificate",
				grepl("Associate", highdeg) ~ "Associate",
				grepl("Bachelor", highdeg) ~ "Bachelor",
				grepl("Graduate", highdeg) ~ "Graduate",
			),
			insturl = if_else(
				!is.na(insturl) & !grepl("^http", insturl),
				paste0("https://", insturl),
				insturl
			),
			across(
				c("hbcu", "pbi", "annhi", "tribal", "aanapii", "hsi", "nanti", "menonly", "womenonly"),
				\(x) x == "Yes"
			),
			across(
				"distanceonly",
				\(x) x == "Distance-education only"
			),
			adm_req_test = recode(
				adm_req_test,
				# "Required" = "",
				# "Recommended" = "",
				"Neither required nor recommended" = "Not recommended",
				"Do not know" = NA_character_,
				"Considered but not required" = "Considered",
			)
		) |>
		select(
			id = unitid,
			name = instnm,
			city,
			state = stabbr,
			zip,
			latitude,
			longitude,
			url = insturl,
			deg_predominant = preddeg,
			deg_highest = highdeg,
			control,
			starts_with("locale"),
			adm_req_test,
			is_hbcu = "hbcu",
			is_pbi = "pbi",
			is_annhi = "annhi",
			is_tribal = "tribal",
			is_aanapii = "aanapii",
			is_hsi = "hsi",
			is_nanti = "nanti",
			is_only_men = "menonly",
			is_only_women = "womenonly",
			is_only_distance = "distanceonly",
			religious_affiliation = relaffil,
		)
}

out_tidy_school <- function(
	school_tidy = tar_read("school_tidy"),
	output_file = "data/tidy/school.rds"
) {
	dir_create(path_dir(output_file))
	readr::write_rds(school_tidy, output_file)
	output_file
}

tidy_scorecard <- function(
	path_data_site_rds = tar_read("path_data_site_rds"),
	school_tidy = tar_read("school_tidy")
) {
	scorecard_site <- readr::read_rds(path_data_site_rds)
	school_vars <- tidy_school_vars(scorecard_site)

	scorecard_site |>
		select(-all_of(school_vars)) |>
		select(unitid, starts_with("student"), starts_with("admissions"), starts_with("cost"), everything()) |>
		# Keep only Title IV participating schools
		semi_join(school_tidy, by = join_by(unitid == id)) |>
		transmute(
			id = unitid,
			academic_year,
			n_undergrads = student_ugds,

			# Cost ----
			cost_avg = coalesce(cost_npt4_priv, cost_npt4_pub),
			cost_med_similar = cost_mdcost_pd,
			cost_med_overall = cost_mdcost_all,
			cost_avg_income_0_30k = coalesce(cost_npt41_priv, cost_npt41_pub),
			cost_avg_income_30_48k = coalesce(cost_npt42_priv, cost_npt42_pub),
			cost_avg_income_48_75k = coalesce(cost_npt43_priv, cost_npt43_pub),
			cost_avg_income_75_110k = coalesce(cost_npt44_priv, cost_npt44_pub),
			cost_avg_income_110k_plus = coalesce(cost_npt45_priv, cost_npt45_pub),

			# Earnings ----
			# Median earnings of students working and not enrolled 10 years after entry
			amt_earnings_med_10y = earnings_md_earn_wne_p10,
			# Median earnings of students working and not enrolled 10 years after entry
			amnt_earnings_med_10y_similar = earnings_mdearn_pd,
			# Overall median earnings of students working and not enrolled 10 years after entry
			amnt_earnings_med_10y_overall = earnings_mdearn_all,

			# Completion ----
			# Completion rate for first-time, full-time students at four-year institutions (100% of expected time to completion)
			rate_completion = completion_c100_4,
			# Median completion rate amongst insitutions with the same predominant degree category
			rate_completion_med_similar = completion_mdcomp_pd,
			# Overall median of completion rate
			rate_completion_med_overall = completion_mdcomp_all,

			# Admissions ----
			rate_admissions = admissions_adm_rate_supp,
			score_act_p25 = admissions_actcm25, # 25th percentile of the ACT cumulative score
			score_act_p75 = admissions_actcm75, # 75th percentile of the ACT cumulative score
			score_sat_verbal_p25 = admissions_satvr25, # 25th percentile of SAT scores at the institution (critical reading)
			score_sat_verbal_p75 = admissions_satvr75, # 75th percentile of SAT scores at the institution (critical reading)
			score_sat_math_p25 = admissions_satmt25, # 25th percentile of SAT scores at the institution (math)
			score_sat_math_p75 = admissions_satmt75, # 75th percentile of SAT scores at the institution (math)
		)
}

out_tidy_scorecard <- function(
	scorecard_tidy = tar_read("scorecard_tidy"),
	output_file = "data/tidy/scorecard.rds"
) {
	dir_create(path_dir(output_file))
	readr::write_rds(scorecard_tidy, output_file)
	output_file
}
