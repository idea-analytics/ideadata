# ideadata (development version)

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
