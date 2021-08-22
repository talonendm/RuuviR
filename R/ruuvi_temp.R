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

  # Round data to nearest 5 minutes!
  # https://rdrr.io/cran/lubridate/man/round_date.html
  library(lubridate)
  rd1$datetime <- round_date(rd1$paivamaara,unit="5 minutes")

  rd2 <- rd1 %>% dplyr::group_by(datetime, ruuvitag_name) %>%
    dplyr::summarise(lampotila = mean(lampotila_C),
                     ilmankosteus = mean(ilmankosteus_percent),
                     n = dplyr::n() )


  names(rd2)

  install.packages('vctrs')
  library(vctrs)

  library(tibble)
  library(tidyr)
  rd3 <- tidyr::spread(rd2, ruuvitag_name, ilmankosteus) # http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/#from-long-to-wide

  # rd2 <- rde2 %>% dplyr::mutate(c05vs06 =


  install.packages('reshape2')
  library(reshape2)

  data_wide <- dcast(rd2, datetime ~ ruuvitag_name, value.var="ilmankosteus")
  data_wide


  ggplot2::ggplot(rd2,
                  aes(x = datetime,
                      y = ilmankosteus,
                      color = ruuvitag_name)) + geom_point()


}
