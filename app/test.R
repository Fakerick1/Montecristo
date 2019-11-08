#install.packages('striprtf')
#install.packages('tm')
#install.packages('dplyr')
#install.packages('stringr')
library(striprtf)
library(tm)
library(dplyr)
library(stringr)
library(wordcloud)
library(qdap)
library(ggplot2)

#File: book.rtf, converted to txt through 'online-convert.com'
book <- read.delim("data/book.txt", header = FALSE, fileEncoding = "UTF-8-BOM", sep = "\n", stringsAsFactors = FALSE)
#Remove index, starts at line: "VOLUME ONE"
book <- data.frame(line = book[143:(nrow(book) - 357),], stringsAsFactors = FALSE)
book <- filter(book, !grepl("^[0-9]*m", book$line))
#Book = DF of lines
chapterIndices <- which(grepl("Chapter", book$line))

chapters <- list()

#as list
for (i in 1:length(chapterIndices)) {
  from <- chapterIndices[i] + 1
  to <- ifelse(i == length(chapterIndices), nrow(book), chapterIndices[i + 1] - 1)
  chapters[[book$line[chapterIndices[i]]]] <- paste(book$line[from:to], collapse = " ")
}

#as dataframe
chaptersdf <- data.frame(chapter = character(), text = character(), stringsAsFactors = FALSE)
for (i in 1:length(chapterIndices)) {
  from <- chapterIndices[i] + 1
  to <- ifelse(i == length(chapterIndices), nrow(book), chapterIndices[i + 1] - 1)
  chaptersdf <- rbind(chaptersdf, data.frame(chapter = book$line[chapterIndices[i]], text = paste(book$line[from:to], collapse = " "), stringsAsFactors = FALSE))
}

removeSpecialChars <- function(x) gsub("[^a-zA-ZÀ-ʯ ]","",x)
#Make it a corpus for cleaning
#Bug (sort of), above-mentioned > abovementioned
corpus <- chaptersdf$text %>%
  VectorSource() %>%
  VCorpus() %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(content_transformer(removeSpecialChars)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeWords, c(stopwords("english"), "the"))

dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)
mostFreq <- findMostFreqTerms(dtm, 10)
dtm_m <- as.data.frame(as.matrix(dtm), stringsAsFactors = FALSE)
term_freq_dtm <- colSums(dtm_m)
ggplot(dtm_m, aes(rownames(dtm_m)))

tdm <- TermDocumentMatrix(corpus)
tdm <- removeSparseTerms(tdm, 0.99)
plot(tdm)
associations <- findAssocs(tdm, "marseilles", 0.35)
associations_df <- list_vect2df(associations, col2 = "word", col3 = "score")
ggplot(associations_df, aes(score, word)) +
  geom_point(size = 3)


term_freq <- rowSums(tdm_m)
term_freq <- sort(term_freq, decreasing = TRUE)
terms <- names(term_freq)
commonality.cloud(tdm_m, max.words = 50)
barplot(term_freq[1:20], col = "red", las = 2)
wordcloud(terms, term_freq, max.words = 100, colors = "red")

#Plot ideas:
# n most occuring word per chapter