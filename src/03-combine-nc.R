# Purpose: Aggregate Data
library(data.table)
library(ggplot2)

# target files ------------------------------------------------------------
csv_to_combine = list.files(path = "data-raw", full.names = TRUE, pattern = "*.csv")

# read and aggregate ------------------------------------------------------

dat_raw = lapply(csv_to_combine, data.table::fread)

update_dates = as.Date(gsub("(\\d+).+","\\1",basename(csv_to_combine)), format = "%m%d%y")

names(dat_raw) = update_dates

dat_raw = rbindlist(dat_raw, idcol = "update_date")

dat_raw[,update_date:=as.Date(update_date)]

nc_only = dat_raw[State=="NC"]

nc_long = melt(nc_only, id.vars = c("State", "update_date"))

ggplot(data = nc_long, aes(update_date, value, colour = variable))+
  geom_line(size = 1.2)+
  theme_bw()+
  scale_colour_manual(values = c("#00468BFF", "#ED0000FF", "#42B540FF"))+
  labs(
    title = "Reported SARS-CoV-2 Variants",
    subtitle = "For North Carolina",
    caption = "Data from Centers for Disease Control",
    colour = "Variants",
    y = "Count of Identified Samples"
  )+ggsave(filename = "output/nc-variants-cdc.pdf")
