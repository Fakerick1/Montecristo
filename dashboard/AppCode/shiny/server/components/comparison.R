output[[id.analysis.comparison.output]] <- renderDataTable({
  selectedBooks <- input[[id.general.bookMultiple]]
  if(is.null(selectedBooks)) return()

  getBookInfo <- function(book) {
    data <- db.books$find(
        query = paste0('{"title": "', book, '" }')
    )

    freq <- termFreq(data$data[[1]], control = list(stopwords = TRUE))
    mostFreqTerms <- names(findMostFreqTerms(freq, 10))

    chapters <- db.chapters$find(
      query = paste0('{"title": "', book, '"}')
    )$data[[1]] %>%
      filter(nword > 50)
    amountOfChapters <- nrow(chapters)
    amountOfWords <- sum(chapters$nword)
    meanWordsPerChapter <- mean(chapters$nword)

    data.frame(Title = data$title, Author = data$creator, Subject = data$subject,
      Chapters = amountOfChapters, Words = amountOfWords, AvgWordsPerChapter = meanWordsPerChapter,
      TopTenTerms = paste(mostFreqTerms, collapse = ", "))
  }

  info <- NA

  for (book in selectedBooks) {
    curInfo <- getBookInfo(book)
    ifelse(is.na(info), info <- curInfo, info <- rbind(info, curInfo))
  }
  
  return(datatable(info, filter = "top"))
})
