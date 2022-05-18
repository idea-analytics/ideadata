globalVariables("conn_Persistence")


# Persistence --------------------


#' Connect to `PersistenceHistorical` table in `Persistence` database on `RGVPDSD-DWPRD1`
#'

#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the `Persistence` db with \code{conn_Persistence} connection
#' \dontrun{
#' ps_hist <- get_persistence_historical()
#' }
get_persistence_historical <- function(){

  out <- get_table(.table_name = "PersistenceHistorical",
                   .database_name = "Persistence",
                   .schema = "dbo",
                   .server_name = "RGVPDSD-DWPRD1")


  out

}

#' Connect to `PersistenceCode` table in `Persistence` database on `RGVPDSD-DWPRD1`
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the `Persistence` db with \code{conn_Persistence} connection
#' \dontrun{
#' ps_code <- get_persistence_code()
#' }
get_persistence_code <- function(){

  check_get_connection(.database_name = "Dashboard",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("Persistence")

  out <- get_table(.table_name = "PersistenceCode",
                   .database_name = "Persistence",
                   .schema = "dbo",
                   .server_name = "RGVPDSD-DWPRD1")

  out

}


#' Connect to `PersitenceCodeHistorical` (*sic*) table in `Persistence` database on `RGVPDSD-DWPRD1`
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the `Persistence` db with \code{conn_Persistence} connection
#' \dontrun{
#' ps_code <- get_persistence_code()
#' }
get_persistence_code_historical <- function(){

  out <- get_table(.table_name = "PersitenceCodeHistorical",
                   .database_name = "Persistence",
                   .schema = "dbo",
                   .server_name = "RGVPDSD-DWPRD1")


  out

}


#' Connect to `PersistenceReasonsCodes`  table in `Persistence` database on `RGVPDSD-DWPRDS`
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the `Persistence` db with \code{conn_Persistence} connection
#' \dontrun{
#' ps_reason_codes <- PersistenceReasonsCodes()
#' }
get_persistence_reasons_codes <- function(){


  out <- get_table(.table_name = "PersistenceReasonsCodes",
                   .database_name = "Persistence",
                   .schema = "dbo",
                   .server_name = "RGVPDSD-DWPRD1")


  out

}
