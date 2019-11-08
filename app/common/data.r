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
  
  removeSpecialChars <- function(x) {
    gsub("[^a-zA-ZÀ-ʯ ]","",x)
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

  data.book.corpus <<- corp.clean(data.book$line)
  data.book.dtm <<- removeSparseTerms(DocumentTermMatrix(data.book.corpus), 0.99)
  data.book.tdm <<- removeSparseTerms(TermDocumentMatrix(data.book.corpus), 0.99)
  
  data.book_collapsed.corpus <<- corp.clean(data.book_collapsed$text)
  data.book_collapsed.dtm <<- removeSparseTerms(DocumentTermMatrix(data.book_collapsed.corpus), 0.99)
  data.book_collapsed.tdm <<- removeSparseTerms(TermDocumentMatrix(data.book_collapsed.corpus), 0.99)
  
  data.chapters.corpus <<- corp.clean(chaptersdf$text)
  data.chapters.dtm <<- removeSparseTerms(DocumentTermMatrix(data.chapters.corpus), 0.99)
  data.chapters.tdm <<- removeSparseTerms(TermDocumentMatrix(data.chapters.corpus), 0.99)
}

data.getData()
