db.DWH.selectotron.player.allBasicPlayerStatistics <- function() {
  db.DWH.selectotron(
    select = "player.playerId, player.name, count(distinct mts.matchId), AVG(mts.runningDistance) AS avgRunningDistance, AVG(mts.maxRunningSpeed) AS avgMaxRunningSpeed,
              AVG(mts.dribbleDistance) AS avgDribbleDistance,
              AVG(mts.maxDribbleSpeed) AS avgMaxDribbleSpeed,
              AVG(mts.shots) AS avgShots,
              AVG(mts.passes) AS avgPasses,
              AVG(mts.touches) AS avgTouches,
              AVG(mts.clearances) AS avgClearances,
              AVG(mts.tackles) AS avgTackles,
              AVG(mts.possessTime) AS avgPossessTime,
              AVG(mts.maxHR) AS avgMaxHR,
              AVG(mts.maxVO2) AS avgMaxVO2,
              AVG(mts.exerciseLoad) AS avgExerciseLoad,
              mts.team",
    from = "clean_player as player",
    join = "LEFT JOIN clean_match_teammates_statistics AS mts on mts.playerId = player.playerId",
    group_by = "player.playerId",
    order_by = "player.playerId",
    filter_alias = "mts",
    filter_player = FALSE)
}

db.DWH.selectotron.player.allImaEventAverages <- function() {
  db.DWH.selectotron(
    select = "playerId, type,
            	AVG(duration) as avgDuration,
            	AVG(distance) as avgDistance,
            	AVG(beginSpeed) as avgBeginSpeed,
            	AVG(angle) as avgAngle",
    from = "clean_ima_event",
    where = "type IN ('ACC', 'DEC', 'LEFT_TURN', 'RIGHT_TURN')",
    group_by = "playerId, type",
    order_by = "playerId",
    filter_player = FALSE,
    filter_match = FALSE,
    filter_team = FALSE,
    filter_season = FALSE)
}

db.DWH.selectotron.player.allSummedPassingEvents <- function() {
  db.DWH.selectotron(
    select = "playerId,
          	  COUNT(type) AS numberOfPasses,
              SUM(CASE WHEN isForwardPass = 'true' THEN 1 ELSE 0 END) as forwardPasses,
              SUM(CASE WHEN isForwardPass = 'false' THEN 1 ELSE 0 END) as backwardPasses,
              SUM(CASE WHEN isForwardPass = 'true' AND isSucceeded = 'true' THEN 1 ELSE 0 END) as succesfulForwardPasses,
              SUM(CASE WHEN isForwardPass = 'false' AND isSucceeded = 'true' THEN 1 ELSE 0 END) as succesfulBackwardPasses,
              COUNT(DISTINCT matchId) as matches",
    from = "clean_event_scaled",
    where = "type = 'pass'",
    group_by = "playerId",
    order_by = "playerId",
    filter_player = FALSE,
    filter_match = FALSE,
    filter_team = FALSE,
    filter_season = FALSE)
}

db.DWH.selectotron.player.highSpeedDistance <- function(highSpeed) {
  db.DWH.selectotron(
    select = "playerId, SUM(runningDistance) AS runningDistance",
    from = "clean_interval",
    where = paste0("maxRunningspeed > ", highSpeed),
    group_by = "playerId, matchId")
}

db.DWH.selectotron.player.BasicPlayerStatistics <- function() {
  db.DWH.selectotron(
    from = "clean_match_teammates_statistics")
}

db.DWH.selectotron.player.generalPlayerInformation <- function() {
  db.DWH.selectotron(
    from = "clean_player",
    filter_team = FALSE,
    filter_match = FALSE,
    filter_season = FALSE)
}

db.DWH.selectotron.player.getTeam <- function(player) {
  na.omit(db.DWH.selectotron(
    select = "distinct(team)",
    from = "clean_match_teammates_statistics",
    where = paste0("playerId = ", player),
    filter_player = FALSE,
    filter_team = FALSE))
}

db.DWH.selectotron.player.getPlayersForTeam <- function(team) {
  na.omit(db.DWH.selectotron(
    select = "distinct(playerId)",
    from = "clean_match_teammates_statistics",
    where = paste0("team = \"", team, "\""),
    filter_player = FALSE,
    filter_team = FALSE))
}

db.DWH.selectotron.player.meanGeneralPlayerInformation <- function() {
  db.DWH.selectotron(
    select = "AVG(weight) as AvgWeight, AVG(height) as AvgHeight, MIN(weight) AS MinWeight, MIN(height) AS MinHeight, MAX(weight) AS MaxWeight, MAX(height) AS MaxHeight",
    from = "clean_player",
    filter_player = FALSE,
    filter_team = FALSE,
    filter_match = FALSE,
    filter_season = FALSE)
}
