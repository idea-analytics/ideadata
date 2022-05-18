globalVariables("conn_SRC_AR")


# RenSTAR ------------------

#' Connect to `StarMathV2` or `StarReadingV2` tables in `SRC_AR` on `REDACTED-SQLSERVER`
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_SRC_AR} connection
#' \dontrun{
#' rs_math <- get_renstar_math()
#' }
get_renstar_math <- function(){


  out <- get_table(.table_name = "StarMathV2",
                   .database_name = "SRC_AR",
                   .schema = "dbo",
                   .server_name = "REDACTED-SQLSERVER")

  out

}



#' @describeIn get_renstar_math  Connect to `StarReadingV2` table in `SRC_AR` on `REDACTED-SQLSERVER`
#' @export
get_renstar_reading <- function(){

  out <-get_table(.table_name = "StarReadingV2",
                  .database_name = "SRC_AR",
                  .schema = "dbo",
                  .server_name = "REDACTED-SQLSERVER")

  out

}



