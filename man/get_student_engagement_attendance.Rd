% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_PROD1.R
\name{get_student_engagement_attendance}
\alias{get_student_engagement_attendance}
\title{Connect to \code{StudentEngagementAttendance} table on \code{PROD1} in \code{Attendance} schema which has
the "learning environment" of students (i.,e remote vs in-person) for each day}
\usage{
get_student_engagement_attendance()
}
\value{
a \verb{tbl_sql SQL Server} object.
}
\description{
Connect to \code{StudentEngagementAttendance} table on \code{PROD1} in \code{Attendance} schema which has
the "learning environment" of students (i.,e remote vs in-person) for each day
}
\examples{

# This attaches to the Attendance db with \code{conn_PROD1} connection

# This pulls down engagement data form the DB and onto your computer
# and then cleans the names (lower snakecase) using [janitor::clean_names()]
\dontrun{
stus_engagement <- get_student_engagement_attendance()
}

}
