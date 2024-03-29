% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_PROD1.R
\name{get_students_continuous_enrollment}
\alias{get_students_continuous_enrollment}
\title{Connect to \code{StudentsContinuousEnrollment} table on \code{PROD1} in \code{Attendance} schema which has
the "learing environment" of students (i.,e remote vs in-person) for each day}
\usage{
get_students_continuous_enrollment()
}
\value{
a \verb{tbl_sql SQL Server} object.
}
\description{
Connect to \code{StudentsContinuousEnrollment} table on \code{PROD1} in \code{Attendance} schema which has
the "learing environment" of students (i.,e remote vs in-person) for each day
}
\examples{

# This attaches to the Schools db with \code{conn_PROD1} connection

# This pulls down schools data form the DB and onto your computer
# and then cleans the names (lower snakecase) using [janitor::clean_names()]
\dontrun{
stus_cont_enrollment <- get_students_continuous_enrollment()
}
}
