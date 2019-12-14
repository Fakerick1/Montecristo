# Loaded by serverscriptloader instead of scriptloader
# Get the pace of a player using explosiveness, deceleration and running speed.
util.getPace <- function(accEvent, decEvent, statistics) {
  acc <- util.getExplosiveness(accEvent, "mean")
  dec <- util.calculateDeceleration(mean(decEvent$avgDuration), mean(decEvent$avgBeginSpeed))
  maxRS <- mean(statistics$avgMaxRunningSpeed)
  return(acc + dec + maxRS)
}

util.calculateAcceleration <- function(dist, time, beginSpeed) {
  return ((dist / time - beginSpeed) / time)
}

util.calculateDeceleration <- function(time, beginSpeed) {
  return((0 - beginSpeed) / time)
}

util.getShooting <- function(statistics) {
  mean(statistics$avgShots)
}

# Calculate value for passing using succesful forward and backward passes, and avg passes per match
util.getPassing <- function(passing) {
  forwardPassingPercentage <- mean(passing$avgSuccesfulForwardPasses) / mean(passing$avgForwardPasses)
  backwardPassingPercentage <- mean(passing$avgSuccesfulBackwardPasses) / mean(passing$avgBackwardPasses)

  return(mean(passing$avgPassesPerMatch) * forwardPassingPercentage * backwardPassingPercentage)
}

# Calculate value for dribbling using touches, dribbling and posesionTime combined with a value for turning
util.getDribbling <- function(statistics, turn) {
  touches <- mean(statistics$avgTouches)
  dribbling <- mean(statistics$avgDribbleDistance) / mean(statistics$avgMaxDribbleSpeed)
  possessionTime <- mean(statistics$avgPossessTime) / 1000 # assuming possessTime is in ms.
  turning <- util.getTurning(turn, "mean")

  return((touches + dribbling + possessionTime) * turning)
}

util.getDefending <- function(statistics) {
  return(mean(statistics$avgTackles) / mean(statistics$avgClearances))
}

# Calculate value for physical using vo2, heart rate and exerciseLoad
util.getPhysical <- function(statistics) {
  vo2 <- mean(statistics$avgMaxVO2)
  hr <- mean(statistics$avgMaxHR) / 100
  exLoad <- mean(statistics$avgExerciseLoad) / 100
  return(vo2 * abs(hr/exLoad))
}

# Check values to not exceed twice the average or not less than 0
util.checkValuesAgainstAverages <- function(player, average) {
  if (is.nan(player) | is.nan(average)) return(0)
  value <- player
  if (value > (average*2)) { value <- (average*2) }
  if (value < 0) { value <- 0 }
  return(value)
}

# Make sure a value is not larger than max or less than min.
util.checkValues <- function(player, min, max) {
  if (is.nan(player) | is.nan(max) | is.nan(min)) return(0)
  value <- player
  if (value > max) { value <- max }
  if (value < min) { value <- min }
  return(value)
}

util.getIntensity <- function(statistics, type) {
  if (type == "mean") return(mean(statistics$avgExerciseLoad))
  if (type == "min") return(min(statistics$avgExerciseLoad))
  if (type == "max") return(max(statistics$avgExerciseLoad))
}

util.getRunningDistance <- function(statistics, type) {
  if (type == "mean") return(mean(statistics$avgRunningDistance))
  if (type == "min") return(min(statistics$avgRunningDistance))
  if (type == "max") return(max(statistics$avgRunningDistance))
}

# Get the high running speed distance, where we determine 75% of the average max running speed
# to be 'high' speed.
util.getHighSpeedDistance <- function(statistics, playerId, type) {
  highRunningSpeed <- mean(statistics$avgMaxRunningSpeed) * 0.75

  dist <- db.DWH.selectotron.player.highSpeedDistance(highRunningSpeed)
  if (playerId != 0) dist <- dist[dist$playerId == playerId,]

  if (type == "mean") return(mean(dist$runningDistance))
  if (type == "min") return(min(dist$runningDistance))
  if (type == "max") return(max(dist$runningDistance))
}

util.getMaxSpeed <- function(statistics, type) {
  if (type == "mean") return(mean(statistics$avgMaxRunningSpeed))
  if (type == "min") return(min(statistics$avgMaxRunningSpeed))
  if (type == "max") return(max(statistics$avgMaxRunningSpeed))
}

util.getExplosiveness <- function(acc, type) {
  if (type == "mean") return(util.calculateAcceleration(mean(acc$avgDistance), mean(acc$avgDuration), mean(acc$avgBeginSpeed)))
  if (type == "min") return(util.calculateAcceleration(min(acc$avgDistance), min(acc$avgDuration), max(acc$avgBeginSpeed)))
  if (type == "max") return(util.calculateAcceleration(max(acc$avgDistance), max(acc$avgDuration), min(acc$avgBeginSpeed)))
}

util.getTurning <- function(turn, type) {
  if (type == "mean") return((100/mean(abs(turn$avgAngle)) * mean(turn$avgDuration)))
  if (type == "min") return((100/max(abs(turn$avgAngle)) * min(turn$avgDuration)))
  if (type == "max") return((100/min(abs(turn$avgAngle)) * max(turn$avgDuration)))
}

# Function assumes height = CM, weight = KG
util.player.calculateBMI <- function(height, weight) {
  return(round((weight / ((height/100)^2)), 2))
}

util.player.normalizeDF <- function(dataFrame) {
  # For each row: Minima = 0, which is the 3rd row, maxima = 1, which is the 4rd row.
  # Normalize function is as follows: (x-min(x)) / (max(x)-min(x))
  normalize <- function(val, min, max) ((val-min) / (max-min))
  normalizeVector <- function(vector) {
    oldTeam <- vector[1]
    oldPlayer <- vector[2]
    oldMin <- vector[3]
    oldMax <- vector[4]
    normalizedTeam <- round(normalize(oldTeam, oldMin, oldMax), 2) * 100
    normalizedPlayer <- round(normalize(oldPlayer, oldMin, oldMax), 2) * 100
    normalizedMin <- round(normalize(oldMin, oldMin, oldMax), 2) * 100
    normalizedMax <- round(normalize(oldMax, oldMin, oldMax), 2) * 100
    return(c(normalizedTeam, normalizedPlayer, "Minima" = normalizedMin, "Maxima" = normalizedMax))
  }

  normalizedDataFrame <- c("","","","")
  for (i in 1:ncol(dataFrame)) {
    normalizedDataFrame <- cbind(normalizedDataFrame,normalizeVector(dataFrame[,i]))
  }
  normalizedDataFrame <- normalizedDataFrame[,-1]

  return(normalizedDataFrame)
}
