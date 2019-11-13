source("common/libraries.R")
source("common/data.R")
source("common/functions.R")
#data.book_collapsed is het hele boek, gebruiken om meest gevonden terms te vinden

terms <- findMostFreqTerms(data.book_collapsed.dtm, 10)
terms50 <- names(terms[['1']])
df <- as.data.frame(as.matrix(data.chapters.dtm), stringsAsFactors = FALSE)


test <- select(df, terms50)
test <- cbind(id = as.numeric(rownames(test)), test)
test <- test[40:50,]

p <- plot_ly(test, x = ~id, mode = "none", stackgroup = "one", groupnorm = "percent")

for (name in colnames(test)[!colnames(test) == "id"]) {
  p <- add_trace(p, data = test, y = test[[name]], name = name, type = "scatter", mode = "lines")
}

p
#16:45 metro

# Dashboard ideas:
# Plot a given amount of most occuring terms over a given range of chapters
# Plot the occurances of a given term over a given range of chapters
# Plot the locations throughout the book on a world map
# Plot relations to other words for a given word

# Make an algorithm or ML program that, given a book, can find the locations in that book and plot them