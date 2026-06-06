-- Película mas larga
SELECT title, duration_minutes
FROM movies
ORDER BY duration_minutes DESC
LIMIT 1;

-- Película mas corta
SELECT title, duration_minutes
FROM movies
ORDER BY duration_minutes ASC
LIMIT 1;

SELECT
  main_genre,
  COUNT(movie_id) as amount_movies
FROM movies
GROUP BY main_genre
ORDER BY amount_movies DESC;

