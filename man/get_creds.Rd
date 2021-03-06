% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connections.R
\name{get_creds}
\alias{get_creds}
\title{Get's creds from environment variable}
\usage{
get_creds()
}
\value{
a named list with uid (userid), pwd (password), and driver
}
\description{
Looks up user credentials (and local ODBC driver to SQL Server)
from environmental variables imported from the user's \code{.Renviron} file.
Use \link{setup_creds} if this function fails; doing so will get the right entries
into your \code{.Renviron} file.
}
