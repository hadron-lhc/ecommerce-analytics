-- Raking de usuarios por watch_time
SELECT
  user_id,
  watch_time_minutes,
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY watch_time_minutes DESC
  ) AS rn
FROM viewing_session
LIMIT 10;

-- Ranking películas por cantidad de visualizaciones
WITH base AS (
  SELECT
    movie_id,
    COUNT(*) AS cantidad_visualizaciones
  FROM viewing_session
  GROUP BY movie_id
)
SELECT
  movie_id,
  cantidad_visualizaciones,
  RANK() OVER (
    ORDER BY cantidad_visualizaciones DESC
  ) AS rn
FROM base
LIMIT 10;

-- Top películas por genero (ROW_NUMBER)
WITH base AS (
  SELECT
    m.movie_id,
    m.main_genre,
    COUNT(*) AS cantidad_visualizaciones
  FROM viewing_session v
  JOIN movies m ON v.movie_id = m.movie_id
  GROUP BY m.movie_id
),
top AS (
  SELECT
    main_genre,
    movie_id,
    cantidad_visualizaciones,
    ROW_NUMBER() OVER (
      PARTITION BY main_genre
      ORDER BY cantidad_visualizaciones DESC
    ) AS rn
  FROM base
)
SELECT
  main_genre,
  movie_id,
  cantidad_visualizaciones,
  rn
FROM top
WHERE rn <= 5;

-- Segunda película mas vista por genero (RANK)
WITH base AS (
  SELECT
    m.movie_id,
    m.main_genre,
    COUNT(*) AS cantidad_visualizaciones
  FROM viewing_session v
  JOIN movies m ON v.movie_id = m.movie_id
  GROUP BY m.movie_id
),
top AS (
  SELECT
    main_genre,
    movie_id,
    cantidad_visualizaciones,
    RANK() OVER (
      PARTITION BY main_genre
      ORDER BY cantidad_visualizaciones DESC
    ) AS rnk
  FROM base
)
SELECT
  main_genre,
  movie_id,
  cantidad_visualizaciones,
  rnk
FROM top
WHERE rnk = 2;


