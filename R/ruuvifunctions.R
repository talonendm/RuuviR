# ...........................................................
# ruuvifunctions.R
# ...........................................................

# ...........................................................
#' read ruuvi data from local machine
#'
#' csv data to R
#'
#' @param pathRuuvitag local path to csv files
#' @param clean.field.names clean.field.names
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
LoadRuuviExports <- function(pathRuuvitag = "", clean.field.names = TRUE) {
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





  if (clean.field.names) {


    da1 <- da1 %>% janitor::clean_names()

    names(da1) <- gsub('a_', "a", names(da1))
    names(da1) <- gsub('_a', "a", names(da1))
    if (names(da1)[2] == "lampatilaac") names(da1)[2] <- "lampotila_C"
    # names(da1)
    # head(da1)
  } else {

    names(da1) <- gsub("\u00f6", "ö", names(da1)) # https://stackoverflow.com/questions/7061339/how-to-convert-u00e9-into-a-utf8-char-in-mysql-or-php
    names(da1) <- gsub("\u00e4", "ä", names(da1))

    names(da1) <- gsub("Ã¶", "ö", names(da1))
    names(da1) <- gsub("Ã¤", "ä", names(da1))
    names(da1) <- gsub("Â°", "", names(da1)) # Celsius
  }
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
#' @importFrom rlang .data
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
  rd2 <- data %>% dplyr::group_by(.data$datetime, .data$tag_id)

  rd2 <- rd2 %>% dplyr::summarise(lampotila = mean(.data$lampotila_C),
                                  ilmankosteus = mean(.data$ilmankosteus_percent),
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
#' @importFrom rlang .data
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
    ggplot2::aes(x = .data$datetime,
                 y = .data$ilmankosteus,
                 color = .data$tag_id)) + ggplot2::geom_point()


  print(gg1)
  return(gg1)
}
# ...........................................................




# ...........................................................
#' read ruuvi data from local machine
#'
#' SaveRuuviAsJson data as json
#'
#' @param data data
#' @param pathRuuviExport path to json file
#' @param filenamejson clean.field.names
#' @importFrom stringi stri_write_lines
#' @importFrom jsonlite toJSON
#' @export
#' @examples
#'  \dontrun{
#'
#'   p <- SetupRuuviR(p = NULL, username = "talonendm", printparameters = TRUE)
#'
#'   rd1 <- LoadRuuviExports(
#'      pathRuuvitag = 'C:/Users/talon_000/Dropbox/2021/ruuvi/m210829',
#'      clean.field.names = FALSE
#'   )
#'
#'   rd2 <- RuuviR::MakeDataWide(data = rd1)
#'
#'   SaveRuuviAsJson(data = rd2,
#'    pathRuuviExport = p$path.json.export,
#'    filenamejson = p$ruuvi.datetag
#'   )
#'
#'   # https://dl.dropboxusercontent.com/s/ywk9qitmuq5digf/m210829.json?dl=0
#'
#'  }
#' @return
#' This function returns N ruuvi exports (in the selected folder) as one data frame object.
# ...........................................................
SaveRuuviAsJson <- function(data, pathRuuviExport = NULL, filenamejson = NULL) {
  js1 <- jsonlite::toJSON(data)

  if (is.null(pathRuuviExport) | is.null(filenamejson)) {
    stringi::stri_write_lines(str = js1,
                              fname = paste0(p$path.json.export,
                                             p$ruuvi.datetag, ".json"
                                             ),
                              encoding = 'utf-8'
                              )
  } else {
    stringi::stri_write_lines(str = js1,
                              fname = paste0(pathRuuviExport,
                                             filenamejson, ".json"
                              ),
                              encoding = 'utf-8'
    )
  }
  print("json saved")
}
# ...........................................................


# ...........................................................
#' setup
#'
#' SetupRuuviR parameter object p
#'
#' @param p is NULL
#' @param username username
#' @param printparameters printparameters
#' @export
#' @examples
#'  \dontrun{
#'   p <- SetupRuuviR(p = NULL, username = "talonendm", printparameters = TRUE)
#'  }
#' @return
#' This function creates parameter object p for development.
# ...........................................................
SetupRuuviR <- function(pathRuuviExport = "", username = "talonendm", printparameters = FALSE) {
  p <- list()
  p$datetag <- gsub(":","", Sys.Date())

  if (username == "talonendm") {
    p$getwd <- getwd()
    p$path.json.export <- 'C:/Users/talon_000/Dropbox/Public/assets/ruuvi/RuuviRexport/json/'
    p$ruuvi.datetag <- 'm210829'
  } else {
    p$path.json.export <- ''
    p$ruuvi.datetag <- ''
  }

  if (printparameters) {
    print(p)
  }
  return(p)
}
