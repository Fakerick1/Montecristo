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
    "tidyr"
  )

lapply(Packages, library, character.only = TRUE)
print("AppCode - libraries.R")

installPackages <- function() {
  # Fill the vector with packages that need to be installed in a different way
  lapply(Packages, install.packages, character.only = TRUE)
}

# Uncomment if packages need to be installed
#installPackages()