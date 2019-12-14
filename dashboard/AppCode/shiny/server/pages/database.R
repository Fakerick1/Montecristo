pages.database.getPage <- function() {
  tagList(
    h1("Database"),
    fileInput(id.database.fileInput, "Choose EPUB file(s)", multiple = TRUE),
    textOutput(id.database.statusMessage)
  )
}
