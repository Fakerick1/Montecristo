libraries <- c(
  "tm",
  "dplyr",
  "wordcloud",
  "qdap",
  "ggplot2"
)
#lapply(libraries, install.packages)
lapply(libraries, library, character.only = TRUE)

