pages.analysis.getPage <- function() {
  tagList(
    h1("Analysis"),
    actionButton(id.analysis.button.nlp, "Natural Language Processing"),
    actionButton(id.analysis.button.map, "Exploratory book map"),
    h1("Comparison"),
    actionButton(id.analysis.button.comparison, "Compare basic statistics on books")
  )
}

pages.analysis.nlp <- function() {
  tagList(
    dataTableOutput(id.analysis.nlp.output)
  )
}

pages.analysis.map <- function() {
  tagList(
    leafletOutput(id.analysis.map.output)
  )
}

pages.analysis.comparison <- function() {
  tagList(
    dataTableOutput(id.analysis.comparison.output)
  )
}
