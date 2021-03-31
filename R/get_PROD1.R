globalVariables("conn_PROD1")

#' Connect to `Schools` table on \code{PROD1} in `Schools` schema
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#' schools <- get_schools()
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' \dontrun{
#' library(dplyr)
#' library(janitor)
#' schools <- get_schools() %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_schools <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
                                           dplyr::sql("Schools")))

  out

}


#' Connect to `Students` table on \code{PROD1} in `Schools` schema
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#' stus <- get_students()
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#'
#' \dontrun{
#' schools <- get_schools() %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_students <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
                                           dplyr::sql("Students")))

  out

}



#' Connect to `Regions` table on \code{PROD1} in `Schools` schema
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#' stus <- get_students()
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#'
#' \dontrun{
#' regions <- get_regions() %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_regions <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
                                           dplyr::sql("Regions")))

  out

}


#' Connect to `Students` table on \code{PROD1} in `Schools` schema only pull
#' currently enrolled students
#'
#' Specifically, pull students data where `EnrollmentStatus == 0`,
#' `RowIsCurrent = TRUE` and `SchoolTermID = max(SchoolTermID)`
#'
#' @importFrom dplyr `%>%`
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#' current <- get_currently_enrolled_students()
#'

get_currently_enrolled_students <- function(){

  check_get_connection("PROD1")

  stus <- get_students()

  out <- stus %>%
    dplyr::filter(
           .data$EnrollmentStatus == 0,
           .data$SchoolTermID == max(.data$SchoolTermID,na.rm = TRUE),
           .data$RowIsCurrent == 'TRUE')

  out

}

#' Connect to `Students` table on \code{PROD1} in `Attendance` schema which has
#' membership (i.e., enrollment) and attendance data
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' stu_attend <- get_student_daily_attendance()
#'
get_student_daily_attendance <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Attendance"),
                                           dplyr::sql("Students")))

  out

}


#' Connect to `StudentAcademicSummary` table on \code{PROD1} in `Schools` schema which has
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' stus_academ_summary <- get_students_academic_summary()
#'
get_students_academic_summary <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
                                                  dplyr::sql("StudentAcademicSummary")))

  out

}


#' Connect to `StudentEngagementAttendance` table on \code{PROD1} in `Attendance` schema which has
#' the "learning environment" of students (i.,e remote vs in-person) for each day
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the Attendance db with \code{conn_PROD1} connection
#'
#' # This pulls down engagement data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' stus_engagement <- get_student_engagement_attendance()
#'
get_student_engagement_attendance <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Attendance"),
                                                  dplyr::sql("StudentEngagementAttendance")))

  out

}


#' Connect to `StudentsContinuousEnrollment` table on \code{PROD1} in `Attendance` schema which has
#' the "learing environment" of students (i.,e remote vs in-person) for each day
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the Schools db with \code{conn_PROD1} connection
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' stus_cont_enrollment <- get_students_continuous_enrollment()
#'
get_students_continuous_enrollment <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
                                                  dplyr::sql("StudentsContinuousEnrollment")))

  out

}
