.onAttach <- function(...) {

  packageStartupMessage("Gathering warehouse metadata")
  warehouse_meta_data <- get_warehouse_meta_data()
  e1<-parent.env(environment())
  assign("warehouse_meta_data", warehouse_meta_data, pos = "package:ideadata")
  packageStartupMessage("Success: Warehouse metadata gathered!")
  packageStartupMessage(glue::glue("{length(unique(warehouse_meta_data$table_name))} tables"))
  packageStartupMessage(glue::glue("{length(unique(warehouse_meta_data$database_name))} databases"))
  packageStartupMessage(glue::glue("{length(unique(warehouse_meta_data$server_name))} servers"))


}
