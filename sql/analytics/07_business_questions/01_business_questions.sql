-- Exercise 43: Which gender has the best completion rate?
-- Concepts: JOIN, AVG, ROUND, GROUP BY, ORDER BY DESC, LIMIT
SELECT
  u.gender,
  ROUND(AVG(vs.completed) * 100, 2) AS completion_rate_global
FROM users u
JOIN viewing_session vs
  ON u.user_id = vs.user_id
GROUP BY u.gender
ORDER BY completion_rate_global DESC
LIMIT 1;

-- Exercise 44: Which gender generates the most watch minutes?
-- Concepts: JOIN, SUM, GROUP BY, ORDER BY DESC, LIMIT
SELECT
  u.gender,
  SUM(vs.watch_time_minutes) AS minutos_vistos
FROM users u
JOIN viewing_session vs
  ON u.user_id = vs.user_id
GROUP BY u.gender
ORDER BY minutos_vistos DESC
LIMIT 1;

-- Exercise 45: Completion rate with subtitles vs without subtitles
-- Concepts: CASE, AVG, ROUND, GROUP BY, ORDER BY DESC, LIMIT
SELECT
  CASE
    WHEN subtitles_enabled = 1 THEN 'Con'
    WHEN subtitles_enabled = 0 THEN 'Sin'
  END AS subtitulos,
  ROUND(AVG(completed)*100, 2) AS completion_rate
FROM viewing_session
GROUP BY subtitles_enabled
ORDER BY completion_rate DESC
LIMIT 1;

-- Exercise 46: Completion rate by video quality
-- Concepts: GROUP BY, AVG, ROUND, ORDER BY
SELECT
  video_quality,
  ROUND(AVG(completed)*100,2) AS completion_rate
FROM viewing_session
GROUP BY video_quality
ORDER BY completion_rate;

-- Exercise 47: Completion rate by age majority
-- Concepts: CTE (WITH), EXTRACT, AGE, CASE, JOIN, AVG, ROUND, GROUP BY, ORDER BY
WITH base_users AS (
  SELECT *,
    EXTRACT(YEAR FROM AGE(birth_date)) AS age
  FROM users
)
SELECT
  CASE
    WHEN u.age >= 18 THEN 'Mayor'
    WHEN u.age < 18 THEN 'Menor'
  END AS edad,
  ROUND(AVG(vs.completed)*100, 2) AS completion_rate
FROM viewing_session vs
JOIN base_users u
  ON vs.user_id = u.user_id
GROUP BY edad
ORDER BY completion_rate;

-- Exercise 48: Language with highest completion rate
-- Concepts: GROUP BY, AVG, ROUND, ORDER BY DESC, LIMIT
SELECT
  language,
  ROUND(AVG(completed)*100,2) AS completion_rate
FROM viewing_session
GROUP BY language
ORDER BY completion_rate DESC
LIMIT 1;
