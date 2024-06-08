-- Create a grouping sets table
-- using the following combinations
-- player, team
-- player, season
-- team
-- to aggregate points across
-- these dimensions; this table
-- will be used to answer the next
-- three queries
CREATE OR REPLACE TABLE aleemrahil84520.game_details_dashboard AS
WITH
  combined AS (
    SELECT 
     player_name AS player_name,
     COALESCE(team_city, 'N/A') AS team,
     season,
     SUM(a.pts) points,
     SUM(CASE
            WHEN (a.team_id = b.home_team_id AND home_team_wins = 1) OR
             (a.team_id = b.visitor_team_id AND home_team_wins = 0) THEN 1
             ELSE 0 END
     ) AS total_games_won
    FROM 
        bootcamp.nba_game_details_dedup AS a 
    JOIN
        bootcamp.nba_games AS b 
    ON 
        a.game_id = b.game_id
    GROUP BY
     GROUPING SETS(
       (player_name, team_city),
       (player_name, season),
       (team_city)
     )
)
SELECT
    *
FROM
    combined
