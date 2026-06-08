-- Watch time promedio
SELECT AVG(watch_time_minutes) as watchtime_promedio
FROM viewing_session;

-- Porcentaje de sesiones completadas
SELECT
  ROUND(AVG(completed) * 100, 2) AS porcentaje
FROM viewing_session;

-- Sesiones por idioma
SELECT
  language,
  COUNT(movie_id) as cantidad
FROM viewing_session
GROUP BY language
ORDER BY cantidad DESC;


-- Sesiones por calidad
SELECT
  video_quality,
  COUNT(movie_id) as cantidad
FROM viewing_session
GROUP BY video_quality
ORDER BY cantidad DESC;
