observeEvent(input[[id.database.button.menu]], {
  util.filter.showSidebar(FALSE)
  observers.main.updateActiveTab(id.button.menuItem.database)
  output$mainPage <- renderUI(pages.database.getPage())
})

observeEvent(input[[id.database.fileInput]], {

  changeStatusMessage <- function(message) {
    output[[id.database.statusMessage]] <- renderText({message})
  }
  uploadedFiles <- input[[id.database.fileInput]]

  withProgress(message = "Importing book", value = 0, {
    n <- nrow(uploadedFiles)

    for (i in 1:n) {
      chapterDf <- epub(uploadedFiles[i,]$datapath)

      bookDf <- chapterDf
      bookDf$data[[1]] <- paste(bookDf$data[[1]]$text, collapse = "")
      db.books$insert(bookDf)

      chapterDf$dtm <- list(cleanBook(chapterDf$data[[1]]$text))
      db.chapters$insert(chapterDf)

      incProgress(1/n, detail = paste("Done with: ", uploadedFiles[i,]$name))
    }
  })

  init.sideBarFilters()
})

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
  as.data.frame(as.matrix(removeSparseTerms(DocumentTermMatrix(corpus), 0.95)), stringsAsFactors = FALSE)
}
