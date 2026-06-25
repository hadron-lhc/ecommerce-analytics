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

-- Completion rate en usuarios que usan subs vs no subs
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

-- Completion rate por calidad
SELECT
  video_quality,
  ROUND(AVG(completed)*100,2) AS completion_rate
FROM viewing_session
GROUP BY video_quality
ORDER BY completion_rate;

-- Completion rate por mayor o menor de edad
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

-- Idioma con mayor porcentaje de completed
SELECT
  language,
  ROUND(AVG(completed)*100,2) AS completion_rate
FROM viewing_session
GROUP BY language
ORDER BY completion_rate DESC
LIMIT 1;
