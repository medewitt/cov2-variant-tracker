# purpose: scrape cdc variant listing


# advice from cdc ---------------------------------------------------------
# Numbers will be updated on Sunday, Tuesday, and Thursday by 7:00 pm.

calendar_use <- seq.Date(from = as.Date("2021-02-28"),
                         to = as.Date("2021-12-30"),
                         by = "day")
calendar_use = calendar_use[lubridate::wday(calendar_use, label = TRUE) %in% c("Sun", "Tue", "Thu")]

nearest_date = calendar_use[calendar_use>=Sys.Date()][1]

date_for_cdc = format(nearest_date, "%m%d%Y")
date_for_cdc_alt = format(nearest_date, "%m%d%y")

url <- sprintf("https://www.cdc.gov/coronavirus/2019-ncov/transmission/docs/%s_Web-UpdateCSV-TABLE.csv", date_for_cdc)

dat_in = tryCatch(data.table::fread(url),
                  error = function(e) NULL)

if(!is.null(dat_in)){
  url <- sprintf("https://www.cdc.gov/coronavirus/2019-ncov/transmission/docs/%s-Web-UpdateCSV-TABLE.csv", date_for_cdc_alt)

  dat_in = tryCatch(data.table::fread(url),
                    error = function(e) NULL)
}

if(!is.null(dat_in)){
  url <- sprintf("https://www.cdc.gov/coronavirus/2019-ncov/transmission/docs/%s_Web-UpdateCSV-TABLE.csv", date_for_cdc_alt)

  dat_in = tryCatch(data.table::fread(url),
                    error = function(e) NULL)
}

if(!is.null(dat_in)){
  data.table::fwrite(dat_in, file.path("data-raw", basename(url)))
}


