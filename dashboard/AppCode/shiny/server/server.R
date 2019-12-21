server <- function(input, output, session){
  onServer <--0

  # if (onServer == 1){
  #
  #   spCredentials <- paste(session$user, ShinyID(username = paste(session$user)),sep=",")
  #   spParameters <- paste(spCredentials,1,2,0,0,0,sep=",")
  #
  # } else {
  #
  #   spCredentials <- paste("ShinyTestAccount", ShinyID(username = paste("ShinyTestAccount")),sep=",")
  #   spParameters <- paste(spCredentials,1,2,0,0,0,sep=",")
  #   spParametersLocationOnly <- paste(spCredentials,1,sep=",")
  #
  # }

  # General
  source(paste0(localSetting,"shiny/server/serverScriptLoader.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/InitDataLoad.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/serverPageLoader.R"),local=TRUE)

  # Components
  source(paste0(localSetting,"shiny/server/components/noveltyChapterDifference.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/components/noveltyNewWords.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/components/topBigrams.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/components/topTfIdfBigrams.R"),local=TRUE)
  source(paste0(localSetting,"shiny/server/components/networkNGram.R"),local=TRUE)

  output$mainPage <- renderUI(pages.main.getPage())

  # init sidebar filters
  observe({
    init.sideBarFilters()
  })

  # Hide filter hamburger
  shinyjs::addClass(selector = "body > div > div > header > nav > a", class = "hidden")
}

print("shiny - server - server.R")
