globalVariables("conn_PROD2")

#' Connect to `IABWA` table on \code{PROD2} in `Assessments` schema
#'
#'
#' @return a `tbl_sql SQL Server` object.
#'
#' @export
#'
#' @examples
#'
#' # This attaches to the school db with \code{conn_PROD1} connection
#'
#' \dontrun{
#' schools <- get_schools()
#'}
#' # This pulls down schools data form the DB and onto your computer
#' # and then cleans the names (lower snakecase) using [janitor::clean_names()]
#'
#' \dontrun{
#' ias_bwas <- get_ia_bwa() %>%
#'   filter(AcademicYear == "2020-2021") %>%
#'   collect() %>%
#'   clean_names()
#'   }
get_iabwa <- function(){

  #check_get_connection("PROD2")

  out <- get_table(.table_name = "IABWA",
                   .database_name = "PROD2",
                   .schema = "Assessments",
                   .server_name = "RGVPDSD-DWPRD2")

out  # ia_bwa_col_names <- colnames(out)
  #
  # out <- out %>%
  #   # must reorder columns to move Blob to end (there's probably a better way to
  #   # suss out auto-magically which columns are blobs and more to the end)
  #   dplyr::select(ia_bwa_col_names[c(1,3:13,15:31, 2, 14)])

}
