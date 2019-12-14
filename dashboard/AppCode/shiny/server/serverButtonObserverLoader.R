print("start loading server button observers")

source(paste0(localSetting,"shiny/server/observers/main.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/observers/analysis.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/observers/textGen.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/observers/visual.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/observers/database.R"),local=TRUE)

print("end loading server button observers")
