WITH
 team_games AS ( 
   SELECT
    a.game_id,
    team_city,
    game_date_est,
    ROW_NUMBER() OVER(PARTITION BY team_city ORDER BY game_date_est) AS game_number,
    MAX(CASE WHEN (a.team_id = b.home_team_id AND b.home_team_wins = 1) OR
              (a.team_id = b.visitor_team_id AND b.home_team_wins = 0) THEN 1
    ELSE 0 END)
   AS games_won
   FROM
    bootcamp.nba_game_details a join bootcamp.nba_games b on a.game_id = b.game_id
   GROUP BY
     a.game_id,
     team_city,
     game_date_est
  
), streak AS (
  SELECT
   game_id,
   team_city,
   game_date_est,
   -- Calculate rolling sum over a 90 game window
   SUM(games_won) OVER(PARTITION BY team_city ORDER BY game_number
   ROWS BETWEEN 89 PRECEDING AND CURRENT ROW) AS rolling_games_won
 FROM
   team_games
)
SELECT
    team_city,
    MAX(rolling_games_won) AS streak_count
  FROM
   streak
 GROUP BY
   1
 ORDER BY
   2 DESC



