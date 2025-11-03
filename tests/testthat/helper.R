# Test Helper Functions
# These functions are available to all tests

#' Skip test if database tests should be skipped
#'
#' @param message Optional custom skip message
skip_if_no_db <- function(message = "Database connection not available") {
  if (identical(Sys.getenv("IDEADATA_SKIP_DB_TESTS"), "true")) {
    testthat::skip(message)
  }
}

#' Check if we can run database tests
#'
#' @return Logical
can_test_db <- function() {
  !identical(Sys.getenv("IDEADATA_SKIP_DB_TESTS"), "true")
}

#' Skip if in CI environment
skip_if_ci <- function(message = "Not running in CI") {
  if (isTRUE(as.logical(Sys.getenv("CI", "false")))) {
    testthat::skip(message)
  }
}

#' Create mock warehouse metadata for testing
#'
#' @return A tibble with mock metadata
mock_warehouse_metadata <- function() {
  tibble::tibble(
    server_name = c(
      "REDACTED-SQLSERVER", "REDACTED-SQLSERVER", "REDACTED-SQLSERVER",
      "REDACTED-SQLSERVER", "REDACTED-SQLSERVER"
    ),
    database_name = c(
      "PowerSchool", "Documentation", "Assessment",
      "PowerSchool", "Assessment"
    ),
    schema = c(
      "dbo", "dbo", "dbo",
      "Schools", "dbo"
    ),
    table_name = c(
      "Students", "Metadata", "TestScores",
      "Students", "IABResults"
    )
  )
}

#' Expect a lazy tbl_sql object
#'
#' @param object Object to test
expect_lazy_query <- function(object) {
  testthat::expect_s3_class(object, "tbl_sql")
  testthat::expect_true("tbl_lazy" %in% class(object))
}

#' Expect a collected tibble
#'
#' @param object Object to test
expect_collected_tibble <- function(object) {
  testthat::expect_s3_class(object, "tbl_df")
  testthat::expect_false("tbl_sql" %in% class(object))
}

#' Get test connection or skip
#'
#' @param database_name Database name
#' @param server_name Server name
#' @return Connection object
get_test_connection <- function(database_name = "PowerSchool",
                                server_name = "REDACTED-SQLSERVER") {
  skip_if_no_db()

  tryCatch({
    con <- ideadata:::create_connection(
      .database_name = database_name,
      .server_name = server_name
    )

    if (!DBI::dbIsValid(con)) {
      testthat::skip("Invalid database connection")
    }

    con
  }, error = function(e) {
    testthat::skip(paste("Failed to create connection:", e$message))
  })
}

#' Clean up test connections
#'
#' Disconnects all connections in global environment
cleanup_test_connections <- function() {
  # Find all connection objects
  conn_names <- ls(envir = .GlobalEnv, pattern = "^conn_")

  for (conn_name in conn_names) {
    tryCatch({
      conn <- get(conn_name, envir = .GlobalEnv)
      if (DBI::dbIsValid(conn)) {
        DBI::dbDisconnect(conn)
      }
      rm(list = conn_name, envir = .GlobalEnv)
    }, error = function(e) {
      # Silently fail - connection may already be closed
    })
  }
}

#' Create a temporary test .Renviron file
#'
#' @param uid User ID
#' @param pwd Password
#' @param driver ODBC driver name
#' @return Path to temporary file
create_test_renviron <- function(uid = "test.user",
                                pwd = "test_password",
                                driver = "ODBC Driver 17 for SQL Server") {
  temp_file <- tempfile(fileext = ".Renviron")

  writeLines(c(
    paste0("IDEA_RNA_DB_UID=", uid),
    paste0("IDEA_RNA_DB_PWD=", pwd),
    paste0("IDEA_RNA_ODBC_DRIVER=", driver)
  ), temp_file)

  temp_file
}
