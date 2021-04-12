globalVariables("conn_PROD1")

#' Connect to `PersistnceHistorical` table on \code{PROD1} in `Persistence` schema
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the Prod1 db with \code{conn_PROD1} connection
#'
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#' \dontrun{
#' stus_cont_enrollment <- get_students_continuous_enrollment()
#' }
get_persistence_historical <- function(){

  check_get_connection("PROD1")

  out <- dplyr::tbl(conn_PROD1, dbplyr::in_schema(dplyr::sql("Persistence"),
                                                  dplyr::sql("PersistenceHistorical")))

  out

}
