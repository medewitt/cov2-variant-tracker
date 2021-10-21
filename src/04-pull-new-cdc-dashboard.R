# Purpose: Pull down new CDC Dashboard for Variant Tracking

url <- "https://public.tableau.com/views/State_Proportions_table/StateProportionsDash.csv?:embed=y&:showVizHome=no&:host_url=https%3A%2F%2Fpublic.tableau.com%2F&:embed_code_version=3&:tabs=yes&:toolbar=no&:animate_transition=yes&:display_static_image=no&:display_spinner=no&:display_overlay=yes&:display_count=no&publish=yes&:loadOrderID=0"


url <- "https://public.tableau.com/views/WeightedStateVariantTable/StateVBMTable.csv?:embed=y&:showVizHome=no&:host_url=https%3A%2F%2Fpublic.tableau.com%2F&:embed_code_version=3&:tabs=yes&:toolbar=no&:animate_transition=yes&:display_static_image=no&:display_spinner=no&:display_overlay=yes&:display_count=no&publish=yes&:loadOrderID=0"

current_time <- format(Sys.time(), "%Y%m%d%H%M")
try(download.file(url = url, destfile = here::here("data-raw","format-202110",
                                                   paste0(current_time,"_cdc_metrics.csv"))))

