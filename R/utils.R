#' Interactively update .Renviron file
#'
#' Adds entries to your `.Renviron` file for uid, password, and driver.
#'
#' @details Running `setup_creds()` will check for  your .Revniron file, create it if
#' is missing, and add the environment files necessary for {ideadata} to function.
#' Not that if the `.Renviron` file is empty, the script will delete it and create a new `.Renviron`
#' file before populating with the uid, pwd, and driver variables.
#'
#' @return the path to the .Renviron file, invisibly.  This function is called for
#' its side-effects
#'
#' @export
#'
#' @examples
#'
#' setup_creds()
setup_creds <- function(){

  r_home <- fs::path_home_r()
  renviron_file_path <- glue::glue("{r_home}/.Renviron")

  manual_update <- FALSE
  resource_r_environ <- FALSE
  # Check existence and create if .Renviron doesn't exist
  if(!file.exists(renviron_file_path)) {
    cli::cli_alert_info(".Renviron file not found")
    cli::cli_alert("Creating {renviron_file_path}")
    file.create(renviron_file_path)

    cli::cli_alert_success("{renviron_file_path} created.")

    # Check renviron necessary variables.
    update_uid(renviron_file_path)
    update_pwd(renviron_file_path)
    update_driver(renviron_file_path)
  } else { # file exists

    r_environ <- readLines(renviron_file_path)
    if(length(r_environ) ==0) {
      cli::cli_alert_warning("{renviron_file_path} is empty ... deleting")
      file.remove(renviron_file_path)

      update_uid(renviron_file_path)
      update_pwd(renviron_file_path)
      update_driver(renviron_file_path)
      resource_r_environ <- TRUE
    } else {
      # update UID
      if(!any(stringr::str_detect(r_environ, "IDEA_RNA_DB_UID"))){
        update_uid(renviron_file_path)
        manual_update <- FALSE
        resource_r_environ <- TRUE
      } else {
          cli::cli_alert_warning("{.field IDEA_RNA_DB_UID} already exists")
          manual_update <- TRUE
      }

      # update PWD
      if(!any(stringr::str_detect(r_environ, "IDEA_RNA_DB_PWD"))){
        update_pwd(renviron_file_path)
        manual_update <- FALSE
        resource_r_environ <- TRUE
      } else{
        cli::cli_alert_warning("{.field IDEA_RNA_DB_PWD} already exists")
        manual_update <- TRUE

      }

      # update Driver
      if(!any(stringr::str_detect(r_environ, "IDEA_RNA_ODBC_DRIVER"))){
        update_driver(renviron_file_path)
        manual_update <- FALSE
        resource_r_environ <- TRUE
      } else{
        cli::cli_alert_warning("{.field IDEA_RNA_ODBC_DRIVER} already exists")
        manual_update <- TRUE

      }
    }



  }


  if(manual_update) {
    cli::cli_alert_info("Use {.pkg usethis::edit_r_environ()} to edit manually")
  } else {
    cli::cli_alert_success("Modified {renviron_file_path}")
  }

  if(resource_r_environ) {
    cli::cli_alert("Re-sourcing updated .Renviron file")
    readRenviron(renviron_file_path)
    cli::cli_alert_success("Environment variables updated")
  }


  invisible(renviron_file_path)


}

#' Update IDEA_RNA_DB_UID in .Renviron file
#'
#' @param .path path to .Renviron file
#'
#' @return Called for side-effect of updating .Renviron

update_uid <- function(.path){
    uid <- readline("Enter your user id (firstname.lastnanme): ")
    cat(glue::glue("IDEA_RNA_DB_UID='{uid}'"),
        file = .path,
        sep = "\n",
        append = TRUE)
    cli::cli_alert_success("Added {.field IDEA_RNA_DB_UID} entry")
}


#' @describeIn update_uid Update IDEA_RNA_DB_PWD in .Renviron file
#'
update_pwd <- function(.path){
  pwd <- readline("Enter your password: ")
  cat(glue::glue("IDEA_RNA_DB_PWD='{pwd}'"),
      file = .path,
      sep = "\n",
      append = TRUE)
  cli::cli_alert_success("Added {.field IDEA_RNA_DB_PWD} entry")
}

#' @describeIn update_uid Update IDEA_RNA_ODBC_DRIVER in .Renviron file

update_driver <- function(.path){
  driver <- readline("Enter your SQL Server Driver name\n(e.g. ODBC Driver 17 for SQL Server): ")
  driver <- paste0("{", driver, "}")
  cat(glue::glue("IDEA_RNA_ODBC_DRIVER='{driver}'"),
      file = .path,
      sep = "\n",
      append = TRUE)
  cli::cli_alert_success("Added {.field IDEA_RNA_ODBC_DRIVER} entry")
}


#' Calculate 4 digit PowerSchool TermID given first year of a school year
#'
#' @param sy First year in a school year (e.g. 2015 for SY 2015-2016)
#' @param quarter  quarter the quarter as integer in a year. The default is 0,
#'  which returns the school year's termid.
#'
#' @return a character or integer vector
#' @export
#'
#' @examples
#' calc_ps_termid(2015)
calc_ps_termid <- function(sy,
                           quarter = 0) {
  (sy - 1990)*100 + quarter
}

#' Calcuatalate the weeks elapsed from a reference date
#'
#' @param ref_date The end date (as character) for the duration used to
#' calculate elapsed weeks
#' @param quarter  he fixed date (as character) to start counting weeks from
#'
#' @return an integer giving the number of weeks elapsed b/w `first_day` and `ref_date`
#' @export
#'
#' @examples
#'
#' library(lubridate)
#' calc_elapsed_weeks(today())
calc_elapsed_weeks <- function(ref_date, first_day = '2020-07-01') {
  (lubridate::floor_date(lubridate::ymd(ref_date), unit="week") -
     lubridate::floor_date(lubridate::ymd(first_day), unit="week"))/lubridate::dweeks(1)+1
}
