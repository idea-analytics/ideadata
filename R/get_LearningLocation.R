globalVariables("conn_LearningLocation")

#' Connect to `LearningLocation` database `791150-hqvra` which provides
#' daily learning location (i.e, remote or in-person) for every student on ever day
#'
#' @details The learning location of a student  on a given is determined by calculating a
#' 30-day average  ("days" includes only days attended) in each location (remote vs in-person).
#' 75% of those 30 days at home leads to an `att_category` of remote, 75% of those
#' 30 days at home leads to an `att_category` of at-home, and all other cases are
#' coded mixed.
#'
#' @return a `tbl_sql SQL Server` object.
#' @
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_Dashboard} connection
#' \dontrun{
#' att_type <- get_learning_location()
#' }
get_learning_location <- function(){

  check_get_connection(.database_name = "LearningLocation",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("LearningLocation")

  out <- dplyr::tbl(conn_LearningLocation,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("AttTypesDaily"))
  )

  out

}

