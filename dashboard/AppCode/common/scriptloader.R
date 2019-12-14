print("START SCRIPTLOADER")

# load required libraries
source(paste0(localSetting,"common/libraries.R"))

# Load project configuration
source(paste0(localSetting,"common/configuration.R"))

# Load database functions
source(paste0(localSetting,"database/database.R"),local=TRUE)

# Authentication
source(paste0(localSetting,"common/serverAuthentication.R"),local=TRUE)

# Utilities
source(paste0(localSetting,"common/util.R"),local=TRUE)

#--RSHINY--#
# Shiny onstart
source(paste0(localSetting,"shiny/onStart.R"),local=TRUE)
# Shiny server
source(paste0(localSetting,"shiny/server/server.R"),local=TRUE)
# Shiny ui
source(paste0(localSetting,"shiny/ui/ui.R"),local=TRUE)

print("FINISHED SCRIPTLOADER")
