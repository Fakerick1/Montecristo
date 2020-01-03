output[[id.visual.networkNGram.output]] <- renderPlot({
  text <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]] %>%
    filter(nword > 50) %>%
    select(section, text) %>%
    mutate(section = as.numeric(substr(section, 5, length(section)))) %>%
    unnest_tokens(word, text) %>%
    filter(!word %in% c(stop_words$word, "chapter", "project", "gutenberg's", "gutenberg")) %>%
    group_by(word) %>%
    filter(n() >= 20) %>%
    pairwise_cor(word, section) %>%
    filter(!is.na(correlation),
           correlation > .65) %>% #.55
    graph_from_data_frame()

    print("Done with calculating")

    ggraph(text, layout = "fr") +
    geom_edge_link(aes(edge_alpha = correlation), show.legend = TRUE) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme(
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "#D9D9D9", color = NA), # bg of the plot
        #panel.grid.major = element_blank(), # get rid of major grid
        #panel.grid.minor = element_blank(), # get rid of minor grid
        legend.background = element_rect(fill = "transparent"), # get rid of legend bg
        legend.box.background = element_rect(fill = "transparent"), # get rid of legend panel bg
    )
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
})
