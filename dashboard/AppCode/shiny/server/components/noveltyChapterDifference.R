output[[id.visual.noveltyChapterDifference.output]] <- renderPlot({
  #Make plot here
  chapters <- db.tdms$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]]

  # Make sure there are only chapters included with more than 50 words, this is
  # done to make sure a 'chapter' like: "VOLUME IV:" is not included
  chapters <- chapters[, colSums(chapters) > 50]

  # For every column:
  # Find 50 most frequent words
  # Get difference compared to last, divide by 50
  diffDf <- data.frame(chapter = numeric(), diff = numeric())
  frequentWords <- NA
  for (i in 1:ncol(chapters)) {
    frequentWords <- rownames(head(chapters[order(chapters[,i], decreasing = TRUE), i, drop = FALSE], 50))

    if(!i %in% c(1, ncol(chapters))) {
      difference <- length(setdiff(frequentWords, prevFrequentWords)) / 50
      diffDfRow <- data.frame(chapter = i, diff = difference)
      diffDf <- rbind(diffDf, diffDfRow)
    }
    prevFrequentWords <- frequentWords
  }

  ggplot(diffDf, aes(x = chapter, y = diff)) +
    geom_line() +
    labs(x = "Chapter", y = "Difference to previous chapter") +
    ylim(0, 1) +
    theme(
      panel.background = element_rect(fill = "transparent"), # bg of the panel
      plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
      #panel.grid.major = element_blank(), # get rid of major grid
      #panel.grid.minor = element_blank(), # get rid of minor grid
      legend.background = element_rect(fill = "transparent"), # get rid of legend bg
      legend.box.background = element_rect(fill = "transparent"), # get rid of legend panel bg
      text = element_text(size = 16)
    )
}, bg = "transparent")
