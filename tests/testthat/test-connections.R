# Tests for connection management functions

test_that("create_connection creates valid connection", {
  skip_if_no_db()

  con <- ideadata:::create_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  expect_s4_class(con, "Microsoft SQL Server")
  expect_true(DBI::dbIsValid(con))

  # Clean up
  DBI::dbDisconnect(con)
})

test_that("create_connection fails gracefully with invalid credentials", {
  skip_if_no_db()

  # Save current credentials
  old_uid <- Sys.getenv("IDEA_RNA_DB_UID")
  old_pwd <- Sys.getenv("IDEA_RNA_DB_PWD")

  # Set invalid credentials
  Sys.setenv(IDEA_RNA_DB_UID = "invalid_user")
  Sys.setenv(IDEA_RNA_DB_PWD = "invalid_password")

  # Should error
  expect_error(
    ideadata:::create_connection(
      .database_name = "PowerSchool",
      .server_name = "REDACTED-SQLSERVER"
    )
  )

  # Restore credentials
  Sys.setenv(IDEA_RNA_DB_UID = old_uid)
  Sys.setenv(IDEA_RNA_DB_PWD = old_pwd)
})

test_that("check_get_connection returns existing valid connection", {
  skip_if_no_db()

  # Create a connection
  con1 <- ideadata:::check_get_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  expect_true(DBI::dbIsValid(con1))

  # Call again - should return same connection
  con2 <- ideadata:::check_get_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  expect_true(DBI::dbIsValid(con2))

  # Should be stored in global environment
  expect_true(exists("conn_PowerSchool", envir = .GlobalEnv))

  # Clean up
  cleanup_test_connections()
})

test_that("check_get_connection creates new connection if none exists", {
  skip_if_no_db()

  # Ensure no connection exists
  cleanup_test_connections()

  # Create connection
  con <- ideadata:::check_get_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  expect_true(DBI::dbIsValid(con))
  expect_true(exists("conn_PowerSchool", envir = .GlobalEnv))

  # Clean up
  cleanup_test_connections()
})

test_that("check_get_connection recreates invalid connection", {
  skip_if_no_db()

  # Create and then invalidate a connection
  con <- ideadata:::create_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  assign("conn_PowerSchool", con, envir = .GlobalEnv)
  DBI::dbDisconnect(con)

  # Should create new connection since old one is invalid
  con_new <- ideadata:::check_get_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  expect_true(DBI::dbIsValid(con_new))

  # Clean up
  cleanup_test_connections()
})

test_that("disconnect closes connection and removes from environment", {
  skip_if_no_db()

  # Create connection
  con <- ideadata:::create_connection(
    .database_name = "PowerSchool",
    .server_name = "REDACTED-SQLSERVER"
  )

  conn_name <- "conn_PowerSchool"
  assign(conn_name, con, envir = .GlobalEnv)

  # Disconnect
  ideadata::disconnect(con)

  # Connection should be closed
  expect_false(DBI::dbIsValid(con))

  # Should be removed from environment
  expect_false(exists(conn_name, envir = .GlobalEnv))
})
