#' Check if OS is *Nix flavored
#'
#' @return a single entry boolean (i.e., `TRUE` or `FALSE`)
#'
check_macos_linux <- function() {
  Sys.info()["sysname"] %in% c("Darwin", "Linux")
}




#' Checks/Gets Kereberos Ticket-Getting-Tickets are
#'
#' @param uid your IDEA user id (just the `firstname.lastname` part)
#' @param pwd your IDEA pass word
#'
#' @return None, this function is run for its side-effects
#'
kinit <- function(uid, pwd){
  # if not a Mac or Linux then stop
  if(!check_macos_linux()) {
    #message("Not Mac OS or Linux")
    return()
  }

  if(system("klist -s") == 0){

    message(crayon::blue(glue::glue("{uid}'s Kereberos TGT is current")))
    return()
  }

  if(Sys.info()["sysname"] == "Linux") {

    kinit_string <- glue::glue('echo \'{Sys.getenv("IDEA_RNA_DB_PWD")}\' | kinit {Sys.getenv("IDEA_RNA_DB_UID")}@IPS.ORG ')

    sys_response <- system(kinit_string)

    } else {

    tmp_file <- tempfile(fileext = ".txt")

    readr::write_lines(x = pwd, file=tmp_file)


    kinit_string <- glue::glue('kinit --password-file="{tmp_file}" {uid}@IPS.ORG')


    sys_response <- system(kinit_string)
  }


  tmp_file <- tempfile(fileext = ".txt")

  readr::write_lines(x = pwd, file=tmp_file)


  kinit_string <- glue::glue('kinit --password-file="{tmp_file}" {uid}@IPS.ORG')


  sys_response <- system(kinit_string)

  if(sys_response != 0) {
    message(crayon::red("There was a problem with {uid}'s creds\n"))
    message(crayon::red("Double check uid and pwd"))

    return()
  }

  message(crayon::green("kinit succeeded in getting TGT"))

  if(Sys.info()["sysname"] != "Linux") unlink(tmp_file)

}
