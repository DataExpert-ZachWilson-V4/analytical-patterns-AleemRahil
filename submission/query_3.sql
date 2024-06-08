-- Find the player with the most
-- points earned in a single team
WITH
    ranked AS (
        SELECT
            player_name,
            team,
            total_player_points,
            DENSE_RANK() OVER(ORDER BY total_player_points DESC) AS n_r
        FROM
            aleemrahil84520.game_details_dashboard
        WHERE
            team <> 'N/A'
        AND
            player_name IS NOT NULL
)
SELECT
  player_name,
  team,
  points
FROM
  ranked
WHERE
  n_r = 1
 

