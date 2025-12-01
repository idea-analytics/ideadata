utils::globalVariables("conn_lk_Schools")




#' Connect to `dbo.SchoolsExtensions` View or other tables  in `lk_Schools` on `RGVPDSD-DWPRD2` which provides
#' a tidy (i.e. a long ) view of schools information
#'
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_lk_Schools} connection
#' \dontrun{
#' schools_regions <- get_schools_regions()
#' }
#'
get_schools_regions <- function(){

  out <- get_table(.table_name = "SchoolsExtensions",
                   .schema = "dbo",
                   .database_name = "lk_Schools",
                   .server_name = "RGVPDSD-DWPRD2")

  out

}
