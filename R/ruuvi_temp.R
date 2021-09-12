# ...........................................
# Notes: use this file to test R code and finally convert it to functions ( before package creation)
# ...........................................
if (FALSE) {


  # use this!
  install.packages('xts')
  library(xts)

  rd1 <- ruuvi.data
  rd1$paivamaara


  names(rd1)


  # RuuviR 0.0.0003: create json

  library(RuuviR)






  # notes:
  # make reference work correctly in github: https://raw.githack.com/
  # https://rawcdn.githack.com/talonendm/RuuviR/37c731d6ffd54d439bc0e4fe9a4a4e6bb7f801a6/docs/index.html

  # dev: see changes directly:
  # https://raw.githack.com/talonendm/RuuviR/master/docs/index.html

  install.packages('rjson')
  library(rjson)

  grep("\\[",js1)
  grep("\\]",js1)

  install.packages('RJSONIO')
  library(RJSONIO)

  o2 <- RJSONIO::toJSON(rd2, collapse = "", .escapeEscapes = TRUE, pretty = TRUE)
  o3 <- RJSONIO::toJSON(rd2, pretty = FALSE) # add tabs or not

  js3 <- rjson::toJSON(rd2, indent = 1)

  js2 <- jsonlite::fromJSON(rjson::toJSON(rd2) ) # creates 5 lists.

  # RuuviR 0.0.0002


  library(RuuviR)
  rd1 <- RuuviR::LoadRuuviExports(pathRuuvitag = 'C:/Users/talon_000/Dropbox/2021/ruuvi/m210829')
  data.wide <- MakeDataWide(
         data = rd1,
         timewindow_min = 5,
         tag_name = FALSE
       )

  # Round data to nearest 5 minutes!
  # https://rdrr.io/cran/lubridate/man/round_date.html
  library(lubridate)
  library(dplyr)
  library(ggplot2)
  rd1$datetime <- round_date(rd1$paivamaara, unit="5 minutes")

  rd2 <- rd1 %>% dplyr::group_by(datetime, ruuvitag_name)



  rd2 <- rd2 %>% dplyr::summarise(lampotila = mean(lampotila_C),
                     ilmankosteus = mean(ilmankosteus_percent),
                     n = dplyr::n(), .groups = "drop" )



  rd2 <- rd1 %>% dplyr::group_by(datetime, id) %>%
    dplyr::summarise(lampotila = mean(lampotila_C),
                     ilmankosteus = mean(ilmankosteus_percent),
                     n = dplyr::n(), .groups = "drop" )


  names(rd1)
  names(rd2)

  # install.packages('vctrs')
  library(vctrs)

  library(tibble)
  library(tidyr)
  rd3 <- tidyr::spread(data.wide, id, ilmankosteus) # http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/#from-long-to-wide

  # rd2 <- rde2 %>% dplyr::mutate(c05vs06 =


  # install.packages('reshape2')
  library(reshape2)

  data_wide <- dcast(rd2, datetime ~ ruuvitag_name, value.var="ilmankosteus")
  data_wide

  library(ggplot2)
  ggplot2::ggplot(data.wide,
                  ggplot2::aes(x = datetime,
                      y = ilmankosteus,
                      color = tag_id)) + geom_point()


  (PlotRuuvi(data.wide))

}
