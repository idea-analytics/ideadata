# Tests for utility functions

# Credential management tests
test_that("get_creds returns list with expected elements", {
  # This test can run anywhere since it just reads environment variables
  creds <- ideadata:::get_creds()

  expect_type(creds, "list")
  expect_true(all(c("uid", "pwd", "driver") %in% names(creds)))
})

test_that("get_creds reads from environment variables", {
  # Save current values
  old_uid <- Sys.getenv("IDEA_RNA_DB_UID")
  old_pwd <- Sys.getenv("IDEA_RNA_DB_PWD")
  old_driver <- Sys.getenv("IDEA_RNA_ODBC_DRIVER")

  # Set test values
  Sys.setenv(IDEA_RNA_DB_UID = "test.user")
  Sys.setenv(IDEA_RNA_DB_PWD = "test_pwd")
  Sys.setenv(IDEA_RNA_ODBC_DRIVER = "test_driver")

  # Get credentials
  creds <- ideadata:::get_creds()

  expect_equal(creds$uid, "test.user")
  expect_equal(creds$pwd, "test_pwd")
  expect_equal(creds$driver, "test_driver")

  # Restore original values
  Sys.setenv(IDEA_RNA_DB_UID = old_uid)
  Sys.setenv(IDEA_RNA_DB_PWD = old_pwd)
  Sys.setenv(IDEA_RNA_ODBC_DRIVER = old_driver)
})

# PowerSchool utility function tests
test_that("calc_ps_termid calculates correctly for school year", {
  # Quarter 0 (whole year)
  expect_equal(calc_ps_termid(2024, 0), 2324)
  expect_equal(calc_ps_termid(2023, 0), 2223)

  # Individual quarters
  expect_equal(calc_ps_termid(2024, 1), 2301)
  expect_equal(calc_ps_termid(2024, 2), 2302)
  expect_equal(calc_ps_termid(2024, 3), 2303)
  expect_equal(calc_ps_termid(2024, 4), 2304)
})

test_that("calc_ps_termid handles edge cases", {
  # Year 2000
  expect_equal(calc_ps_termid(2000, 0), 1900)

  # Future year
  expect_equal(calc_ps_termid(2030, 0), 2930)

  # Past year
  expect_equal(calc_ps_termid(2010, 0), 1910)
})

test_that("calc_elapsed_weeks calculates correctly", {
  ref_date <- as.Date("2024-01-15")
  first_day <- as.Date("2024-01-01")

  weeks <- calc_elapsed_weeks(ref_date, first_day)
  expect_equal(weeks, 2) # 14 days = 2 weeks
})

test_that("calc_elapsed_weeks handles same date", {
  date <- as.Date("2024-01-01")

  weeks <- calc_elapsed_weeks(date, date)
  expect_equal(weeks, 0)
})

test_that("calc_elapsed_weeks handles date strings", {
  weeks <- calc_elapsed_weeks("2024-01-15", "2024-01-01")
  expect_equal(weeks, 2)
})

# Warehouse metadata tests
test_that("warehouse_meta_data exists and has correct structure", {
  # This assumes package has been loaded
  expect_true(exists("warehouse_meta_data"))

  data <- get("warehouse_meta_data")
  expect_s3_class(data, "tbl_df")

  expected_cols <- c("server_name", "database_name", "schema", "table_name")
  expect_true(all(expected_cols %in% colnames(data)))
})

test_that("warehouse_meta_data contains expected tables", {
  data <- get("warehouse_meta_data")

  # Should have Students table
  students_rows <- data %>%
    dplyr::filter(table_name == "Students")

  expect_true(nrow(students_rows) > 0)
})

test_that("view_warehouse_metadata returns tibble", {
  # Just test that it returns something without erroring
  # We can't test the viewer functionality in automated tests
  result <- ideadata::view_warehouse_metadata()

  expect_s3_class(result, "tbl_df")
})
