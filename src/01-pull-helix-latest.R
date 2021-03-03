library(data.table)
url_helix <- 'https://raw.githubusercontent.com/myhelix/helix-covid19db/master/counts_by_state.csv'

data.table::fwrite(data.table::fread(url_helix), file.path("data", "helix-latest.csv"))
