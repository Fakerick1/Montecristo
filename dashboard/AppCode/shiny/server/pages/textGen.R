pages.textGen.getPage <- function() {
  tagList(
    actionButton(id.textGen.button.markov, "Markov"),
    actionButton(id.textGen.button.load, "Load model"),
    actionButton(id.textGen.button.neural.generate, "Generate phrase"),
    actionButton(id.textGen.button.neural.train, "Train Neural Network"),
    hr(),
    textOutput(id.textGen.output)
  )
}
