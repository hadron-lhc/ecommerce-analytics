-- Sesiones por usuario (top con mas sesiones)
SELECT
  u.user_id,
  COUNT(u.user_id) AS cantidad
FROM users u
LEFT JOIN viewing_session v
  ON u.user_id = v.user_id
GROUP BY u.user_id
ORDER BY cantidad DESC
LIMIT 10; -- Para no saturar el output


-- Top usuario por watch time total
SELECT
  u.user_id,
  SUM(v.watch_time_minutes) as watch_time_total
FROM users u
LEFT JOIN viewing_session v
  ON u.user_id = v.user_id
GROUP BY u.user_id
ORDER BY watch_time_total DESC
LIMIT 10;
