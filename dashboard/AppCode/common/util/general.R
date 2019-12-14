# Create a custom soccer pitch for the ggsoccer package. Which is then used by ggplot2 to plot a soccer field.
util.general.CustomPitchScaled <- function() {
  x <- 102 # Standard field length
  y <- 65 # Standard field width
  pitch_custom <- list(
    length = x,
    width = y,
    penalty_box_length = (x/6),
    penalty_box_width = (y/2),
    six_yard_box_length = (x/(75/4)),
    six_yard_box_width = (y/4),
    penalty_spot_distance = (x/(75/8)),
    goal_width = (y/8),
    origin_x = 0,
    origin_y = 0
  )
  return(pitch_custom)
}

# String builder for the KNVB season filter.
util.general.getSeasonStrings <- function(dates) {
  if (length(dates) == 0) return(c(""))
  # Get seasons of first and last matches
  # If month is between january and june, beginning of the season is in the previous year
  getSeason <- function(date) {
    month <- as.numeric(substr(date, 6, 7))
    if (month >= 1 && month <= 6) {
      season <- as.numeric(substr(date, 1, 4)) - 1
    } else {
      season <- as.numeric(substr(date, 1, 4))
    }
    return(season)
  }

  dates <- na.omit(dates)
  firstMatch <- min(dates)
  lastMatch <- max(dates)

  firstSeason <- getSeason(firstMatch)
  lastSeason <- getSeason(lastMatch)

  # Create season strings like: "2018/'19" (format from KNVB used)
  seasons <- lapply(c(firstSeason:lastSeason), function(season){
    return(paste0(season, "/\'", substr(as.character(season + 1), 3, 4)))
  })
}

util.general.getMonthsForSeasonStrings <- function(seasonStrings) {
  # input: Vector of strings like "2018/'19"
  months <- lapply(seasonStrings, function(seasonString){
    firstYear <- paste0(substr(seasonString, 1, 4), "-", sprintf("%02d", c(8:12)))
    secondYear <- paste0("20", substr(seasonString, 7, 8), "-", sprintf("%02d", c(1:6)))
    return(c(firstYear, secondYear))
  })
  # output: Vector of strings like c("2018-08", "2018-09" ... "2019-06")
  return(unlist(months))
}

# If a page is based on the filter, display "select a filter" if not yet selected
util.general.checkFilteredPage <- function(filterInput, displayText) {
  if (is.null(filterInput)) return(
    div(
      class = "card",
      h2(strings[string.general.selectFilter, LANG]),
      hr(),
      p(strings[displayText, LANG])
    )
  )
  else return(div())
}

# Display a header for a page
util.general.pageHeader <- function(backId, header) {
  div(
    class = "header-current-page",
    actionButton(backId, label = strings[string.general.back, LANG], class = "back-button"),
    h1(strings[header, LANG]),
  )
}

# Display a header for a page including an export to pdf button
util.general.pageHeaderWithExport <- function(backId, header, downloadId) {
  div(
    class = "header-current-page",
    actionButton(backId, label = strings[string.general.back, LANG], class = "back-button"),
    downloadButton(downloadId, 
                   strings[string.player.button.exportToPdf, LANG], 
                   ),
    h1(strings[header, LANG])
  )
}

# If the card is going to be displayed
util.general.pageCard <- function(text, output) {
  div(
    class = "card",
    h2(strings[text, LANG]),
    hr(),
    plotOutput(output)
  )
}

# If the card is only displayed if it is selected
util.general.tryPageCard <- function(type, toPlot, input) {
  if (strings[type, LANG] %in% input) return(util.general.pageCard(type, toPlot))
  else return(div())
}

# Creates the radar plot using the given data
util.general.getRadarPlot <- function(data) {
  ggradar(data, gridline.mid.linetype = "blank",
    label.gridline.min = FALSE, label.gridline.mid = FALSE, label.gridline.max = FALSE,
    group.line.width = 1.25, group.point.size = 4, background.circle.colour = "#E40421",
    background.circle.transparency = 0.1, group.colours = c("#E40421", "grey"),
    legend.position = "top", legend.text.size = 10, base.size = 8, grid.label.size = 6)
}

# Creates a tablegrob (plottable table) out of the given data,
util.general.getTableGrob <- function(data) {
  # Change parameters here to change how tables look in the app/exports
  tableGrob(data, rows = NULL, theme = ttheme_default(
    base_size = 14, padding = unit(c(4, 4), "mm"),
    core = list(bg_params = list(fill = c("#FFFFFF", "#D9D9D9"), col = NA)),
    colhead = list(bg_params = list(fill = c("#D9D9D9"), col = NA))
    ))
}

# Creates the text and color for all menu buttons
util.general.getMenuButton <- function(id, menuName, imagePath) {
  actionButton(id,
    class = "button-main-menus",
    style = paste0('background-image: url("/images/buttons/', imagePath, '");'),
    span(strings[menuName, LANG])
  )
}
