-- Exercise 4: Longest movie
-- Concepts: ORDER BY DESC, LIMIT
SELECT title, duration_minutes
FROM movies
ORDER BY duration_minutes DESC
LIMIT 1;

-- Exercise 5: Shortest movie
-- Concepts: ORDER BY ASC, LIMIT
SELECT title, duration_minutes
FROM movies
ORDER BY duration_minutes ASC
LIMIT 1;

-- Exercise 6: Movies count by main genre
-- Concepts: GROUP BY, COUNT, ORDER BY DESC
SELECT
  main_genre,
  COUNT(movie_id) as amount_movies
FROM movies
GROUP BY main_genre
ORDER BY amount_movies DESC;

