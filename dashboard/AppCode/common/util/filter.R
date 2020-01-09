# Remove or add the "sidebar-collapse" class to the html body based on the parameter
util.filter.showSidebar <- function(shouldShow) {
  if (shouldShow) shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
  else shinyjs::addClass(selector = "body", class = "sidebar-collapse")
}

# Set the filter for a page.
# Creates a set of ids for each page and shows only the set of filters that belong to the parameter.
util.filter.setFilter <- function(page) {
  filterIds <- c(id.general.book, id.general.chapter, id.general.word,
    id.textGen.markov.maxOverlapTotal, id.textGen.markov.maxOverlapRatio,
    id.textGen.markov.maxSentenceLength, id.general.bookMultiple,
    id.goodreads.userid, id.goodreads.apikey)

  # Visual
  filterGroups.visual <- c(id.general.book, id.general.chapter, id.general.word)
  filterGroups.visual.novelty <- c(id.general.book)

  # Textgen
  filterGroups.textGen <- c(
    id.general.book, id.textGen.markov.maxOverlapTotal, id.textGen.markov.maxOverlapRatio,
    id.textGen.markov.maxSentenceLength)

  # Analysis
  filterGroups.analysis <- c(id.general.book, id.general.chapter)
  filterGroups.analysis.comparison <- c(id.general.bookMultiple)

  # Goodreads
  filterGroups.goodreads <- c(id.goodreads.userid, id.goodreads.apikey)

  # Put the filters needed for a page into a vector, based on selected page
  # Make it into a global variable so we can find out what filters are used on the current page
  filterGroups.selectedFilters <<- switch(page,
    "Visual" = filterGroups.visual,
    "TextGen" = filterGroups.textGen,
    "Analysis" = filterGroups.analysis,
    "Novelty" = filterGroups.visual.novelty,
    "BookMultiple" = filterGroups.analysis.comparison,
    "Goodreads" = filterGroups.goodreads
  )

  # Loop through all filter IDs and show/hide based on if they are in toShow
  for (id in filterIds) {
    if (id %in% filterGroups.selectedFilters) shinyjs::show(id)
    else shinyjs::hide(id)
  }
}
