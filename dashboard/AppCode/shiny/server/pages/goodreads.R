pages.goodreads.getPage <- function() {
  tagList(
    h1("Goodreads"),
    dataTableOutput(id.goodreads.output)
  )
}
