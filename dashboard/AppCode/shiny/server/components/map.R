output[[id.analysis.map.output]] <- renderLeaflet({
  currentBook <- input[[id.general.book]]

  if(!grepl("Monte Cristo|War and Peace", currentBook)) return()
  getPoints <- function(currentBook) {
    points <- c()

    if(grepl("Monte Cristo", currentBook)) {
      points <- rbind(
        cbind(5.369780, 43.296482), # Marseille
        cbind(2.352222, 48.856613), # Paris
        cbind(10.31666, 42.33333), # Isla de Montecristo
        cbind(5.326280, 43.280121), # Chateau d'if
        cbind(12.49636, 41.90278) # Rome
      )
    }

    if(grepl("War and Peace", currentBook)) {
      points <- rbind(
        cbind(30.335098, 59.934280), # St. Petersburg
        cbind(16.876497, 49.153255), # Austerlitz
        cbind(32.050365, 54.790310), # Bald Hills (Smolensk)
        cbind(37.617298, 55.755825), # Moscow
        cbind(30.773010, 59.762810), # Otradnoe
        cbind(29.244600, 46.302950) # Borodino
      )
    }

    return(points)
  }
  data <- getPoints(currentBook)

  leaflet() %>%
    addProviderTiles(providers$CartoDB,
      options = providerTileOptions(noWrap = TRUE)
    ) %>%
    addCircleMarkers(data = data, color = "#44c6d8", stroke = FALSE, radius = 8, fillOpacity = 1)
})
