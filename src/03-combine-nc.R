# Purpose: Aggregate Data
library(data.table)


# target files ------------------------------------------------------------
csv_to_combine = list.files(path = "data-raw", full.names = TRUE, pattern = "*.csv")

# read and aggregate ------------------------------------------------------

dat_raw = lapply(csv_to_combine, data.table::fread)

update_dates = as.Date(gsub("(\\d+).+","\\1",basename(csv_to_combine)), format = "%m%d%y")

names(dat_raw) = update_dates

dat_raw = rbindlist(dat_raw, idcol = "update_date")

dat_raw[,update_date:=as.Date(update_date)]

nc_only = dat_raw[State=="NC"]
