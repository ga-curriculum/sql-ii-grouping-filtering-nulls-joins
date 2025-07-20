-- SQL II Filtering, NULLs, and Joins
-- Queries - Solutions to exercises from the intro-to-sql-II-grouping.md file.


-- Part 1: Grouping Data with `GROUP BY`

-- Exercise 1.1
-- 1. Calculate the total number of games for each season in the `mbb_games_sr` table

SELECT
    season,
    COUNT(*) AS total_games
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
GROUP BY season;


-- 2. Calculate the following statistics for each season in the `mbb_games_sr` table:
--   - Total number of games
--   - Average attendance
--   - Sum of all points scored by home teams

SELECT
    season,
    COUNT(*) AS total_games,
    AVG(attendance) AS avg_attendance,
    SUM(h_points) AS total_home_points,
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
GROUP BY season;


-- 3. Create a query that shows the following statistics for each conference:
-- - Number of teams
-- - Average venue capacity
-- - Total venue capacity
-- - Number of unique venues (some teams might share venues)
-- - Order the results by the number of teams in descending order.

SELECT
    conf_name AS conference,
    COUNT(name) AS num_teams,
    AVG(venue_capacity) AS avg_venue_capacity,
    SUM(venue_capacity) AS total_venue_capacity,
    COUNT(DISTINCT venue_name) AS unique_venues
FROM bigquery-public-data.ncaa_basketball.mbb_teams
GROUP BY conference
ORDER BY num_teams DESC;


-- Part 2: Filtering Data with `WHERE`

-- Exercise 2.1
-- Find all the teams with venue capacity under 5,000 from the `mbb_teams` table.

SELECT 
    name AS team_name, --remember: you can use AS to rename the column
    venue_capacity
FROM bigquery-public-data.ncaa_basketball.mbb_teams
WHERE venue_capacity < 5000;


-- Stretch Challenge 2.2
-- 1. Find all games where the home team scored more than 100 points and won the game from the `mbb_games_sr` table.

SELECT 
    scheduled_date,
    h_name AS home_team,
    h_points AS home_points,
    a_points AS away_points
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
WHERE h_points > 100
    AND h_points > a_points;

-- 2. Find players who scored more than 200 points in a season. To be able to do this you will have to write a query using a command you haven't learned yet. Hint: you can't use `WHERE` when you are using `GROUP BY`.
SELECT 
    full_name,
    SUM(points) AS total_points
FROM bigquery-public-data.ncaa_basketball.mbb_players_games_sr
GROUP BY full_name
HAVING SUM(points) > 200
ORDER BY total_points;


-- Part 3: Handling NULL Values

-- Exercise 3.1
-- Find all games where attendance data is not missing (IS NOT NULL). **_Stretch: write the query in a different way (using boolean logic)._**

SELECT 
    scheduled_date,
    h_name AS home_team,
    attendance
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
WHERE attendance IS NULL;


-- Part 4: Joining Tables

-- Exercise 4.1
-- Get the colors for each team

SELECT 
    t.name AS team_name,
    c.color AS primary_color
FROM bigquery-public-data.ncaa_basketball.mbb_teams t
JOIN bigquery-public-data.ncaa_basketball.team_colors c
    ON t.id = c.id;


-- Advanced Joins

-- Exercise 4.2
-- The marketing team wants to know when each mascot has made an appearance in a game. Could you help them by providing a list of all teams, their mascots, and date of their games? 
-- _Hint: some teams don't have a mascot name, so you will have to filter them out._

SELECT 
    t.name AS team_name,
    m.mascot_name,
    g.scheduled_date AS game_date
FROM bigquery-public-data.ncaa_basketball.mbb_teams t
LEFT JOIN bigquery-public-data.ncaa_basketball.mascots m
    ON t.id = m.id
LEFT JOIN bigquery-public-data.ncaa_basketball.mbb_games_sr g
    ON t.id = g.h_id
WHERE m.mascot_name IS NOT NULL;


-- Stretch Challenge 4.2

-- Write a query that:
-- 1. Gets each team's name and mascot
-- 2. Finds their most recent game date (whether they were home or away team)
-- 3. Orders results from newest to oldest games
-- 4. Excludes any teams that don't have a mascot name in the mascots table


SELECT 
    t.name AS team_name,
    m.mascot_name,
    MAX(g.scheduled_date) AS last_game_date
FROM bigquery-public-data.ncaa_basketball.mbb_teams t
INNER JOIN bigquery-public-data.ncaa_basketball.mascots m
    ON t.id = m.id
LEFT JOIN bigquery-public-data.ncaa_basketball.mbb_games_sr g
    ON t.id = g.h_id OR t.id = g.a_id  -- Match both home and away games
WHERE m.mascot_name IS NOT NULL
GROUP BY t.name, m.mascot_name
ORDER BY last_game_date DESC;



-- Part 5: Combining Results with UNION
-- no exercises


-- Part 6: Common SQL Functions

-- Exercise 6.1
-- What is the maximum attendance for each season?

SELECT 
    season,
    MAX(attendance) AS max_attendance
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
GROUP BY season
ORDER BY season DESC;


-- Stretch challenge 6.2
-- Calculate the average point difference between home and away teams for each season.

SELECT 
    season,
    AVG(ABS(h_points - a_points)) AS avg_point_difference
FROM bigquery-public-data.ncaa_basketball.mbb_games_sr
GROUP BY season
ORDER BY season DESC;


-- Part 7: Wildcards

-- Exercise 7.1
-- Find all the mascot names that start with the letter `P`.

SELECT mascot_name
FROM bigquery-public-data.ncaa_basketball.mascots
WHERE mascot_name LIKE 'P%';


-- Stretch exercise 7.2
-- Find the first and last names of all players with a last name that contains the word "Smith".

SELECT 
    first_name,
    last_name
FROM bigquery-public-data.ncaa_basketball.mbb_players_games_sr
WHERE last_name LIKE '%Smith%';
