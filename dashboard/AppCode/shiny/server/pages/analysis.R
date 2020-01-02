pages.analysis.getPage <- function() {
  tagList(
    h1("Analysis"),
    actionButton(id.analysis.button.nlp, "Natural Language Processing")
  )
}

pages.analysis.nlp <- function() {
  tagList(
    plotOutput(id.analysis.nlp.output)
  )
}
