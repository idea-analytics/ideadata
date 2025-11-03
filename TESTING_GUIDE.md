# ideadata Testing Guide

> **Purpose**: Guide for running and maintaining the test suite for ideadata package
> **Audience**: Package maintainers and contributors

---

## Overview

The `ideadata` package has a comprehensive test suite with a unique constraint: **tests requiring database access can only run on machines inside the IDEA network** (behind the firewall). This guide explains how the test suite handles this constraint and how to run tests locally.

---

## Test Architecture

### Test Categories

The test suite is organized into two categories:

#### 1. **Unit Tests** (No Database Required)
These tests can run anywhere, including CI/CD environments:
- Utility functions (`calc_ps_termid`, `calc_elapsed_weeks`)
- Credential reading/parsing
- Metadata structure validation
- Pure R functions with no database dependency

#### 2. **Integration Tests** (Database Required)
These tests require active database connections:
- Connection management
- Data retrieval functions (`get_*`)
- Query execution and collection
- Table lookups

### Smart Skip Logic

Tests automatically skip when database connections aren't available:

```r
test_that("get_students returns lazy query", {
  skip_if_no_db()  # Skips if no database connection

  result <- get_students()
  expect_lazy_query(result)
})
```

This means:
- ✅ Tests run successfully on local machines with credentials
- ✅ Tests skip gracefully in CI/CD environments
- ✅ No false failures from connection issues

---

## Running Tests Locally

### Prerequisites

1. **Connected to IDEA network** (VPN or on-site)
2. **Database credentials configured**:
   ```r
   library(ideadata)
   setup_creds()
   ```
3. **Package dependencies installed**:
   ```r
   devtools::install_deps(dependencies = TRUE)
   ```

### Run All Tests

```r
# Load package
library(devtools)

# Run complete test suite
test()

# Run with detailed output
test(reporter = "progress")

# Run with stop-on-failure
test(stop_on_failure = TRUE)
```

### Run Specific Test Files

```r
# Test a specific file
test_file("tests/testthat/test-get_table.R")

# Test actively edited file (in RStudio)
test_active_file()
```

### Run Only Unit Tests (No Database)

```r
# Set environment variable to skip all DB tests
Sys.setenv(IDEADATA_SKIP_DB_TESTS = "true")

# Run tests
test()

# Reset
Sys.setenv(IDEADATA_SKIP_DB_TESTS = "false")
```

### Test Coverage

```r
# Install covr if needed
install.packages("covr")

# Check test coverage
covr::package_coverage()

# View coverage report in browser
covr::report()
```

Expected coverage:
- **Unit tests**: 100% coverage (no skips)
- **Integration tests**: Coverage depends on database availability

---

## Test Files

### Core Test Files

```
tests/
├── testthat.R                    # Test runner (do not modify)
└── testthat/
    ├── setup.R                   # Environment setup (runs first)
    ├── helper.R                  # Helper functions for tests
    ├── test-connections.R        # Connection management tests
    ├── test-utils.R              # Utility function tests
    ├── test-get_table.R          # get_table() and metadata tests
    ├── test-data-functions.R     # Data retrieval functions (get_*)
    └── test-collector.R          # collector() function tests
```

### Setup Files

#### `setup.R`
Runs once before all tests:
- Detects CI environment
- Checks for database credentials
- Attempts test connection
- Sets `IDEADATA_SKIP_DB_TESTS` flag

#### `helper.R`
Provides helper functions:
- `skip_if_no_db()` - Skip test if no database
- `can_test_db()` - Check if database tests can run
- `get_test_connection()` - Get connection or skip
- `cleanup_test_connections()` - Clean up after tests
- `expect_lazy_query()` - Assert lazy query object
- `expect_collected_tibble()` - Assert collected tibble

---

## Writing New Tests

### Pattern 1: Unit Test (No Database)

```r
test_that("calc_ps_termid calculates correctly", {
  # No skip needed - pure R function
  result <- calc_ps_termid(2024, 1)
  expect_equal(result, 2301)
})
```

### Pattern 2: Integration Test (Database Required)

```r
test_that("get_students returns lazy query", {
  skip_if_no_db()  # Skip if database unavailable

  result <- get_students()
  expect_lazy_query(result)
})
```

### Pattern 3: Test with Data Collection

```r
test_that("get_students can be filtered and collected", {
  skip_if_no_db()

  result <- get_students() %>%
    filter(grade_level == 9) %>%
    head(10) %>%
    collect()

  expect_collected_tibble(result)
  expect_true(nrow(result) <= 10)
})
```

### Pattern 4: Test with Connection Cleanup

