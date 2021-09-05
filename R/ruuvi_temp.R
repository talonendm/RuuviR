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

  library(RuuviR)
  rd1 <- RuuviR::LoadRuuviExports(pathRuuvitag = 'C:\\Users\\talon_000\\Dropbox\\2021\\ruuvi\\m210829')
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
