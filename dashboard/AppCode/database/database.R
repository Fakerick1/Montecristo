# R file which handles the database calls, all functions and variables have the prefix db.
# The database should be configured inside the configuration.R script

# Created database connection
db.connect <- function() {
  mongoConnect <- function(collectionName) mongo(collection = collectionName, db = "mcdb", url = "mongodb://localhost")
  db.books <<- mongoConnect("books")
  db.chapters <<- mongoConnect("chapters")
  
  print("DB connection enabled for DWH and DM")
}

# Closes the db.connection
db.disconnect <- function(db.connection) {
  db.connection$disconnect
  print("DB connection closed")
}

print("AppCode - database - database.R")
