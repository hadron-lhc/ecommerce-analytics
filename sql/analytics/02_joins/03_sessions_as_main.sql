-- Watch time promedio por genero
SELECT
  m.main_genre,
  ROUND(AVG(v.watch_time_minutes), 2) AS watch_time_promedio
FROM
  movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY m.main_genre
ORDER BY watch_time_promedio DESC;

-- Competition rate por genero
WITH base AS (
  SELECT
    SUM(v.completed) AS total_sum,
    COUNT(v.viewing_session_id) AS total_count,
    m.main_genre AS main_genre
  FROM
    movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY m.main_genre
)
SELECT
  main_genre,
  (total_sum * 100 / total_count) AS completition_rate
FROM base
ORDER BY completition_rate DESC;

-- Idioma favorito para el anime
WITH base AS (
  SELECT
    m.main_genre AS genre,
    v.language,
    COUNT(*) AS amount_language
  FROM
    movies m
  INNER JOIN viewing_session v
    ON m.movie_id = v.movie_id
  WHERE m.main_genre = 'Anime'
  GROUP BY m.main_genre, v.language
),
second_base AS (
  SELECT
    genre,
    language,
    ROW_NUMBER() OVER (
      PARTITION BY genre
      ORDER BY amount_language DESC
    ) AS rn
  FROM base
)
SELECT
  genre,
  language
FROM second_base
WHERE rn = 1;

-- Horas consumidas por genero
SELECT
  m.main_genre,
  SUM(v.watch_time_minutes)/60 AS horas_consumidas
FROM
  movies m
LEFT JOIN viewing_session v
  ON m.movie_id = v.movie_id
GROUP BY main_genre
ORDER BY horas_consumidas DESC;
