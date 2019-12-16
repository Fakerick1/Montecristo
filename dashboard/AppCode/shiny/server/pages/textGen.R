pages.textGen.getPage <- function() {
  tagList(
    actionButton(id.textGen.button.markov, "Markov"),
    actionButton(id.textGen.button.neural, "Neural network"),
    hr(),
    textOutput(id.textGen.output)
  )
}
