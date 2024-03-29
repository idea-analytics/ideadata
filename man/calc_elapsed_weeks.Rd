% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{calc_elapsed_weeks}
\alias{calc_elapsed_weeks}
\title{Calculate the weeks elapsed from a reference date}
\usage{
calc_elapsed_weeks(ref_date, first_day = "2020-07-01")
}
\arguments{
\item{ref_date}{The end date (as character) for the duration used to
calculate elapsed weeks}

\item{first_day}{the fixed date (as character) to start counting weeks from}
}
\value{
an integer giving the number of weeks elapsed b/w \code{first_day} and \code{ref_date}
}
\description{
Calculate the weeks elapsed from a reference date
}
\examples{

\dontrun{
library(lubridate)
calc_elapsed_weeks(today())
}
}
