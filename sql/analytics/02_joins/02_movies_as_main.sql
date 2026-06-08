-- Cuantas veces fue vista cada película (top 10 películas mas vistas)
SELECT
  m.title,
  COUNT(v.movie_id) as cantidad
FROM movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY m.movie_id
ORDER BY cantidad DESC
LIMIT 10;

--  Genero mas visto
SELECT
  m.main_genre,
  COUNT(v.viewing_session_id) AS vistas
FROM
  movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY m.main_genre
ORDER BY vistas DESC
LIMIT 1;

