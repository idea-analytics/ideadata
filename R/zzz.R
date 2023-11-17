globalVariables("warehouse_meta_data")
grab_warehouse_meta_data <- function(){

  packageStartupMessage(cli::rule(left = "Gathering warehouse metadata",
                                  right = paste0("ideadata ", utils::packageVersion("ideadata"))))

  packageStartupMessage(paste(cli::symbol$info, "Checking credentials ..."))

  creds <- get_creds()

  kinit(creds$uid, creds$pwd)
  warehouse_meta_data <- get_warehouse_meta_data()
  #e1<-parent.env(environment())
  assign("warehouse_meta_data", warehouse_meta_data, pos = "package:ideadata")


  if(length(unique(warehouse_meta_data$table_name))==0) {
    packageStartupMessage(crayon::red(paste(cli::symbol$circle_cross, "There are 0 tables, which means there's a problem.  Check your VPN or Contact Chris!")))
  } else {
    packageStartupMessage(crayon::green(paste(cli::symbol$tick, "Success: Warehouse metadata gathered!")))
    packageStartupMessage(paste(cli::symbol$info, "The warehouse currently houses:"))
    packageStartupMessage(glue::glue("     {prettyNum(length(unique(warehouse_meta_data$table_name)), big.mark=',')} tables"))
    packageStartupMessage(glue::glue("  in {prettyNum(length(unique(warehouse_meta_data$database_name)), big.mark=',')} databases"))
    packageStartupMessage(glue::glue("  on {prettyNum(length(unique(warehouse_meta_data$server_name)), big.mark=',')} servers"))
    packageStartupMessage(crayon::yellow(praise::praise("${EXCLAMATION}! ideadata and you are ${adverb} ${adjective}!")))
    }

}

.onAttach <- function(...) {



  tryCatch(grab_warehouse_meta_data(),
           error = function(e){
             packageStartupMessage(e$message)
             return(NULL)
           })
}
