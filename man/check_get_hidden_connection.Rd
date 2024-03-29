% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connections.R
\name{check_get_hidden_connection}
\alias{check_get_hidden_connection}
\title{Check  "hidden" DB connections available and valid or create new one}
\usage{
check_get_hidden_connection(
  .database_name = "Documentation",
  r_and_a_server = TRUE
)
}
\arguments{
\item{.database_name}{name of the database you want to connect to}

\item{r_and_a_server}{switch for attaching to R&A server. Default is \code{FALSE}}
}
\value{
returns an S4 object that inherits from DBIConnection.
This object is used to communicate with the database engine.

Note that this function is called for it's side-effect: it will create
a connection object with the name \code{conn_\{.database_name\}} **that is in the
\code{ideadata} package environment
}
\description{
Check  "hidden" DB connections available and valid or create new one
}
