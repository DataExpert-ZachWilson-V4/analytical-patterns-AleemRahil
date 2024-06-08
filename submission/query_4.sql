-- Find the player with the most
-- points earned in any season
WITH
    ranked AS (
        SELECT
            player_name,
            season,
            total_player_points,
            DENSE_RANK() OVER(ORDER BY total_player_points DESC) AS rank
        FROM
            aleemrahil84520.game_details_dashboard
        WHERE
            player_name IS NOT NULL
        AND
            season IS NOT NULL
        AND
            total_player_points IS NOT NULL
)
SELECT
  player_name,
  season,
  total_player_points
FROM
  ranked
WHERE
  rank = 1
