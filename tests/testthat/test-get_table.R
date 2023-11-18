library(testthat)

# Test cases for get_table function
test_that("get_table returns a tbl_sql object when unique table is found", {
  table <- get_table(.table_name = "Students",
                     .database_name = "PROD1",
                     .schema = "Schools",
                     .server_name = "REDACTED-SQLSERVER")
  expect_s3_class(table, "tbl_sql")
})

test_that("get_table returns NULL when multiple tables with the same name are found and provides useful info on the tables it found", {
  result <- get_table(.table_name = "Students")
  expect_equal(result, NULL)

  expect_snapshot(get_table(.table_name = "Students"))
})

# Test cases for id_tables_in_dbs function
test_that("id_tables_in_dbs returns a tibble with the correct columns", {
  result <- id_tables_in_dbs(.table_name = "Students")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("server_name", "database_name", "schema", "table_name") %in% colnames(result)))
})

test_that("id_tables_in_dbs returns filtered results when database_name and schema are provided", {
  result <- id_tables_in_dbs(.table_name = "Students",
                             .database_name = "PROD1",
                             .schema = "Schools")
  expect_s3_class(result, "tbl_df")
  expect_true(all(result$database_name == "PROD1" & result$schema == "Schools"))
})

test_that("id_tables_in_dbs returns filtered results when server_name is provided", {
  result <- id_tables_in_dbs(.table_name = "Students",
                             .server_name = "REDACTED-SQLSERVER")
  expect_s3_class(result, "tbl_df")
  expect_true(all(result$server_name == "REDACTED-SQLSERVER"))
})

