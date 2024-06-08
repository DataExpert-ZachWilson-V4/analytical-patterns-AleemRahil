-- Find the highest streak of games where
-- LeBron James has score over t0 points
WITH points_threshold AS (
    SELECT 
        game_date_est,
        CASE WHEN a.pts > 10 THEN 1 ELSE 0 END AS scored_above_threshold,
        -- Required to create partition key in next query
        ROW_NUMBER() OVER (ORDER BY game_date_est) AS rn
    FROM 
        bootcamp.nba_game_details_dedup AS a
    JOIN
        bootcamp.nba_games AS b
    ON 
        a.game_id = b.game_id
    WHERE
        player_name = 'LeBron James'
),
lagged AS (
    SELECT
        rn,
        -- Calculate difference to identify break between streaks
        rn - LAG(rn) OVER (ORDER BY rn) AS lag_diff
    FROM 
        points_threshold
    WHERE 
        scored_above_threshold = 1
),
streak_groups AS (
    SELECT
        rn,
        -- Total the streaks to find the largest unbroken streak count
        SUM(CASE WHEN lag_diff > 1 THEN 1 ELSE 0 END) OVER (ORDER BY rn) AS streak_group
    FROM 
        lagged
)
SELECT
    --streak_group,
    COUNT(*) AS streak_length
FROM 
    streak_groups
GROUP BY 
    streak_group
ORDER BY 
    streak_length DESC
LIMIT 1



