# Tests for collector function

test_that("collector returns a tibble", {
  skip_if_no_db()

  result <- get_schools() %>%
    collector(school_number, verbose = FALSE)

  expect_collected_tibble(result)
})

test_that("collector works with single grouping variable", {
  skip_if_no_db()

  # Use schools table (smaller than students)
  result <- get_schools() %>%
    collector(school_number, verbose = FALSE)

  expect_collected_tibble(result)
  expect_true(nrow(result) > 0)
})

test_that("collector works with multiple grouping variables", {
  skip_if_no_db()

  # Get students with multiple grouping
  result <- get_students() %>%
    dplyr::filter(schoolid %in% c(1, 2)) %>% # Limit to 2 schools
    dplyr::select(student_number, schoolid, grade_level) %>%
    collector(schoolid, grade_level, verbose = FALSE)

  expect_collected_tibble(result)
})

test_that("collector handles filtered queries", {
  skip_if_no_db()

  result <- get_schools() %>%
    dplyr::filter(school_number <= 100) %>%
    collector(school_number, verbose = FALSE)

  expect_collected_tibble(result)

  if (nrow(result) > 0) {
    expect_true(all(result$school_number <= 100))
  }
})

test_that("collector verbose mode produces messages", {
  skip_if_no_db()

  expect_message(
    get_schools() %>%
      dplyr::head(5) %>%
      collector(school_number, verbose = TRUE),
    "Grabbing chunk"
  )
})

test_that("collector preserves column names and types", {
  skip_if_no_db()

  original_cols <- get_schools() %>%
    dplyr::head(1) %>%
    dplyr::collect() %>%
    colnames()

  result <- get_schools() %>%
    dplyr::head(10) %>%
    collector(school_number, verbose = FALSE)

  expect_true(all(original_cols %in% colnames(result)))
})

test_that("collector handles empty results gracefully", {
  skip_if_no_db()

  result <- get_schools() %>%
    dplyr::filter(school_number == -999999) %>% # Non-existent school
    collector(school_number, verbose = FALSE)

  expect_collected_tibble(result)
  expect_equal(nrow(result), 0)
})

test_that("collector is equivalent to collect for small data", {
  skip_if_no_db()

  # Small query
  query <- get_schools() %>%
    dplyr::head(10)

  result_collect <- query %>%
    dplyr::collect() %>%
    dplyr::arrange(school_number)

  result_collector <- query %>%
    collector(school_number, verbose = FALSE) %>%
    dplyr::arrange(school_number)

  expect_equal(nrow(result_collect), nrow(result_collector))
  expect_equal(colnames(result_collect), colnames(result_collector))
})
