-- Exercise 11: Top 10 users with most sessions
-- Concepts: LEFT JOIN, GROUP BY, COUNT, ORDER BY DESC, LIMIT
SELECT
  u.user_id,
  COUNT(u.user_id) AS cantidad
FROM users u
LEFT JOIN viewing_session v
  ON u.user_id = v.user_id
GROUP BY u.user_id
ORDER BY cantidad DESC
LIMIT 10;

-- Exercise 12: Top 10 users by total watch time
-- Concepts: LEFT JOIN, SUM, GROUP BY, ORDER BY DESC, LIMIT
SELECT
  u.user_id,
  SUM(v.watch_time_minutes) as watch_time_total
FROM users u
LEFT JOIN viewing_session v
  ON u.user_id = v.user_id
GROUP BY u.user_id
ORDER BY watch_time_total DESC
LIMIT 10;
