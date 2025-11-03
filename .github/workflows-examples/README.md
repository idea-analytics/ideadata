# GitHub Actions Workflow Examples

This directory contains example GitHub Actions workflows for the ideadata package.

## Available Workflows

### 1. `self-hosted-full-tests.yaml` (Recommended)

**Runs:** Full test suite including database integration tests
**Where:** Self-hosted runner inside IDEA network
**Best for:** Complete test coverage with automated CI/CD

#### Setup Instructions

1. **Provision a machine inside IDEA network:**
   - Windows, macOS, or Linux
   - Stable, always-on
   - Connected to VPN or on-site

2. **Install GitHub self-hosted runner:**
   ```bash
   # On GitHub:
   # Go to: Repository > Settings > Actions > Runners > New self-hosted runner
   # Follow the installation instructions provided
   ```

3. **Configure database credentials on runner:**
   ```bash
   # Create .Renviron in runner's home directory
   # Windows: C:\Users\<runner-user>\.Renviron
   # Mac/Linux: ~/.Renviron
   ```

   Add:
   ```
   IDEA_RNA_DB_UID=service_account_username
   IDEA_RNA_DB_PWD=service_account_password
   IDEA_RNA_ODBC_DRIVER=ODBC Driver 17 for SQL Server
   ```

4. **Install ODBC driver on runner:**
   - Download from: https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server

5. **Activate workflow:**
   ```bash
   # Move workflow to active directory
   mv .github/workflows-examples/self-hosted-full-tests.yaml .github/workflows/

   # Commit and push
   git add .github/workflows/self-hosted-full-tests.yaml
   git commit -m "Enable self-hosted CI/CD with full test suite"
   git push
   ```

**Security Notes:**
- Use a service account (not personal credentials)
- Limit runner to this repository only
- Monitor runner logs regularly
- Keep runner software updated

---

### 2. `cloud-unit-tests-only.yaml`

**Runs:** Unit tests only (skips database tests)
**Where:** GitHub's cloud runners (Ubuntu, Windows, macOS)
**Best for:** Quick setup, no infrastructure needed

#### Setup Instructions

1. **Activate workflow:**
   ```bash
   mv .github/workflows-examples/cloud-unit-tests-only.yaml .github/workflows/

   git add .github/workflows/cloud-unit-tests-only.yaml
   git commit -m "Enable cloud CI/CD with unit tests"
   git push
   ```

That's it! No additional setup required.

**Limitations:**
- Only tests non-database functionality (~30-40% of tests)
- Doesn't catch database integration issues
- Good for catching basic R logic errors

---

## Which Workflow Should You Use?

| Scenario | Recommended Workflow |
|----------|---------------------|
| **You have resources for a self-hosted runner** | `self-hosted-full-tests.yaml` |
| **You want complete test coverage** | `self-hosted-full-tests.yaml` |
| **You want zero setup** | `cloud-unit-tests-only.yaml` |
| **You want quick feedback on R syntax/logic** | `cloud-unit-tests-only.yaml` |
| **Budget/time constrained** | `cloud-unit-tests-only.yaml` (for now) |

### Our Recommendation: Self-Hosted Runner

For production use of ideadata, we strongly recommend the self-hosted runner approach because:
- ✅ Tests all functionality (including database integration)
- ✅ Catches issues before they reach users
- ✅ Provides confidence in releases
- ✅ Minimal ongoing maintenance (~1 hour/month)

Initial setup time: ~4-8 hours

---

## Testing Locally

You don't need CI/CD to run tests. Run locally anytime:

```r
# Load package
library(devtools)

# Run all tests
test()

# Run with coverage
covr::package_coverage()
```

See [TESTING_GUIDE.md](../../TESTING_GUIDE.md) for more details.

---

## Troubleshooting

### Self-hosted runner not picking up jobs

1. Check runner status:
   ```bash
   # On runner machine
   cd actions-runner
   ./run.sh
   ```

2. Verify runner is online:
   - Go to: Repository > Settings > Actions > Runners
   - Should show "Idle" (green)

3. Check runner logs:
   ```bash
   # On runner machine
   cat actions-runner/_diag/Runner_*.log
   ```

### Tests failing on runner but passing locally

1. Check credentials on runner:
   ```r
   # SSH into runner, then:
   Sys.getenv("IDEA_RNA_DB_UID")
   Sys.getenv("IDEA_RNA_DB_PWD")
   ```

2. Test connection on runner:
   ```r
   library(ideadata)
   con <- ideadata:::create_connection("PowerSchool", "RGVPDSD-DWPRD1")
   DBI::dbIsValid(con)
   ```

3. Check network connectivity:
   - Is runner on VPN?
   - Can it reach SQL Server?

---

## Resources

- [GitHub self-hosted runners docs](https://docs.github.com/en/actions/hosting-your-own-runners)
- [GitHub Actions for R](https://github.com/r-lib/actions)
- [ideadata TESTING_GUIDE.md](../../TESTING_GUIDE.md)
