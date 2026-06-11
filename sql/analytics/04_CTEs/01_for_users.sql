-- Encontrar los usuarios cuyo watch time sea mayor al promedio
WITH base AS (
  SELECT
    AVG(watch_time_minutes) AS promedio
  FROM viewing_session
)
SELECT
  v.user_id,
  v.watch_time_minutes,
  b.promedio AS promedio_global

FROM viewing_session v
CROSS JOIN base b
WHERE v.watch_time_minutes > b.promedio
LIMIT 5;

-- Encontrar usuarios que consuman mas anime que el promedio de usuarios
WITH anime_per_user AS (
  SELECT
    v.user_id,
    SUM(v.watch_time_minutes) AS total_anime_minutes
  FROM viewing_session v
  JOIN movies m
    ON v.movie_id = m.movie_id
  WHERE m.main_genre = 'Anime'
  GROUP BY v.user_id
)
SELECT
  user_id,
  total_anime_minutes
FROM anime_per_user
WHERE total_anime_minutes > (
  SELECT AVG(total_anime_minutes)
  FROM anime_per_user
)
ORDER BY total_anime_minutes DESC
LIMIT 5;

-- Top usuario dentro de cada genero
WITH minutes_per_user_genre AS (
  SELECT
    vs.user_id,
    m.main_genre,
    SUM(vs.watch_time_minutes) AS total_minutes
  FROM viewing_session vs
  JOIN movies m ON vs.movie_id = m.movie_id
  GROUP BY vs.user_id, m.main_genre
),
ranked AS (
  SELECT
    user_id,
    main_genre,
    total_minutes,
    RANK() OVER (PARTITION BY main_genre ORDER BY total_minutes DESC) AS rnk
  FROM minutes_per_user_genre
)
SELECT
  main_genre,
  user_id,
  total_minutes
FROM ranked
WHERE rnk = 1
ORDER BY main_genre;
