-- Encontrar películas cuyo completion rate supera el promedio
WITH base AS (
  SELECT
    (SUM(completed)*100/COUNT(*)) AS completion_rate_global
  FROM viewing_session
),
base_local AS (
  SELECT
    (SUM(completed)*100/COUNT(*)) AS completion_rate_pelicula
  FROM viewing_session
  GROUP BY movie_id
)
SELECT
  m.movie_id,
  bl.completion_rate_pelicula,
  b.completion_rate_global
FROM movies m
CROSS JOIN base b
CROSS JOIN base_local bl
WHERE completion_rate_pelicula > completion_rate_global
