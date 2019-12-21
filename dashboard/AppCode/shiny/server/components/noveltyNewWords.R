output[[id.visual.noveltyNewWords.output]] <- renderPlot({
  # For every chapter in selected book, get unique words
  text <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]] %>%
    filter(nword > 50) %>%
    pull(text) %>%
    tokenize_words(lowercase = FALSE, strip_numeric = TRUE, simplify = TRUE, stopwords = c("Chapter"))
  text <- lapply(text, unique)

  # For every chapter, add words to words vectorW
  words <- c()
  diffs <- c()
  for (i in 1:length(text)) {
    if (!i %in% c(1, length(text))) {
      diff <- setdiff(text[[i]], words)
      words <- c(words, diff)
      diffs <- c(diffs, length(diff) / length(text[[i]]))
    } else if (i == 1) {
      words <- text[[i]]
      diffs <- c(diffs, 1)
    }
  }

  diffs <- data.frame(chapter = 1:length(diffs), diff = diffs, stringsAsFactors = FALSE)

  ggplot(diffs, aes(x = chapter, y = diff)) +
    geom_line(colour = "#1f8897") +
    labs(x = "Chapter", y = "Ratio of new words to non-new words") +
    ylim(0, 1) +
    theme(
      panel.background = element_rect(fill = "transparent"), # bg of the panel
      plot.background = element_rect(fill = "#D9D9D9", color = NA), # bg of the plot
      #panel.grid.major = element_blank(), # get rid of major grid
      #panel.grid.minor = element_blank(), # get rid of minor grid
      legend.background = element_rect(fill = "transparent"), # get rid of legend bg
      legend.box.background = element_rect(fill = "transparent"), # get rid of legend panel bg
      text = element_text(size = 16)
    )
}, bg = "transparent")
