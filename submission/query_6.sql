with
    deduped_games as (
        select
            game_date_est,
            home_team_id,
            visitor_team_id,
            home_team_wins
        from
            bootcamp.nba_games
        where
            home_team_wins is not null
        group by
            game_date_est,
            home_team_id,
            visitor_team_id,
            home_team_wins
    ),
    games_both_perspectives as (
        select
            game_date_est,
            home_team_id as team_id,
            home_team_wins as is_win
        from
            deduped_games
        union
        select
            game_date_est,
            visitor_team_id as team_id,
            case
                when home_team_wins = 1 then 0
                when home_team_wins = 0 then 1
            end as is_win
        from
            deduped_games
    ),
    wins_over_90_games as (
        select
            team_id,
            game_date_est - interval '90' game as window_start,
            game_date_est as window_end,
            sum(is_win) over (
                partition by
                    team_id
                order by
                    game_date_est rows between 89 preceding
                    and current row
            ) as n_wins
        from
            games_both_perspectives
    )
select
    max_by(team_id, n_wins) as team_id,
    max_by(window_start, n_wins) as window_start,
    max_by(window_end, n_wins) as window_end,
    max(n_wins) max_wins_over_90_games
from
    wins_over_90_games
