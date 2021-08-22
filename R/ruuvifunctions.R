# ruuvifunctions.R
# ...........................................................
#' read ruuvi data from local machine
#'
#' csv data to R
#'
#' @param path local path to csv files
#' @export
#' @importFrom magrittr %>%
#' @importFrom data.table fread rbindlist
#' @importFrom janitor clean_names
#'
#' @examples
#'  LoadRuuviExports(path = 'C:\\Users\\talon_000\\Dropbox\\2021\\ruuvi\\m210801saunakahala')
# ...........................................................
LoadRuuviExports <- function(path) {
  # https://stackoverflow.com/questions/11433432/how-to-import-multiple-csv-files-at-once
  List_of_file_paths <- list.files(path = path, pattern = ".csv", all.files = TRUE, full.names = TRUE)
  List_of_file_paths_filename <- list.files(path = path, pattern = ".csv", all.files = TRUE, full.names = FALSE)
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



# ...........................................................


# ...........................................................

