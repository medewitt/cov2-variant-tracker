library(data.table)

docs <- fs::dir_ls(here::here("data-raw", "new-format"))

dat <- lapply(docs, fread)
names(dat) <- stringr::str_extract(basename(docs), "\\d+")

dat_raw <- rbindlist(dat, idcol = "UpdateDTS")


# first pass cleaning -----------------------------------------------------

dat_raw[,UpdateDTS := as.POSIXct(UpdateDTS,format = "%Y%m%d%H%M")]

dat_raw[,`Measure Values`:=stringr::str_remove(`Measure Values`, ",")]

dat_raw[,`Measure Values`:=as.numeric(`Measure Values`)]

# nc only -----------------------------------------------------------------

dat_nc <- dat_raw[State=="North Carolina"]

dat_nc_ratio <- dat_nc[!grepl("Total", `Measure Names`)][
  ,`Measure Names`:=ifelse(`Measure Names`=="B.1.427 / B.1.429",
                           "B.1.427/B.1.429", `Measure Names` )]
dat_ratio <- dat_raw[!grepl("Total", `Measure Names`)][
  ,`Measure Names`:=ifelse(`Measure Names`=="B.1.427 / B.1.429",
                           "B.1.427/B.1.429", `Measure Names` )]

dat_nc_sequence <- dat_nc[grepl("Total", `Measure Names`)][,NewSequenceCT:=c(0,diff(`Measure Values`))]

# dat_nc_ratio %>%
#   ggplot(aes(UpdateDTS,`Measure Values`, colour = `Measure Names`))+
#   geom_line()+
#   theme_bw()

data.table::fwrite(dat_ratio, here::here("data", "cdc-nc-data.csv"))
