source("common/libraries.R")
source("common/data.R")

#data.book_collapsed is het hele boek, gebruiken om meest gevonden terms te vinden

terms <- findMostFreqTerms(data.book_collapsed.dtm, 50)
terms50 <- names(terms[['1']])
df <- as.data.frame(as.matrix(data.chapters.dtm), stringsAsFactors = FALSE)

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
test <- select(df, terms50)
test <- cbind(id = as.numeric(rownames(test)), test, stringsAsFactors = FALSE)
test$said <- normalize(test$said)
test$count <- normalize(test$count)
ggplot(test, aes(x = id)) +
  geom_line(aes(y = count), col = "red") +
  geom_line(aes(y = said), col = "green")

ggplot(test, aes(x = id, y = count)) +
  geom_bar(stat="identity", col = "blue") +
  geom_bar(aes(y = said), stat = "identity", col = "green")

df <- as.data.frame(as.matrix(data.chapters.tdm), stringsAsFactors = FALSE)
test <- df[terms50,]
test <- cbind(word = rownames(test), test, stringsAsFactors = FALSE)

ggplot(test)
plot(test$word, test$`1`)
