pages.visual.getPage <- function() {
  tagList(
    h1("Novelty"),
    actionButton(id.visual.button.noveltyChapterDifference, "Novelty (Chapter Difference)"),
    actionButton(id.visual.button.noveltyNewWords, "Novelty (New Words)"),
    h1("Combinations"),
    actionButton(id.visual.button.networkNGram, "Word network"),
    actionButton(id.visual.button.topBigrams, "Top 20 Bi-grams"),
    actionButton(id.visual.button.topTfIdfBigrams, "Top 20 Bi-grams weighted with TF-IDF")
  )
}

pages.visual.noveltyChapterDifference <- function() {
  tagList(
    plotOutput(id.visual.noveltyChapterDifference.output),
    p("Calculated by taking the top 50 words for every chapter, comparing them to the top 50 words of the previous chapter (amount of different words) and dividing by 50.")
  )
}

pages.visual.noveltyNewWords <- function() {
  tagList(
    plotOutput(id.visual.noveltyNewWords.output),
    p("Calculated by taking the unique set of words for every chapter and comparing them to the unique set of words for all previous chapters combined. The number of new words is divided by the total number of words in a chapter.")
  )
}

pages.visual.networkNGram <- function() {
  tagList(
    plotOutput(id.visual.networkNGram.output)
  )
}

pages.visual.topBigrams <- function() {
  tagList(
    plotOutput(id.visual.topBigrams.output)
  )
}

pages.visual.topTfIdfBigrams <- function() {
  tagList(
    plotOutput(id.visual.topTfIdfBigrams.output)
  )
}
