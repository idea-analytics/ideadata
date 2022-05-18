globalVariables("conn_LearningLocation")

#' Connect to `LearningLocation` database `RGVPDRA-DASQL` which provides
#' daily learning location (i.e, remote or in-person) for every student on ever day
#'
#' @details The learning location of a student  on a given is determined by calculating a
#' 30-day average  ("days" includes only days attended) in each location (remote vs in-person).
#' 75% of those 30 days at home leads to an `att_category` of remote, 75% of those
#' 30 days at home leads to an `att_category` of at-home, and all other cases are
#' coded mixed.
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_LearningLocation} connection
#' \dontrun{
#' att_type <- get_learning_location()
#' }
get_learning_location <- function(){

  out <-  get_table(.table_name = "AttTypesDaily",
                    .database_name = "LearningLocation",
                    .schema = "dbo",
                    .server_name = "RGVPDRA-DASQL")

  out

}

