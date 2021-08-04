# Purpose: Aggregate Data
library(data.table)
library(ggplot2)

# target files ------------------------------------------------------------
csv_to_combine = list.files(path = "data-raw", full.names = TRUE, pattern = "*.csv")

# read and aggregate ------------------------------------------------------

dat_raw = lapply(csv_to_combine, data.table::fread)

update_dates = as.Date(gsub("(\\d+).+","\\1",basename(csv_to_combine)), format = "%m%d%y")


process_date <- function(update_dates, csv_to_combine){
  error_in = which(as.integer(format(update_dates, "%Y"))<2021L,update_dates)

  update_dates[error_in] = as.Date(gsub("(\\d+).+","\\1",basename(csv_to_combine[error_in])), format = "%m%d%Y")
  update_dates
  }

update_dates = process_date(update_dates, csv_to_combine)

dat_raw = lapply(dat_raw, function(x) {
  y = which(x = grepl("State|Variant", names(x)))
  x[,..y]
  })

names(dat_raw) = update_dates

dat_raw = rbindlist(dat_raw, idcol = "update_date")

dat_raw[,update_date:=as.Date(update_date)]

nc_only = dat_raw[State=="NC"]

nc_long = melt(nc_only, id.vars = c("State", "update_date"))

p <- ggplot(data = nc_long, aes(update_date, value, colour = variable))+
  geom_line(size = 1.2)+
  theme_bw()+
  scale_colour_manual(values = c("#00468BFF", "#ED0000FF", "#42B540FF"))+
  labs(
    title = "Reported SARS-CoV-2 Variants",
    subtitle = "For North Carolina",
    caption = "Data from Centers for Disease Control",
    colour = "Variants",
    y = "Count of Identified Samples"
  )

ggsave(p, filename = "output/nc-variants-cdc.pdf")


# write outputs -----------------------------------------------------------

fwrite(nc_long, "data/cdc-latest.csv")
