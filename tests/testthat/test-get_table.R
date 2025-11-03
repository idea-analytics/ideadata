# Tests for get_table and related functions

# Database-dependent tests
test_that("get_table returns a tbl_sql object when unique table is found", {
  skip_if_no_db()

  table <- get_table(.table_name = "Students",
                     .database_name = "PROD1",
                     .schema = "Schools",
                     .server_name = "RGVPDSD-DWPRD1")
  expect_lazy_query(table)
})

test_that("get_table can be collected into a tibble", {
  skip_if_no_db()

  result <- get_table(.table_name = "Students",
                     .database_name = "PROD1",
                     .schema = "Schools",
                     .server_name = "RGVPDSD-DWPRD1") %>%
    dplyr::head(5) %>%
    dplyr::collect()

  expect_collected_tibble(result)
  expect_true(nrow(result) <= 5)
})

test_that("get_table returns NULL when multiple tables with the same name are found and provides useful info", {
  skip_if_no_db()

  result <- get_table(.table_name = "Students")
  expect_equal(result, NULL)

  expect_snapshot(get_table(.table_name = "Students"))
})

test_that("get_table handles non-existent tables gracefully", {
  skip_if_no_db()

  expect_error(
    get_table(.table_name = "NonExistentTable12345"),
    "No table named"
  )
})

# Metadata tests (can run without live DB if warehouse_meta_data is loaded)
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

  if (nrow(result) > 0) {
    expect_true(all(result$database_name == "PROD1" & result$schema == "Schools"))
  }
})

test_that("id_tables_in_dbs returns filtered results when server_name is provided", {
  result <- id_tables_in_dbs(.table_name = "Students",
                             .server_name = "RGVPDSD-DWPRD1")
  expect_s3_class(result, "tbl_df")

  if (nrow(result) > 0) {
    expect_true(all(result$server_name == "RGVPDSD-DWPRD1"))
  }
})

test_that("id_tables_in_dbs handles non-existent tables", {
  result <- id_tables_in_dbs(.table_name = "NonExistentTable12345")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

