# install.packages("xml2")
# install.packages("usethis")

library(xml2)
library(usethis)

.url <- "http://www.beerxml.com/"

.examples <- c("recipes", "hops", "grain", "misc", "style", "water", "yeast", "equipment", "mash")

lapply(.examples, function(x) {
  xml2::download_xml(
    url = paste0(.url,x,".xml"), file = paste0("inst/extdata/",x,".xml"))
})

.files <- list.files("inst/extdata", full.names = TRUE)

r_obj <- lapply(.files, xml2::read_xml)

names(r_obj) <- .examples

list2env(r_obj, envir = .GlobalEnv)
rm(r_obj)

for(obj in ls()) {
  eval(bquote(use_data(.(as.name(obj)), overwrite = TRUE)))
  }
