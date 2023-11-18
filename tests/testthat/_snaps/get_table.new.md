# get_table returns NULL when multiple tables with the same name are found and provides useful info on the tables it found

    Code
      get_table(.table_name = "Students")
    Message <cliMessage>
      ! There are 43 tables with that name in our warehouse
      i You'll need to specify the database and schema name with db target.
      v Any of these should work:
    Output
        get_table(.table_name = "Students", .database_name = "Program21stCentury", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PROD1", .schema = "Schools", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PROD1", .schema = "AcceleratedLearning", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools_Focus", .schema = "Focus", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Louisiana_Schools", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Louisiana_Schools", .schema = "Powerschool", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Ohio_Schools", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Ohio_Schools", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Schools", .schema = "Powerschool", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Travis_Schools", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Travis_Schools", .schema = "Skyward", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools_Focus", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Louisiana_Schools", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Ohio_Schools", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Ohio_Schools", .schema = "Powerschool", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Schools", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools", .schema = "Powerschool", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools_Focus", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Schools", .schema = "Persistence", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Travis_Schools", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Edcite", .schema = "Edcite", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PowerSchool_Louisiana", .schema = "Data", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Naviance", .schema = "Data", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "CSIInstruction", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_BlendedLearning", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "CSIInstructionBackup", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "IDEAInstructionStage", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "CSIInstructionStage", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "IDEAInstructionDebug", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PROD1", .schema = "Attendance", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Florida_Schools_Focus", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Louisiana_Schools", .schema = "FWOS", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Schools", .schema = "AcceleratedLearning", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Schools", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "SRC_Texas_Travis_Schools", .schema = "EnrollmentDashboard", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "TravisSnapshotData", .schema = "MidLand.PM", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PowerSchool_Ohio", .schema = "Data", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "PowerSchool_Texas", .schema = "Data", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "CSIInstructionDebug", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
        get_table(.table_name = "Students", .database_name = "IDEAInstruction", .schema = "dbo", .server_name = "REDACTED-SQLSERVER")
      NULL

