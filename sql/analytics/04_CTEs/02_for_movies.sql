-- Exercise 30: Movies whose completion rate exceeds the global average
-- Concepts: Multiple CTEs (WITH x2), CROSS JOIN (x2), SUM, COUNT, GROUP BY, WHERE
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
WHERE completion_rate_pelicula > completion_rate_global;

-- Exercise 31: Most viewed movie in each genre
-- Concepts: Multiple CTEs (WITH x2), JOIN, COUNT, GROUP BY, RANK, PARTITION BY, ORDER BY
WITH views_per_movie AS (
  SELECT
    m.main_genre,
    m.movie_id,
    m.title,
    COUNT(*) AS cantidad
  FROM viewing_session vs
  JOIN movies m ON vs.movie_id = m.movie_id
  GROUP BY m.main_genre, m.movie_id, m.title
),
ranked AS (
  SELECT
    main_genre,
    movie_id,
    title,
    cantidad,
    RANK() OVER (PARTITION BY main_genre ORDER BY cantidad DESC) AS rnk
  FROM views_per_movie
)
SELECT
  main_genre,
  title,
  cantidad
FROM ranked
WHERE rnk = 1
ORDER BY main_genre;
