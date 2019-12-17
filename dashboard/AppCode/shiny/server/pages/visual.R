pages.visual.getPage <- function() {
  tagList(
    h1("Visual"),
    actionButton(id.visual.button.noveltyChapterDifference, "Novelty (Chapter Difference)"),
    actionButton(id.visual.button.noveltyNewWords, "Novelty (New Words)")
  )
}

pages.visual.noveltyChapterDifference <- function() {
  tagList(
    plotOutput(id.visual.noveltyChapterDifference.output),
    p("Calculated by taking the top 50 words for every chapter, comparing them to the top 50 words of the previous chapter (amount of different words) and dividing by 50.")
  )
}

pages.visual.noveltyNewWords <- function() {
  plotOutput(id.visual.noveltyNewWords.output)
}
