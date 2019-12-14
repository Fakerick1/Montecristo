print("start server scriptloader")

#source(paste0(localSetting,"database/SQLfunctions/selectotron.R"),local=TRUE)
source(paste0(localSetting,"common/util/database.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/sideBarFilters/initSideBarFilter.R"),local=TRUE)
source(paste0(localSetting,"shiny/server/serverButtonObserverLoader.R"),local=TRUE)

print("end server scriptloader")
