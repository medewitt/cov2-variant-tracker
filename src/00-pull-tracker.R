# purpose: scrape cdc variant listing


# advice from cdc ---------------------------------------------------------
# Numbers will be updated on Sunday, Tuesday, and Thursday by 7:00 pm.

calendar_use <- seq.Date(from = as.Date("2021-02-28"),
                         to = as.Date("2021-12-30"),
                         by = "day")
calendar_use = calendar_use[lubridate::wday(calendar_use, label = TRUE) %in% c("Sun", "Tue", "Thu")]

nearest_date = calendar_use[calendar_use>=Sys.Date()-1][1]

date_for_cdc = format(nearest_date, "%m%d%Y")
date_for_cdc_alt = format(nearest_date, "%m%d%y")
"https://www.cdc.gov/coronavirus/2019-ncov/downloads/transmission/03302021_Web-Update.csv"
url <- sprintf("https://www.cdc.gov/coronavirus/2019-ncov/transmission/docs/%s_Web-UpdateCSV-TABLE.csv", date_for_cdc)

date_possibilities<- expand.grid(date = c(date_for_cdc, date_for_cdc_alt),
                       extensions = c("xlsx", "xls", "csv"))

url_combinations <- c(
sprintf("https://www.cdc.gov/coronavirus/2019-ncov/transmission/docs/%s-Web-UpdateCSV-TABLE.%s",date_possibilities$date, date_possibilities$extensions ),
sprintf("https://www.cdc.gov/coronavirus/2019-ncov/downloads/transmission/%s_Web-Update.%s",date_possibilities$date, date_possibilities$extensions),
sprintf("https://www.cdc.gov/coronavirus/2019-ncov/downloads/transmission/%s_Web-UpdateCSV-TABLE.%s",date_possibilities$date, date_possibilities$extensions),
sprintf("https://www.cdc.gov/coronavirus/2019-ncov/downloads/transmission/%s-Web-UpdateCSV-TABLE.%s",date_possibilities$date, date_possibilities$extensions )
)

dat_in = NULL
i <- 1
while(is.null(dat_in)){
  tmp <- tempfile(fileext = ".csv")
  import = tryCatch(download.file(url_combinations[i],destfile = tmp),
           error = function(e) NULL)
  if(!is.null(import)){
    dat_in = data.table::fread(tmp)
  } else {
    dat_in = NULL
  }
  i = i+1
  if(i > length(url_combinations)){
    break()
  }
  }


if(!is.null(dat_in)){
  data.table::fwrite(dat_in, file.path("data-raw", basename(url)))
}


