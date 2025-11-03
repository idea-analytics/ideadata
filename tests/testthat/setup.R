# Test Environment Setup
# This file runs once before all tests

# Detect if we're in a CI environment
is_ci <- function() {
  isTRUE(as.logical(Sys.getenv("CI", "false"))) ||
    nzchar(Sys.getenv("GITHUB_ACTIONS")) ||
    nzchar(Sys.getenv("TRAVIS")) ||
    nzchar(Sys.getenv("APPVEYOR")) ||
    nzchar(Sys.getenv("CIRCLECI"))
}

# Detect if we have database credentials configured
has_db_creds <- function() {
  uid <- Sys.getenv("IDEA_RNA_DB_UID", "")
  pwd <- Sys.getenv("IDEA_RNA_DB_PWD", "")
  driver <- Sys.getenv("IDEA_RNA_ODBC_DRIVER", "")

  all(nzchar(c(uid, pwd, driver)))
}

# Set testing flags
Sys.setenv(IDEADATA_TESTING = "true")

if (is_ci()) {
  message("Running in CI environment - database tests will be skipped")
  Sys.setenv(IDEADATA_SKIP_DB_TESTS = "true")
} else if (!has_db_creds()) {
  message("Database credentials not configured - database tests will be skipped")
  message("Run setup_creds() to configure credentials for testing")
  Sys.setenv(IDEADATA_SKIP_DB_TESTS = "true")
} else {
  message("Database credentials found - running full test suite")
  Sys.setenv(IDEADATA_SKIP_DB_TESTS = "false")

  # Try to establish test connection
  tryCatch({
    # Test connection to PowerSchool database
    test_con <- ideadata:::create_connection(
      .database_name = "PowerSchool",
      .server_name = "REDACTED-SQLSERVER"
    )

    if (DBI::dbIsValid(test_con)) {
      message("✓ Test database connection successful")
      DBI::dbDisconnect(test_con)
    }
  }, error = function(e) {
    message("✗ Database connection failed - database tests will be skipped")
    message("Error: ", e$message)
    Sys.setenv(IDEADATA_SKIP_DB_TESTS = "true")
  })
}

# Create test data directory if needed
test_data_dir <- file.path("testdata")
if (!dir.exists(test_data_dir)) {
  dir.create(test_data_dir, recursive = TRUE)
}
