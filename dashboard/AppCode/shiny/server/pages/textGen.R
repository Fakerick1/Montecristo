pages.textGen.getPage <- function() {
  tagList(
    actionButton(id.textGen.button.markov, "Markov"),
    actionButton(id.textGen.button.neural.generate, "Generate phrase using Neural Network"),
    actionButton(id.textGen.button.neural.train, "Train Neural network (can take a long time)"),
    hr(),
    textOutput(id.textGen.output)
  )
}
