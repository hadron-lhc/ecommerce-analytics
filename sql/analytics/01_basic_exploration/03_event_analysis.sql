-- Exercise 7: Average watch time
-- Concepts: AVG
SELECT AVG(watch_time_minutes) as watchtime_promedio
FROM viewing_session;

-- Exercise 8: Percentage of completed sessions
-- Concepts: AVG, ROUND, arithmetic operator (* 100)
SELECT
  ROUND(AVG(completed) * 100, 2) AS porcentaje
FROM viewing_session;

-- Exercise 9: Sessions by language
-- Concepts: GROUP BY, COUNT, ORDER BY DESC
SELECT
  language,
  COUNT(movie_id) as cantidad
FROM viewing_session
GROUP BY language
ORDER BY cantidad DESC;

-- Exercise 10: Sessions by video quality
-- Concepts: GROUP BY, COUNT, ORDER BY DESC
SELECT
  video_quality,
  COUNT(movie_id) as cantidad
FROM viewing_session
GROUP BY video_quality
ORDER BY cantidad DESC;
