
# main_RuuviR_package_creation.R
# 1) Top-right corner - new project, create folder, create git repo


if (FALSE) {
  # create manually (or mkdir) path to libs and run:
  .libPaths()
  .libPaths(c("C:/R/libs", .libPaths() ) )
}

.libPaths()

if (!require(devtools)) install.packages("devtools")
library(devtools)

if (!require(testthat)) install.packages("testthat")
library(testthat)

if (!require(pkgdown)) install.packages("pkgdown")
library(pkgdown)

library(Rcpp)

p.path.git <- "C:/Users/talon_000/git/" # Lenovo
p.package.name <- "RuuviR"
getwd()
setwd(paste0(p.path.git, p.package.name) )

setwd(p.path.git)

# one time: devtools::create(p.package.name)
# overwrite Rproj.

dir("RuuviR/R")


# Create tutorials ------------------
setwd(paste0(p.path.git, p.package.name) )
if (FALSE) {
  # run only once: usethis::use_vignette("RuuviR-basic-visualization", title = "Basic Ruuvitag visualizations")

}

if (FALSE) {
  # if devtools::document(p.package.name) not working:
  install.packages('Rcpp') # Error in FUN(X[[i]], ...) : function 'Rcpp_precious_remove' not provided by package 'Rcpp'
  library(Rcpp) # https://stackoverflow.com/questions/68416435/rcpp-package-doesnt-include-rcpp-precious-remove
}

if (FALSE) {

  base::detach(package:RuuviR, unload = TRUE)

  # Rtools -------------------------
  # Please download and install Rtools 4.0 from https://cran.r-project.org/bin/windows/Rtools/.
  # C:\rtools40
  # Windows uses a toolchain bundle called rtools40.
  # You can do this with a text editor, or from R like so (note that in R code you need to escape backslashes):
  if (FALSE) writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
  # RESTART Rstudio ->
  Sys.which("make")
  ## "C:\\rtools40\\usr\\bin\\make.exe" <-- OK
  # ................................
}



setwd(paste0(p.path.git, p.package.name) )
# use_gpl3_license()

setwd(p.path.git)
devtools::document(p.package.name)
devtools::check(p.package.name)

pkgdown::build_site(new_process = FALSE) # https://github.com/r-lib/pkgdown/issues/1158

pkgdown::build_site(p.package.name)

devtools::build(p.package.name)


p.description.version.number <- '0.0.0.0001'
install.packages(paste0(p.path.git, p.package.name,"_",p.description.version.number,".tar.gz")) # use the same version number as in DESCRIPTION




