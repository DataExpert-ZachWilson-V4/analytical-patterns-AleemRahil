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
    last_year AS (
        SELECT
            *
        FROM
            aleemrahil84520.nba_players_state_tracking
        WHERE
            season = 1999
    ),
    -- subquery to select the maximum active season and active status for each player for the current season (2000)
    this_year AS (
        SELECT
            player_name,
            MAX(current_season) as active_season,
            MAX(is_active) as is_active
        FROM
            bootcamp.nba_players
        WHERE
            current_season = 2000
        GROUP BY
            player_name
    ),
    -- combining data from the last year and this year
    combined AS (
        SELECT
            COALESCE(ly.player_name, ty.player_name) as player_name,
            COALESCE(
                ly.first_active_season,
                (
                    CASE
                        WHEN ty.is_active THEN ty.active_season
                    END
                )
            ) as first_active_season, -- determine first active season
            ly.last_active_season as last_active_year, -- last active season from last year's data
            ty.is_active, -- current active status
            COALESCE(
                (
                    CASE
                        WHEN ty.is_active THEN ty.active_season
                    END
                ),
                ly.last_active_season
            ) as last_active_season, -- determine last active season
            CASE
                WHEN ly.seasons_active is NULL THEN ARRAY[ty.active_season]
                WHEN ty.active_season is NULL THEN ly.seasons_active
                ELSE ly.seasons_active || ARRAY[ty.active_season]
            END as seasons_active,
            COALESCE(ly.season + 1, ty.active_season) AS season
        FROM
            last_year ly
            FULL OUTER JOIN this_year ty ON ly.player_name = ty.player_name
    )
SELECT
    player_name,
    first_active_season,
    last_active_season,
    seasons_active,
    CASE
        WHEN first_active_season - last_active_season = 0
        AND is_active THEN 'New'
        WHEN season - last_active_year = 1
        AND NOT is_active THEN 'Retired'
        WHEN season - last_active_year = 1
        AND is_active THEN 'Continued Playing'
        WHEN season - last_active_year > 1
        AND is_active THEN 'Returned from Retirement'
        ELSE 'Stayed Retired'
    END AS yearly_active_state,
    season
FROM
    combined
