globalVariables("conn_SRC_AR")




get_renstar <- function(){


}

rs_math <- tbl(conn, dbplyr::in_schema("[964592-SQLDS].[SRC_AR].[dbo]", "StarMathV2")) %>%
  select(StudentNumber = StudentIdentifier,
         ScaledScore:TotalCorrect,
         LaunchDate,CompletedDate, TotalTimeInSeconds,
         StudentGrowthPercentileFallFall,
         StudentGrowthPercentileSpringFall,
         AcademicYear,
         ScreeningPeriodWindowName) %>%
  filter(AcademicYear == "2020-2021",
         ScreeningPeriodWindowName == 'BOY Administration')  %>%
  mutate(subject = "Mathematics") %>%
  collect()
