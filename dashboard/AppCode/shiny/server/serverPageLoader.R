print("start server pageloader")

# Main pages
source(paste0(localSetting,"shiny/server/pages/main.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/pages/analysis.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/pages/visual.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/pages/textGen.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/pages/database.R"),local=TRUE)


print("end server pageloader")
