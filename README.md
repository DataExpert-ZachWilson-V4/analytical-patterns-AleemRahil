[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Cj56l3RT)
# Applying Analytical Patterns

## Submission Guidelines

To ensure smooth processing of your submissions through GitHub Classroom automation, we cannot accommodate individual requests for changes. Therefore, please read all instructions carefully.

1. **Sync fork:** Ensure your fork is up-to-date with the upstream repository. You can do this through the GitHub UI or by running the following commands in your local forked repository:
    ```bash
    git pull upstream main --rebase
    git push origin <main/your_homework_repo> -f
    ```
2. **Open a PR in the upstream repository to submit your work:**
    - Open a Pull Request (PR) to merge changes from your `main` or custom `homework` branch in your forked repository into the main branch in the upstream repository, i.e., the repository your fork was created from.
    - Ensure your PR is opened correctly to trigger the GitHub workflow. Submitting to the wrong branch or repository will cause the GitHub action to fail.
    - See the [Steps to open a PR](#steps-to-open-a-pr) section below if you need help with this.
3. **Complete assignment prompts:** Write your SQL in the query file corresponding to the prompt number in the **`submission`** folder. Do not change or rename these files!
4. **Lint your SQL code for readability.** Ensure your code is clean and easy to follow.
5. **Add comments to your queries.** Use the **`--`** syntax to explain each step and help the reviewer understand your thought process. 

A link to your PR will be shared with our TA team after the homework deadline.

### Steps to open a PR
  1. Go to the upstream [**`analytical-patterns`**](https://github.com/DataExpert-ZachWilson-V4/analytical-patterns) repository
  2. Click the [**Pull Requests**](https://github.com/DataExpert-ZachWilson-V4/analytical-patterns/pulls) tab.
  3. Click the **"New pull request"** button on the top-right. This will take you to the [**"Compare changes"**](https://github.com/DataExpert-ZachWilson-V4/analytical-patterns/compare) page.
  4. Click the **"compare across forks"** link in the text.
  5. Leave the base repository as is. For the **"head repository"**, select your forked repository and then the name of the branch you want to compare from your forked repo.
  6. Click the **"Create pull request"** button to open the PR

### Grading
  - Grades are pass or fail, used solely for certification.
  - Final grades will be submitted by a TA **after the deadline**.
  - An approved PR means a Pass grade. If changes are requested, the grade will be marked as Fail.
  - Reviewers may provide comments or suggestions with requested changes. These are optional and intended for your benefit. Any changes you make in response will not be re-reviewed.

Assignment
==================

Your task is to write a total of 4 queries using the `nba_players`,`nba_players_scd`, and `nba_player_seasons` tables from prior weeks.

## Assignment Tasks

- Write a query (`query_1`) that does state change tracking for `nba_players`. Create a state change-tracking field that takes on the following values:
  - A player entering the league should be `New`
  - A player leaving the league should be `Retired`
  - A player staying in the league should be `Continued Playing`
  - A player that comes out of retirement should be `Returned from Retirement`
  - A player that stays out of the league should be `Stayed Retired`
  
- Write a query (`query_2`) that uses `GROUPING SETS` to perform aggregations of the `nba_game_details` data. Create slices that aggregate along the following combinations of dimensions:
  - player and team
  - player and season
  - team

- Build additional queries on top of the results of the `GROUPING SETS` aggregations above to answer the following questions:
  - Write a query (`query_3`) to answer: "Which player scored the most points playing for a single team?"
  - Write a query (`query_4`) to answer: "Which player scored the most points in one season?"
  - Write a query (`query_5`) to answer: "Which team has won the most games"

- Write a query (`query_6`) that uses window functions on `nba_game_details` to answer the question: "What is the most games a single team has won in a given 90-game stretch?"

- Write a query (`query_7`) that uses window functions on `nba_game_details` to answer the question: "How many games in a row did LeBron James score over 10 points a game?"
