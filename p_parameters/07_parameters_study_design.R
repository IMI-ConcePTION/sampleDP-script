#-----------------------------------
# general parameters of the program
#-----------------------------------

#study_years_datasource

firstjan2021 <- ymd(20210101)

study_start <- as.Date(as.character(20200101), date_format)
start_lookback <- as.Date(as.character(20190101), date_format)

study_end <- min(as.Date(as.character(CDM_SOURCE[1,"date_creation"]), date_format),
                 as.Date(as.character(CDM_SOURCE[1,"recommended_end_date"]), date_format), na.rm = T)

study_years <- c("2020","2021")


firstYearComponentAnalysis = "2019"
secondYearComponentAnalysis = "2020"

days <- ifelse(thisdatasource %in% c("ARS","TEST"),180,1)