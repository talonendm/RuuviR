# ...........................................................
# ruuvifunctions.R
# ...........................................................

# ...........................................................
#' read ruuvi data from local machine
#'
#' csv data to R
#'
#' @param pathRuuvitag local path to csv files
#' @importFrom magrittr %>%
#' @importFrom data.table fread rbindlist
#' @importFrom janitor clean_names
#' @export
#' @examples
#'  \dontrun{
#'   ruuvi.data <- LoadRuuviExports(
#'    pathRuuvitag = 'C:/Users/talon_000/Dropbox/2021/ruuvi/m210829'
#'   )
#'  }
#' @return
#' This function returns N ruuvi exports (in the selected folder) as one data frame object.
# ...........................................................
LoadRuuviExports <- function(pathRuuvitag = "") {
  # https://stackoverflow.com/questions/11433432/how-to-import-multiple-csv-files-at-once

  List_of_file_paths <- base::list.files(path = pathRuuvitag,
                                         pattern = ".csv",
                                         all.files = TRUE,
                                         full.names = TRUE)

  List_of_file_paths_filename <- list.files(path = pathRuuvitag,
                                            pattern = ".csv",
                                            all.files = TRUE,
                                            full.names = FALSE)

  List_of_file_paths_filename <- gsub('.csv','', List_of_file_paths_filename)
  da <- list()
  i <- 0
  for (csv_i in List_of_file_paths) {
    i <- i + 1
    da[[i]] <- data.table::fread(csv_i)
    da[[i]]$id <- i
    da[[i]]$ruuvitagName <- List_of_file_paths_filename[i]
  }

  da1 <- data.table::rbindlist(da)

  # install.packages('janitor')
  # library(janitor)
  # https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html

  da1 <- da1 %>% janitor::clean_names()

  names(da1) <- gsub('a_', "a", names(da1))
  names(da1) <- gsub('_a', "a", names(da1))
  if (names(da1)[2] == "lampatilaac") names(da1)[2] <- "lampotila_C"
  # names(da1)
  # head(da1)

  return(da1)

}
# ...........................................................


# ...........................................................
#' MakeDataWide
#'
#' data wrangling
#'
#' @param pathRuuvitag local path to csv files
#' @export
#' @importFrom dplyr group_by summarise n
#' @importFrom lubridate round_date
#' @examples
#'  \dontrun{
#'    data.wide <- MakeDataWide(
#'     data = ruuvi.data,
#'     timewindow_min = 5,
#'     tag_name = FALSE
#'    )
#'  }
# ...........................................................
MakeDataWide <- function(data, timewindow_min = 5, tag_name = FALSE) {

  timewindow <- paste(as.character(timewindow_min), "minutes")

  data$datetime <- lubridate::round_date(data$paivamaara, unit = timewindow)



  if (tag_name) {
    # rd2 <- rd1 %>% dplyr::group_by(datetime, ruuvitag_name)
    data$tag_id <- data$ruuvitag_name
  } else {
    # rd2 <- rd1 %>% dplyr::group_by(datetime, id)
    data$tag_id <- as.factor(as.character(data$id))
  }
  rd2 <- data %>% dplyr::group_by(datetime, tag_id)

  rd2 <- rd2 %>% dplyr::summarise(lampotila = mean(lampotila_C),
                                  ilmankosteus = mean(ilmankosteus_percent),
                                  n = dplyr::n(), .groups = "drop" )

  return(rd2)

}
# ...........................................................





# ...........................................................
#' PlotRuuvi
#'
#' plot ruuvi data
#'
#' @param pathRuuvitag local path to csv files
#' @export
#' @importFrom ggplot2 ggplot geom_point aes
#' @examples
#'  \dontrun{
#'
#'    data.wide <- MakeDataWide(
#'     data = ruuvi.data,
#'     timewindow_min = 5,
#'     tag_name = FALSE
#'    )
#'
#'    PlotRuuvi(data = data.wide)
#'  }
# ...........................................................
PlotRuuvi <- function(data) {

  gg1 <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = datetime,
                 y = ilmankosteus,
                 color = tag_id)) + ggplot2::geom_point()


  print(gg1)
  return(gg1)
}
# ...........................................................
