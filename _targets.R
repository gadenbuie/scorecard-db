# Targets: https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# ---- Pipeline Packages ----
library(targets)
library(tarchetypes)

pkg_deps <- desc::desc_get_deps()
pkg_deps <- pkg_deps[pkg_deps$type == "Depends", ]$package

# ---- Targets Options ----
tar_option_set(
  # Packages that your targets need for their tasks
  packages = setdiff(pkg_deps, "targets"),
  format = "rds",
  controller = crew::crew_controller_local(workers = 4, seconds_idle = 60),
  NULL
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Build Targets ----------------------------------------------------------------
list(
  # Data download ----
  tar_url("url_data_zip", cs_url_data_zip()),
  tar_target(
    "path_data_zip",
    cs_data_raw_download(url_data_zip, "data-raw"),
    format = "file"
  ),
  tar_target(
    "path_data_raw",
    cs_data_raw_extract(path_data_zip),
    format = "file"
  ),
  tar_target(
    "path_data_raw_merged",
    cs_data_raw_ls_merged(path_data_raw),
    format = "file"
  ),
  tar_target(
    "path_data_raw_yaml",
    cs_data_raw_ls_yaml(path_data_raw),
    format = "file"
  ),
  tar_target(
    "path_data_raw_dictionary",
    cs_data_raw_ls_dictionary(path_data_raw),
    format = "file"
  ),
  # Data sets ----
  tar_target(
    "data_dictionary",
    dd_read_institution(path_data_raw_dictionary),
    format = "rds"
  ),
  # Outputs ----
  # Outputs: Full ---
  tar_target(
    "path_data_full_merged",
    out_full_merged_parquet(path_data_raw_merged, data_dictionary),
    format = "file"
  ),
  tar_target(
    "path_data_full_info",
    out_full_info_parquet(data_dictionary),
    format = "file"
  ),
  tar_target(
    "path_data_full_labels",
    out_full_labels_parquet(data_dictionary),
    format = "file"
  ),
  # Outputs: Used on site ----
  tar_target(
    "path_data_site_parquet",
    out_used_on_site_parquet(data_dictionary, path_data_full_merged),
    format = "file"
  ),
  tar_target(
    "path_data_site_csv",
    out_used_on_site_csv(path_data_site_parquet),
    format = "file"
  ),
  tar_target(
    "path_data_site_rds",
    out_used_on_site_rds(data_dictionary, path_data_full_merged),
    format = "file"
  ),
  tar_target(
    "path_data_site_sqlite",
    out_used_on_site_sqlite(path_data_site_parquet, path_data_full_info, path_data_full_labels),
    format = "file"
  ),

  # Outputs: Tidied ----
  tar_target("school_tidy", tidy_school(path_data_site_rds)),
  tar_target("scorecard_tidy", tidy_scorecard(path_data_site_rds, school_tidy)),
  tar_target("path_data_tidy_school", out_tidy_school(school_tidy), format = "file"),
  tar_target("path_data_tidy_scorecard", out_tidy_scorecard(scorecard_tidy), format = "file"),

  # Outputs: Package ----
  tar_target(
    "path_data_pkg_school",
    usethis::with_project("pkg", {
      school <- school_tidy
      usethis::use_data(school, overwrite = TRUE)
      "pkg/data/school.rda"
    }),
    format = "file"
  ),
  tar_target(
    "path_data_pkg_scorecard",
    usethis::with_project("pkg", {
      scorecard <- scorecard_tidy
      usethis::use_data(scorecard, overwrite = TRUE)
      "pkg/data/scorecard.rda"
    }),
    format = "file"
  ),
  tar_target("path_data_pkg_data_dictionary", {
    saveRDS(data_dictionary, "pkg/inst/scorecard-data-dictionary.rds")
  }),
  tar_target(
    "path_data_pkg_docs",
    usethis::with_project("pkg", {
      path_data_pkg_school
      path_data_pkg_scorecard

      usethis::use_tidy_description()
      devtools::document()
      fs::dir_ls("man")
    }),
  ),

  NULL
)
