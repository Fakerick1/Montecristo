normalize <- function(column) {
  min <- min(column)
  max <- max(column)
  return((column - min)/(max - min))
}