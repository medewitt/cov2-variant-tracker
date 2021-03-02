
src_to_run = list.files("src", pattern = "*.R")

lapply(src_to_run, function(x) try(source(x)))
