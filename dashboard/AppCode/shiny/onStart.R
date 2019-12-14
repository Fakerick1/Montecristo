onStart <- function() {
  print("Starting shiny app")
  #start connection on shiny app startup
  db.connect()

  localSetting <- paste0(getwd(),"/AppCode/")
  source(paste0(localSetting, "common/scriptloader.R", sep=""), local=TRUE)

  onStop(function() {
    rm(list = ls()) # Unload all elements from global environment
    print("Closing shiny app")
  })
}

print("shiny - Loaded onStart.R")
