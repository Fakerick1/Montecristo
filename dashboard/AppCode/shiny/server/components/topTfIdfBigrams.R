output[[id.visual.topTfIdfBigrams.output]] <- renderPlot({
  text <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]] %>%
    filter(nword > 50) %>%
    select(section, text) %>%
    mutate(section = as.numeric(substr(section, 5, length(section)))) %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
    count(section, bigram, sort = TRUE) %>%
    bind_tf_idf(bigram, section, n) %>%
    arrange(desc(tf_idf))

    print(str(text))
  # ggplot(text, aes(x = reorder(bigram, n), y = n)) +
  # geom_bar(stat = "identity", show.legend = FALSE, colour = "#1f8897", fill = "#1f8897") +
  # labs(y = "Number of occurences", x = "Word combination") +
  # coord_flip() +
  # theme(
  #   panel.background = element_rect(fill = "transparent"), # bg of the panel
  #   plot.background = element_rect(fill = "#D9D9D9", color = NA), # bg of the plot
  #   #panel.grid.major = element_blank(), # get rid of major grid
  #   #panel.grid.minor = element_blank(), # get rid of minor grid
  #   legend.background = element_rect(fill = "transparent"), # get rid of legend bg
  #   legend.box.background = element_rect(fill = "transparent"), # get rid of legend panel bg
  #   text = element_text(size = 16)
  # )
}, bg = "transparent")
