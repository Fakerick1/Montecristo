#### ShinyID function ####
# ShinyID asks the the password of the usename of the session from the database to determine the data to return for that user.
ShinyID <- function (username) {
  # connect to database, credentials are not arguments of the function so they need to be declared inside this script
  # retrieve the password and return it
  secUserPassword <- dbGetQuery(db.DWH.connection, paste("[dbo].[UT_DM_RSHINY_INIT] ", paste0(username)))
  
  return(secUserPassword)
} 

print("AppCode - authentication.R")