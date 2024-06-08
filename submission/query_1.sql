-- Following query tracks active status
-- of nba players between 1997 - 2002
-- There are 5 states to track depending
-- on the value is_active and the difference
-- between current season and previous active
-- season; the difference determines the state
-- query that does state change tracking for nba_players
INSERT INTO aleemrahil84520.nba_players_state_tracking
    (player_name, first_active_season, last_active_season, seasons_active, yearly_active_state, season)
-- subquery to select all records from the last season (1999)
WITH
  yesterday AS (
    SELECT
      player_name,
      first_active_season,
      last_active_season,
      seasons_active,
      yearly_active_state,
      season
    FROM
      aleemrahil84520.nba_players_state_tracking
    WHERE
      season = 2001
), today AS (
    SELECT
      player_name,
      MAX(is_active) AS is_active,
      MAX(current_season) AS seasons_active
    FROM
       bootcamp.nba_players
    WHERE
        current_season = 2002
    GROUP BY
      player_name
), combined AS (
    SELECT
        COALESCE(y.player_name, t.player_name) AS player_name,
        COALESCE(y.first_active_season, (CASE WHEN t.is_active THEN t.seasons_active END)) AS first_active_season,
        COALESCE((CASE WHEN t.is_active THEN t.seasons_active END), y.last_active_season) AS last_active_season,
        t.is_active,
        y.last_active_season AS y_last_active_season,
        CASE WHEN
            y.seasons_active IS NULL THEN ARRAY[t.seasons_active]
            WHEN t.seasons_active IS NULL THEN y.seasons_active
            WHEN t.seasons_active IS NOT NULL AND t.is_active THEN ARRAY[t.seasons_active] || y.seasons_active
            ELSE y.seasons_active
        END AS seasons_active,
        COALESCE(y.season+1, t.seasons_active) AS season
    FROM
        yesterday AS y
        FULL OUTER JOIN today AS t ON y.player_name = t.player_name
)
SELECT
    player_name,
    first_active_season,
    last_active_season,
    seasons_active,
    CASE
    WHEN is_active AND first_active_season - last_active_season = 0 THEN 'New'
    WHEN is_active AND season - y_last_active_season = 1 THEN 'Continued Playing'
    WHEN is_active AND season - y_last_active_season > 1 THEN 'Returned from Retirement'
    WHEN NOT is_active
    AND season - y_last_active_season = 1 THEN 'Retired'
    ELSE 'Stayed Retired'
  END AS yearly_active_state,
  season
FROM
    combined
