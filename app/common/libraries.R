libraries <- c(
  "tm",
  "dplyr",
  "wordcloud",
  "qdap",
  "ggplot2",
  "plotly"
)
#lapply(libraries, install.packages, character.only = TRUE)
lapply(libraries, library, character.only = TRUE)
