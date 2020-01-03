pages.analysis.getPage <- function() {
  tagList(
    h1("Analysis"),
    actionButton(id.analysis.button.nlp, "Natural Language Processing"),
    actionButton(id.analysis.button.map, "Exploratory book map")
  )
}

pages.analysis.nlp <- function() {
  tagList(
    tableOutput(id.analysis.nlp.output)
  )
}

pages.analysis.map <- function() {
  tagList(
    leafletOutput(id.analysis.map.output)
  )
}
