-- Qué género tiene mejor completion rate
SELECT
  u.gender,
  ROUND(AVG(vs.completed) * 100, 2) AS completion_rate_global
FROM users u
JOIN viewing_session vs
  ON u.user_id = vs.user_id
GROUP BY u.gender
ORDER BY completion_rate_global DESC
LIMIT 1;


-- Qué genero genera mas minutos vistos
SELECT
  u.gender,
  SUM(vs.watch_time_minutes) AS minutos_vistos
FROM users u
JOIN viewing_session vs
  ON u.user_id = vs.user_id
GROUP BY u.gender
ORDER BY minutos_vistos DESC
LIMIT 1;
