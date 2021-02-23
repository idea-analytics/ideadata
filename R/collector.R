
#' Collect data from database to local environment piecemeal
#'
#' @details IDEA has 60,000+ students, which means data that is collected daily
#' or more frequently can get large really quickly as the day goes along.
#'
#' @param .data remote [dplyr::tbl()] table that needs to be collected
#' @param .split_column column used to break `.data` into peices to be downloaded
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
collector <- function(.data,
                      .split_column) {

  column_name <- rlang::as_label(rlang::enquo(.split_column))
  splitter <- .data %>%
    dplyr::select({{.split_column}}) %>%
    dplyr::distinct() %>%
    dplyr::arrange({{.split_column}}) %>%
    dplyr::pull({{.split_column}})

  data_collector_fn <- function(.split_value) {


    message(crayon::green(glue::glue("Pulling data for {column_name} == {.split_value} ...\n")))

    .data %>%
      dplyr::filter({{ .split_column }} == .split_value) %>%
      dplyr::collect()
  }

  message("Collecting data\n")
  out <-
    splitter %>%
    purrr::map_df(data_collector_fn)


  message("Data collection complete\n")
  out

}