```r
test_that("connection is created and reused", {
  skip_if_no_db()

  # Your test code here

  # Clean up connections at end
  cleanup_test_connections()
})
```

---

## CI/CD Options

### Current Constraint

Standard CI/CD platforms (GitHub Actions, Travis CI, CircleCI) cannot access IDEA's internal databases because they run outside the firewall.

### Option 1: Self-Hosted GitHub Actions Runner (Recommended)

Set up a GitHub Actions runner on a machine inside IDEA network.

#### Advantages
- ✅ Automated testing on every push/PR
- ✅ Full test suite runs (including database tests)
- ✅ Familiar GitHub Actions workflow
- ✅ Can run on schedule (nightly, etc.)

#### Setup Steps

1. **Provision a Windows/Mac/Linux machine inside IDEA network**
   - Dedicated VM or physical machine
   - Connected to VPN or on-site
   - Stable, always-on

2. **Install self-hosted runner**:
   ```bash
   # On the internal machine:
   # 1. Go to GitHub repo > Settings > Actions > Runners
   # 2. Click "New self-hosted runner"
   # 3. Follow instructions to download and configure
   ```

3. **Configure runner**:
   ```bash
   # Set up credentials (one-time)
   # Create .Renviron in runner's home directory
   IDEA_RNA_DB_UID=your_service_account
   IDEA_RNA_DB_PWD=your_password
   IDEA_RNA_ODBC_DRIVER=ODBC Driver 17 for SQL Server
   ```

4. **Create workflow** (`.github/workflows/R-CMD-check.yaml`):
   ```yaml
   name: R-CMD-check

   on:
     push:
       branches: [main, dev]
     pull_request:
       branches: [main]

   jobs:
     check:
       runs-on: self-hosted  # Use self-hosted runner

       steps:
         - uses: actions/checkout@v3

         - name: Install R dependencies
           run: |
             Rscript -e "install.packages('remotes')"
             Rscript -e "remotes::install_deps(dependencies = TRUE)"

         - name: Check package
           run: Rscript -e "devtools::check()"

         - name: Run tests
           run: Rscript -e "devtools::test()"
   ```

#### Security Considerations
- Use a **service account** (not personal credentials)
- Limit runner access to only this repository
- Monitor runner logs for security issues
- Keep runner software updated

---

### Option 2: Cloud CI with Unit Tests Only

Run only unit tests (non-database) in cloud CI.

#### Advantages
- ✅ No infrastructure setup needed
- ✅ Free with GitHub Actions
- ✅ Catches pure R logic errors

#### Disadvantages
- ⚠️ Doesn't test database integration
- ⚠️ Limited coverage

#### Setup

`.github/workflows/R-CMD-check.yaml`:
```yaml
name: R-CMD-check

on:
  push:
    branches: [main, dev]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: r-lib/actions/setup-r@v2

      - name: Install dependencies
        run: |
          install.packages('remotes')
          remotes::install_deps(dependencies = TRUE)
        shell: Rscript {0}

      - name: Check package
        run: |
          devtools::check(error_on = "warning")
        shell: Rscript {0}

      - name: Run unit tests only
        run: |
          Sys.setenv(IDEADATA_SKIP_DB_TESTS = "true")
          devtools::test()
        shell: Rscript {0}
```

---

### Option 3: Pre-commit Hook (Local Testing)

Run tests locally before allowing commits.

#### Setup

`.git/hooks/pre-commit`:
```bash
#!/bin/bash

echo "Running tests before commit..."

# Run tests
Rscript -e "
if (devtools::test()) {
  cat('✓ Tests passed\n')
  quit(status = 0)
} else {
  cat('✗ Tests failed - commit aborted\n')
  quit(status = 1)
}
"

# Check exit code
if [ $? -ne 0 ]; then
  exit 1
fi
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

### Option 4: Manual Pre-Release Testing

Require manual test runs before releases.

#### Release Checklist

```markdown
## Pre-Release Testing Checklist

