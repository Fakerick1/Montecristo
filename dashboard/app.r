#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out ?more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

setwd("C:/Users/Rick/Desktop/Montecristo/dashboard")
localSetting <- paste0(getwd(),"/AppCode/")
source(paste0(localSetting, "common/scriptloader.R", sep=""), local=TRUE)

# Run the application 
shinyApp(ui = ui, server = server, onStart = onStart)
