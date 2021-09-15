
#' Collect data from database to local environment piecemeal
#'
#' @details IDEA has 60,000+ students, which means data that is collected daily
#' or more frequently can get large really quickly as the day goes along.
#'
#' @param .data remote [dplyr::tbl()] table that needs to be collected
#' @param .. columns used to break `.data` into pieces to be downloaded
#'
#' @return a tibble
#' @export
#'
#' @examples
#' library(dplyr)
#'
#' regions_remote <- get_regions()
#' regions <- regions_remote %>% collector(State)
#'
collector <- function(.df,
                      #.split_column
                      ...,
                      verbose = TRUE
                      ) {

  #capture dots
  column_names <- rlang::enquos(...)

  #create an in-database query that has all distinct combinations for column vars
  splitter <- .df %>%
    dplyr::ungroup() %>%
    dplyr::distinct(!!!column_names) %>%
    dbplyr::window_order(!!!column_names) %>%
    #create ID column form row number
    dplyr::mutate(row_number = dplyr::row_number())

  #short function that collects the rows mathching splitters rows
  data_collector_fn <- function(.split_value) {


    #use the current row value
    splitter_filter <- splitter %>%
      dplyr::filter(row_number == .split_value) %>%
      dplyr::select(-row_number)

    #creeate a named list of column names and column values
    splitter_filter_list <- splitter_filter %>%
      dplyr::collect() %>%
      as.list()

    #transform list to string of the form `column_name == column value`
    splitter_filter_string <- glue::glue("{names(splitter_filter_list)} == {glue::single_quote(splitter_filter_list)}")

    #replace `column name == NA` with `is.na(column name)` and collapes list to single
    #string with rows seperated by commas
    splitter_filter_string <- stringr::str_replace(splitter_filter_string, "(.+)\\s==\\sNA", "is.na(\\1)") %>%
      glue::glue_collapse(sep = ", ")


    if(verbose) {
      splitter_filter_message <- stringr::str_replace(splitter_filter_string, "(.+)\\s==\\sNA", "is.na(\\1)") %>%
      glue::glue_collapse(sep = ", ", last = ", and ")
      }
    # create call as string to filter
    filter_string <- glue::glue("dplyr::filter(.df, {splitter_filter_string})")

    # create evaluated call
    filter_eval <- glue::identity_transformer(filter_string, envir = environment())

    #evaluate call and collect and return
    if(verbose) message(crayon::green(glue::glue("Pulling data filtered to: {splitter_filter_message} ...\n")))
    filter_eval %>%
      dplyr::collect()

  }

  splitter_rows_numbers <- suppressWarnings(splitter %>% dplyr::pull(row_number))
  if(verbose) message("Collecting data\n")
  out <-
    splitter_rows_numbers %>%
    purrr::map_df(data_collector_fn)


  if(verbose) message("Data collection complete\n")
  out

}
