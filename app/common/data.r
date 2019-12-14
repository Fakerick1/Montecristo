removeSpecialChars <- function(x) {
  gsub("[^a-zA-Z ]", "", x)
}

corp.clean <- function(text) {
  cleaned_text <- text %>%
    VectorSource() %>%
    VCorpus() %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(content_transformer(removeSpecialChars)) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeWords, c(stopwords("english"), "the"))
  
  return(cleaned_text)
}

data.getData <- function() {
  #File: book.rtf, converted to txt through 'online-convert.com'
  book <- read.delim("data/book.txt", header = FALSE, fileEncoding = "UTF-8-BOM", sep = "\n", stringsAsFactors = FALSE)
  
  #Remove index, starts at line: "VOLUME ONE"
  book <- data.frame(line = book[143:(nrow(book) - 357),], stringsAsFactors = FALSE)
  data.book <<- filter(book, !grepl("^[0-9]*m", book$line))
  
  data.book_collapsed <<- data.frame(text = paste(data.book$line, collapse = " "), stringsAsFactors = FALSE)
  #Book = DF of lines
  chapterIndices <- which(grepl("Chapter", book$line))
  
  #as dataframe
  chaptersdf <- data.frame(chapter = character(), text = character(), stringsAsFactors = FALSE)
  for (i in 1:length(chapterIndices)) {
    from <- chapterIndices[i] + 1
    to <- ifelse(i == length(chapterIndices), nrow(book), chapterIndices[i + 1] - 1)
    chaptersdf <- rbind(chaptersdf, data.frame(chapter = book$line[chapterIndices[i]], text = paste(book$line[from:to], collapse = " "), stringsAsFactors = FALSE))
  }
  data.chapters <<- chaptersdf
  
  data.book.corpus <<- corp.clean(data.book$line)
  data.book.dtm <<- DocumentTermMatrix(data.book.corpus)
  data.book.tdm <<- TermDocumentMatrix(data.book.corpus)
  
  data.book_collapsed.corpus <<- corp.clean(data.book_collapsed$text)
  data.book_collapsed.dtm <<- DocumentTermMatrix(data.book_collapsed.corpus)
  data.book_collapsed.tdm <<- TermDocumentMatrix(data.book_collapsed.corpus)
  
  data.chapters.corpus <<- corp.clean(chaptersdf$text)
  data.chapters.dtm <<- DocumentTermMatrix(data.chapters.corpus)
  data.chapters.tdm <<- TermDocumentMatrix(data.chapters.corpus)
}

data.getData()