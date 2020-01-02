Packages <- c(
    "mongolite",
    "dplyr",
    "shiny",
    "shinydashboard",
    "shinyjs",
    "zoo",
    "ggplot2",
    "lubridate",
    "chron",
    "tidyr",
    "epubr",
    "tm",
    "markovifyR",
    "keras",
    "tidyverse",
    "tokenizers",
    "tidytext",
    "widyr",
    "ggraph",
    "igraph",
    "openNLP",
    "openNLPmodels.en"
  )

lapply(Packages, library, character.only = TRUE)
print("AppCode - libraries.R")

installPackages <- function() {
  # Fill the vector with packages that need to be installed in a different way
  lapply(Packages, install.packages, character.only = TRUE)
  devtools::install_github("abresler/markovifyR")
  install.packages("openNLPmodels.en", repos = "http://datacube.wu.ac.at/", type = "source")
}
# Uncomment if packages need to be installed
#installPackages()

# Uncomment if markovify for python needs to be installed
#system("pip install markovify")

# Uncomment if tensorFlow for python needs to be installed
#system("pip install tensorFlow")