- [ ] Run full test suite locally: `devtools::test()`
- [ ] Check test coverage: `covr::package_coverage()`
- [ ] Run R CMD check: `devtools::check()`
- [ ] Test on Windows machine
- [ ] Test on macOS machine
- [ ] Test with fresh credentials
- [ ] Verify all database functions work
- [ ] Test collector() with large dataset
```

---

## Continuous Integration Recommendation

**For IDEA's use case, we recommend: Option 1 (Self-Hosted Runner)**

### Why?

1. **Complete coverage**: Tests all functionality, including database integration
2. **Automated**: No manual intervention needed
3. **Fast feedback**: Developers know immediately if their code breaks tests
4. **Scalable**: Can add more runners if needed
5. **Familiar**: Uses standard GitHub Actions workflow

### Implementation Timeline

- **Week 1**: Provision internal machine, install runner
- **Week 2**: Configure credentials, test workflow
- **Week 3**: Enable for pull requests
- **Week 4**: Monitor and refine

### Estimated Cost

- **Hardware**: $500-1000 (if new machine needed) or $0 (repurpose existing)
- **Maintenance**: ~1 hour/month
- **ROI**: Catches bugs before release, saves debugging time

---

## Troubleshooting Tests

### Tests are skipping but you have credentials

```r
# Check credentials are set
Sys.getenv("IDEA_RNA_DB_UID")
Sys.getenv("IDEA_RNA_DB_PWD")

# Check skip flag
Sys.getenv("IDEADATA_SKIP_DB_TESTS")

# Manually set to allow tests
Sys.setenv(IDEADATA_SKIP_DB_TESTS = "false")

# Run tests again
devtools::test()
```

### Connection tests fail

```r
# Test connection manually
library(ideadata)

con <- ideadata:::create_connection(
  .database_name = "PowerSchool",
  .server_name = "REDACTED-SQLSERVER"
)

DBI::dbIsValid(con)
```

Check:
1. Are you on VPN?
2. Are credentials correct?
3. Is ODBC driver installed?
4. Can you run `kinit` successfully (Mac/Linux)?

### Tests hang

Some tests may take time if database is slow. Add timeout:

```r
test_that("slow query completes", {
  skip_if_no_db()

  # Set timeout (in seconds)
  setTimeLimit(elapsed = 30)

  result <- get_large_table() %>%
    head(1000) %>%
    collect()

  # Reset timeout
  setTimeLimit(elapsed = Inf)

  expect_collected_tibble(result)
})
```

### Clean up stuck connections

```r
# Find and close all connections
cleanup_test_connections()

# Or manually
cons <- ls(envir = .GlobalEnv, pattern = "^conn_")
for (con_name in cons) {
  con <- get(con_name, envir = .GlobalEnv)
  try(DBI::dbDisconnect(con), silent = TRUE)
  rm(list = con_name, envir = .GlobalEnv)
}
```

---

## Best Practices

### ✅ Do

- **Always use `skip_if_no_db()`** for database-dependent tests
- **Test both lazy and collected queries**
- **Use small datasets** (`head(10)`) for faster tests
- **Clean up connections** after tests
- **Use descriptive test names**
- **Test edge cases** (empty results, invalid inputs)
- **Group related tests** in same file

### ❌ Don't

- **Don't assume database is always available**
- **Don't leave connections open**
- **Don't pull large datasets** in tests
- **Don't test production data quality** (test package functionality)
- **Don't rely on specific data values** (data changes)
- **Don't use hardcoded credentials** in tests

---

## Adding Tests for New Features

When adding a new `get_*()` function:

```r
# In tests/testthat/test-data-functions.R

test_that("get_new_data returns lazy query", {
  skip_if_no_db()

  result <- get_new_data()
  expect_lazy_query(result)
})

test_that("get_new_data can be collected", {
  skip_if_no_db()

  result <- get_new_data() %>%
    head(5) %>%
    collect()

  expect_collected_tibble(result)
  expect_true(nrow(result) <= 5)
})

test_that("get_new_data can be filtered", {
  skip_if_no_db()

  result <- get_new_data() %>%
    filter(year == 2024) %>%
    head(5) %>%
    collect()

  expect_collected_tibble(result)

  if (nrow(result) > 0) {
    expect_equal(unique(result$year), 2024)
  }
})
```

---

## Test Metrics

### Current Coverage

Run to get current metrics:
```r
covr::package_coverage()
```

### Goals

- **Unit Tests**: 100% coverage
- **Integration Tests**: 80%+ coverage (when database available)
- **Overall**: 85%+ coverage

### Tracking

Track test metrics over time:
```r
# Generate coverage report
cov <- covr::package_coverage()

# Save for tracking
saveRDS(cov, sprintf("coverage_%s.rds", Sys.Date()))

# Compare to previous
old_cov <- readRDS("coverage_2024-01-01.rds")
covr::percent_coverage(cov) - covr::percent_coverage(old_cov)
```

---

## Resources

- **testthat documentation**: https://testthat.r-lib.org/
- **R Packages book - Testing**: https://r-pkgs.org/testing-basics.html
- **GitHub Actions for R**: https://github.com/r-lib/actions
- **Self-hosted runners**: https://docs.github.com/en/actions/hosting-your-own-runners

---

**Last Updated**: 2024
**Maintained by**: IDEA Analytics Team
