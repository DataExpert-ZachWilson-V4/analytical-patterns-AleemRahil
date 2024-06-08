-- Find the player with the most
-- points earned in a single team
WITH
    ranked AS (
        SELECT
            player_name,
            team,
            points,
            DENSE_RANK() OVER(ORDER BY points DESC) AS n_r
        FROM
            game_details_dashboard
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
 

