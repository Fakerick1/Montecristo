library(epubr)
library(mongolite)

setwd("C:/Users/Rick/Desktop/Montecristo/app")
result <- epub("montecristo.epub")
result2 <- epub("warandpeace.epub")

mcon <- mongo(collection = "montecristo", db = "mcdb", url = "mongodb://localhost")
mcon$insert(result2)

str(result)
str(result$data)
str(result$data[[1]]$text)
string <- paste(result$data[[1]]$text, collapse = '')
result$data[[1]] <- string


test <- cleanBook(result$data[[1]]$text)

cleanBook <- function(text) {
  cleaned_text <- text %>%
    VectorSource() %>%
    VCorpus() %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers)
  return(corpusToDTM(cleaned_text))
}

corpusToDTM <- function(corpus) {
  as.matrix(removeSparseTerms(DocumentTermMatrix(corpus), 0.95))
}
