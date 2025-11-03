# Tests for data retrieval functions (get_* functions)

# PowerSchool data functions
test_that("get_students returns lazy query", {
  skip_if_no_db()

  result <- get_students()
  expect_lazy_query(result)
})

test_that("get_students can be collected", {
  skip_if_no_db()

  result <- get_students() %>%
    dplyr::head(10) %>%
    dplyr::collect()

  expect_collected_tibble(result)
  expect_true(nrow(result) <= 10)
})

test_that("get_students can be filtered", {
  skip_if_no_db()

  result <- get_students() %>%
    dplyr::filter(grade_level == 9) %>%
    dplyr::head(5) %>%
    dplyr::collect()

  expect_collected_tibble(result)

  if (nrow(result) > 0) {
    expect_true(all(result$grade_level == 9))
  }
})

test_that("get_schools returns lazy query", {
  skip_if_no_db()

  result <- get_schools()
  expect_lazy_query(result)
})

test_that("get_schools can be collected", {
  skip_if_no_db()

  result <- get_schools() %>%
    dplyr::collect()

  expect_collected_tibble(result)
  expect_true(nrow(result) > 0)
})

test_that("get_regions returns lazy query", {
  skip_if_no_db()

  result <- get_regions()
  expect_lazy_query(result)
})

test_that("get_currently_enrolled_students returns lazy query", {
  skip_if_no_db()

  result <- get_currently_enrolled_students()
  expect_lazy_query(result)
})

test_that("get_student_daily_attendance returns lazy query", {
  skip_if_no_db()

  result <- get_student_daily_attendance()
  expect_lazy_query(result)
})

test_that("get_student_daily_attendance can be filtered by date", {
  skip_if_no_db()

  result <- get_student_daily_attendance() %>%
    dplyr::filter(att_date >= "2024-01-01",
                  att_date <= "2024-01-31") %>%
    dplyr::head(5) %>%
    dplyr::collect()

  expect_collected_tibble(result)

  if (nrow(result) > 0) {
    expect_true(all(result$att_date >= as.Date("2024-01-01")))
    expect_true(all(result$att_date <= as.Date("2024-01-31")))
  }
})

# Assessment data functions
test_that("get_iabwa returns lazy query", {
  skip_if_no_db()

  result <- get_iabwa()
  expect_lazy_query(result)
})

test_that("get_renstar_math returns lazy query", {
  skip_if_no_db()

  result <- get_renstar_math()
  expect_lazy_query(result)
})

test_that("get_renstar_reading returns lazy query", {
  skip_if_no_db()

  result <- get_renstar_reading()
  expect_lazy_query(result)
})

# Survey data functions
test_that("get_aees_questions returns lazy query", {
  skip_if_no_db()

  result <- get_aees_questions()
  expect_lazy_query(result)
})

test_that("get_aees_results returns lazy query", {
  skip_if_no_db()

  result <- get_aees_results()
  expect_lazy_query(result)
})

test_that("get_gptw_questions returns lazy query", {
  skip_if_no_db()

  result <- get_gptw_questions()
  expect_lazy_query(result)
})

# Persistence functions
test_that("get_persistence_historical returns lazy query", {
  skip_if_no_db()

  result <- get_persistence_historical()
  expect_lazy_query(result)
})

test_that("get_persistence_code returns lazy query", {
  skip_if_no_db()

  result <- get_persistence_code()
  expect_lazy_query(result)
})

# Learning location
test_that("get_learning_location returns lazy query", {
  skip_if_no_db()

  result <- get_learning_location()
  expect_lazy_query(result)
})

# Integration test: joining tables
test_that("can join students with schools", {
  skip_if_no_db()

  result <- get_students() %>%
    dplyr::inner_join(get_schools(), by = "schoolid") %>%
    dplyr::head(5) %>%
    dplyr::collect()

  expect_collected_tibble(result)

  # Should have columns from both tables
  expect_true("student_number" %in% colnames(result))
  expect_true("name" %in% colnames(result)) # school name
})

test_that("can filter students by school", {
  skip_if_no_db()

  # Get a school ID first
  schools <- get_schools() %>%
    dplyr::head(1) %>%
    dplyr::collect()

  if (nrow(schools) > 0) {
    school_id <- schools$school_number[1]

    students <- get_students() %>%
      dplyr::filter(schoolid == !!school_id) %>%
      dplyr::head(5) %>%
      dplyr::collect()

    expect_collected_tibble(students)

    if (nrow(students) > 0) {
      expect_true(all(students$schoolid == school_id))
    }
  } else {
    skip("No schools found for testing")
  }
})
