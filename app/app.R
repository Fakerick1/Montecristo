source("common/libraries.R")
source("common/data.R")

#data.book_collapsed is het hele boek, gebruiken om meest gevonden terms te vinden

terms <- findMostFreqTerms(data.book_collapsed.dtm, 50)
terms50 <- names(terms[['1']])
df <- as.data.frame(as.matrix(data.chapters.dtm), stringsAsFactors = FALSE)

test <- select(df, terms50)
test <- cbind(id = rownames(test), test)
ggplot(test, aes(id), group = id) + 
  geom_line(aes(y = said)) +
  geom_line(aes(y = count))

df <- as.data.frame(as.matrix(data.chapters.tdm), stringsAsFactors = FALSE)
test <- select(df, )