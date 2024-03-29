# ideadata 4.0.0

* updated workhorse functions to avoid dependency problem with `dbplyr 2.4.0`. 
* added `get_aees` family of functions to get Annual Employee Experience Survey tables
* fixed `warehouse_meta_data` documentation

# ideadata 3.0.2

* fixed loading problems by error catching when not on the network. The package should load without creds as well. 

# ideadata 3.0.1

# ideadata 3.0.0

* Big update to get ready for new servers in the warehouse. 
* Connection pattern of looking up metadata completely re-engineered
* Better start-up message with more detail about the warehouse
* All get_* functions wrap get_table


# ideadata 2.0.3

# ideadata 2.0.2

# ideadata 2.0.1

* Added a call to `data(warhouse_meta_data, envir=environemnt())` to ensure a Linux compatibility with looking up warehouse metadata.

# ideadata 2.0.0

* This is the newest version for release to the R&A Team.  Biggest change is that `get_table` doesn't connect to the warehouse `MetaData`. It uses a build in dataframe that is refreshed when the package is loaded. 
* `collector` now takes multiple columns to split up a data set to pass to `purrr`. 
* Minor documentation in `collector`'s vignette on using `dplyr::compute` to reduce SQL Server time on unevaluated `dplyr` pipelines. 
* added `view_warehouse_meta_data()`, which opens the RStudio IDE's viewer for exploring what's in the data warehouse.

# ideadata 1.1.1

* Some improvements to `collector`
* Fixed documentation warnings. 
* New documentation for `collector` and minor updates to `get_tables` vignette. 


# ideadata 1.1.0

* When attaching `ideadata` with `library(ideadata`) the package creates a data warehouse meta data table that users can use to look for data locations _and_ which `ideadata` uses for looking up table locations.  This process ensures that at library attach the user and the package has the most up-to-date data about the warehouse. 

# ideadata 1.0.2

* create a switch in the kinit function to differentiate between macOS and Linux since out of the box 
Kereberos authentication is slightly different on both. 

# ideadata 1.0.1

* rolled back the connection function to not perform one check on live connection  (it always saw live connections
as dead and would reconnect, making joins impossible.)

# ideadata 1.0.0

This is a major release where this package is substantially feature complete. 

## Major Updates

* added the `get_table()` function which is a workhorse that can pull arbitrary tables in the warehouse with
simply the table name.  In the case of more than 1 table with the same name, the function fails informatively and provides example code to get the table the user really needs. 

## Minor updates

* added vignettes for `collector()`, `get_tables()`

* Changed connections strings from using IP addresses to FQDNs in the `server` argument. 

# ideadata 0.1.8

* added `calc_elapsed_weeks()` function

# ideadata 0.1.7

* added functions to get Persistence data from a linked server. 

# ideadata 0.1.6

* added functions to get GPTW data

# ideadata 0.1.5

* added functions to get engagement data (i.e., in-person vs remote) and continuous enrollment data. 

# ideadata 0.1.4

* Added GPTW `get_*` functions 

# ideadata 0.1.3

* Connection pane disconnections weren't working, but now they are. 
* added `disconnect()` function to close conenctions in scripts and from the console. 


* Created `pkgdown` site for hosting documentation on github. 

# ideadata 0.1.2

* Added linked server functionality.  
  * Renaissance STAR (math and reading with separate functions) on SRC_AR via linked server. 
* Added Connection Pane viewer functionality. Now when you open a connection you'll be able to explore that database to which you are connected. (Note that this doesn't worked for linked databases; in that case you'll see the R&A SQL Server)

# ideadata 0.1.1.9000

* Added a `NEWS.md` file to track changes to the package.
* Initial connections available to the following dbs and tables:
  * IAWBWA table on PROD2
  * Students table on PROD1 in Schools schema
  * Schools table on PROD1 in Schools schema
  * Regions table on PROD1 in Schools schema
  * StudentAcademicSummary table on PROD1
  *Students table on PROD1 in Attendance schema
  * Pull currently enrolled students from Students table on PROD1
