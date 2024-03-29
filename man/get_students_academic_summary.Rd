% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_PROD1.R
\name{get_students_academic_summary}
\alias{get_students_academic_summary}
\title{Connect to \code{StudentAcademicSummary} table on \code{PROD1} in \code{Schools} schema which has}
\usage{
get_students_academic_summary()
}
\value{
a \verb{tbl_sql SQL Server} object.
}
\description{
Connect to \code{StudentAcademicSummary} table on \code{PROD1} in \code{Schools} schema which has
}
\examples{

# This attaches to the school db with \code{conn_PROD1} connection

# This pulls down schools data form the DB and onto your computer
# and then cleans the names (lower snakecase) using [janitor::clean_names()]

\dontrun{
stus_academ_summary <- get_students_academic_summary()
}

}
