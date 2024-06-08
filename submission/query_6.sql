with
    -- nba_games has duplicates that need to be dealt with
    deduped_games as (
        select
            game_date_est,
            home_team_id,
            visitor_team_id,
            home_team_wins
        from
            bootcamp.nba_games
        group by
            game_date_est,
            home_team_id,
            visitor_team_id,
            home_team_wins
    ),
    -- include games from both home team and away team's perspective 
    games_both_perspectives as (
        -- home team games
        select
            game_date_est,
            home_team_id as team_id,
            home_team_wins as is_win
        from
            deduped_games
        union
        -- away team games
        select
            game_date_est,
            visitor_team_id as team_id,
            -- if was a win or not from away team's perspective
            case
                when home_team_wins = 1 then 0
                when home_team_wins = 0 then 1
            end as is_win
        from
            deduped_games
    ),
    wins_over_90_days as (
        select
            team_id,
            game_date_est - interval '90' day as window_start,
            game_date_est as window_end,
            sum(is_win) over (
                partition by
                    team_id
                order by
                    game_date_est ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
            ) as n_wins
        from
            games_both_perspectives
    ), 
    teams as (
        select 
            distinct(team_id) as team_id,
            distinct(team_abbreviation) as nickname
        from bootcamp.nba_game_details
    )
    
select
    t.nickname as team_name,
    max_by(w.window_start, w.n_wins) as window_start,
    max_by(w.window_end, w.n_wins) as window_end,
    max(w.n_wins) max_wins_over_90_days
from
    wins_over_90_days w
join
    teams t on w.team_id = t.team_id
