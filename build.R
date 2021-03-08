
src_to_run = list.files("src", pattern = "*.R", full.names = TRUE)

lapply(src_to_run, function(x) try(source(x)))
