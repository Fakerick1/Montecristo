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
      db.chapters$insert(chapterDf)

      bookDf <- chapterDf
      bookDf$data[[1]] <- paste(bookDf$data[[1]]$text, collapse = "")
      db.books$insert(bookDf)

      dtmDf <- chapterDf
      dtmDf$data <- list(cleanBook(chapterDf$data[[1]]$text, "DTM"))
      db.dtms$insert(dtmDf)

      tdmDf <- chapterDf
      tdmDf$data <- list(cleanBook(chapterDf$data[[1]]$text, "TDM"))
      db.tdms$insert(tdmDf)

      incProgress(1/n, detail = paste("Done with: ", uploadedFiles[i,]$name))
    }
  })

  init.sideBarFilters()
})

cleanBook <- function(text, kind) {
  cleaned_text <- text %>%
    VectorSource() %>%
    VCorpus() %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers)
  return(corpusToTermMatrix(cleaned_text, kind))
}

corpusToTermMatrix <- function(corpus, kind) {
  if (kind == "DTM") {
    as.data.frame(as.matrix(removeSparseTerms(DocumentTermMatrix(corpus), 0.95)), stringsAsFactors = FALSE)
  } else if (kind == "TDM") {
    as.data.frame(as.matrix(removeSparseTerms(TermDocumentMatrix(corpus), 0.95)), stringsAsFactors = FALSE)
  } else {
    return()
  }

}
