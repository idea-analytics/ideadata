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
#'
#' \dontrun{
#' schools <- get_schools()
#'
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#'
#' library(dplyr)
#' library(janitor)
#' schools <- get_schools() %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_schools <- function(){

  #check_get_connection("PROD1")

  out <- get_table(.table_name = "Schools",
                   .database_name = "PROD1",
                   .schema = "Schools",
                   .server_name = "RGVPDSD-DWPRD1")

    #dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
     #                                      dplyr::sql("Schools")))

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
#' \dontrun{
#' stus <- get_students()
#' }
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

  #check_get_connection("PROD1")

  out <- get_table(.table_name = "Students",
                   .database_name = "PROD1",
                   .schema = "Schools",
                   .server_name = "RGVPDSD-DWPRD1")

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
#' \dontrun{
#' stus <- get_students()
#' }
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#'
#' \dontrun{
#' regions <- get_regions() %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_regions <- function(){

  #check_get_connection("PROD1")

  out <- get_table(.table_name = "Regions",
                   .database_name = "PROD1",
                   .schema = "Schools",
                   .server_name = "RGVPDSD-DWPRD1")

    #dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Schools"),
     #                                      dplyr::sql("Regions")))

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
#' \dontrun{
#' current <- get_currently_enrolled_students()
#' }
#'

get_currently_enrolled_students <- function(){

  #check_get_connection("PROD1")

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
#' \dontrun{
#' stu_attend <- get_student_daily_attendance()
#' }
#'
get_student_daily_attendance <- function(){

  #check_get_connection("PROD1")

  out <- get_table(.table_name = "Students",
                   .database_name = "PROD1",
                   .schema = "Attendance",
                   .server_name = "RGVPDSD-DWPRD1")

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
#'
#' \dontrun{
#' stus_academ_summary <- get_students_academic_summary()
#' }
#'
get_students_academic_summary <- function(){

  check_get_connection("PROD1")

  out <- get_table(.table_name = "StudentAcademicSummary",
                   .database_name = "PROD1",
                   .schema = "Schools",
                   .server_name = "RGVPDSD-DWPRD1")
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
#' \dontrun{
#' stus_engagement <- get_student_engagement_attendance()
#' }
#'
get_student_engagement_attendance <- function(){

  check_get_connection("PROD1")

  out <- get_table(.table_name = "StudentEngagementAttendance",
                   .database_name = "PROD1",
                   .schema = "Attendance",
                   .server_name = "RGVPDSD-DWPRD1")
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
#' \dontrun{
#' stus_cont_enrollment <- get_students_continuous_enrollment()
#' }
get_students_continuous_enrollment <- function(){

  check_get_connection("PROD1")

  out <- get_table(.table_name = "StudentsContinuousEnrollment",
                   .database_name = "PROD1",
                   .schema = "Schools",
                   .server_name = "RGVPDSD-DWPRD1")
  out

}
