# ideadata Tests

This directory contains the test suite for the ideadata package.

## Quick Start

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_file("tests/testthat/test-get_table.R")

# Run with coverage
covr::package_coverage()
```

## Test Structure

```
tests/
├── testthat.R              # Test runner (standard)
└── testthat/
    ├── setup.R             # Environment detection and setup
    ├── helper.R            # Helper functions (skip_if_no_db, etc.)
    ├── test-connections.R  # Connection management tests
    ├── test-utils.R        # Utility function tests
    ├── test-get_table.R    # get_table() and metadata tests
    ├── test-data-functions.R  # Data retrieval (get_*) tests
    └── test-collector.R    # collector() function tests
```

## Important Notes

### Database Tests

Many tests require database connections and will **automatically skip** if:
- Not connected to IDEA network
- Credentials not configured
- Running in CI/CD environment

This is intentional and not a failure. Tests use `skip_if_no_db()` to skip gracefully.

### Running Tests Locally

**Prerequisites:**
1. Connected to VPN/IDEA network
2. Credentials configured:
   ```r
   library(ideadata)
   setup_creds()
   ```

**Run tests:**
```r
library(devtools)
test()
```

### Expected Output

You should see output like:
```
✓ | F W S  OK | Context
✓ |     10    10 | connections
✓ |      8     8 | utils
✓ |     15    15 | get_table
✓ |     25    25 | data-functions
✓ |     12    12 | collector
```

If database is unavailable:
```
✓ | F W S  OK | Context
✓ |     0 10   0 | connections [0.1s]
  (10 skipped)
```

## Test Categories

### Unit Tests (No Database Required)
- Utility functions (`calc_ps_termid`, `calc_elapsed_weeks`)
- Credential parsing
- Metadata structure validation

These run in CI/CD.

### Integration Tests (Database Required)
- Connection management
- Data retrieval (`get_*` functions)
- Query execution
- Collector function

These only run locally with database access.

## Troubleshooting

### Tests are skipping
```r
# Check credentials
Sys.getenv("IDEA_RNA_DB_UID")

# Check if skipping is forced
Sys.getenv("IDEADATA_SKIP_DB_TESTS")

# Try manual connection
con <- ideadata:::create_connection("PowerSchool", "RGVPDSD-DWPRD1")
DBI::dbIsValid(con)
```

### Connection errors
1. Are you on VPN?
2. Are credentials correct? Run `setup_creds()` again
3. Is ODBC driver installed?

## More Information

See [TESTING_GUIDE.md](../TESTING_GUIDE.md) for:
- Detailed testing approach
- Writing new tests
- CI/CD options
- Best practices
