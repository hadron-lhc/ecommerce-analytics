-- Exercise 13: Top 10 most viewed movies
-- Concepts: LEFT JOIN, GROUP BY, COUNT, ORDER BY DESC, LIMIT
SELECT
  m.title,
  COUNT(v.movie_id) as cantidad
FROM movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY m.movie_id
ORDER BY cantidad DESC
LIMIT 10;

-- Exercise 14: Most viewed genre
-- Concepts: LEFT JOIN, GROUP BY, COUNT, ORDER BY DESC, LIMIT
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

