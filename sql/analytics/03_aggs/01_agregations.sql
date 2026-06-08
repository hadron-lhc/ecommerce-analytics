-- Edad promedio de los usuarios
WITH age_per_user AS (
  SELECT
    user_id,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
  FROM users
  GROUP BY user_id
)
SELECT
  ROUND(AVG(age), 2) AS average_age
FROM age_per_user;

-- Cantidad de usuarios por rango etario
WITH age_per_user AS (
  SELECT
    user_id,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
  FROM users
),
base AS (
  SELECT
    *,
    CASE
      WHEN age BETWEEN 0 AND 17 THEN '0-17'
      WHEN age BETWEEN 18 AND 25 THEN '18-25'
      WHEN age BETWEEN 26 AND 35 THEN '26-35'
      WHEN age BETWEEN 36 AND 50 THEN '36-50'
      WHEN age > 50 THEN '50+'
      ELSE 'Sin especificar'
    END AS age_range
  FROM age_per_user
)
SELECT
  age_range,
  COUNT(*) AS cantidad
FROM base
GROUP BY age_range
ORDER BY age_range;

-- Genero favorito por rango etario
WITH age_per_user AS (
  SELECT
    user_id,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
  FROM users
),
range_age AS (
  SELECT
    *,
    CASE
      WHEN age BETWEEN 0 AND 17 THEN '0-17'
      WHEN age BETWEEN 18 AND 25 THEN '18-25'
      WHEN age BETWEEN 26 AND 35 THEN '26-35'
      WHEN age BETWEEN 36 AND 50 THEN '36-50'
      WHEN age > 50 THEN '50+'
      ELSE 'Sin especificar'
    END AS age_range
  FROM age_per_user
),
genre_views AS (
  SELECT
    ra.age_range,
    m.main_genre,
    COUNT(*) AS total_views
  FROM viewing_session vs
  JOIN range_age ra ON vs.user_id = ra.user_id
  JOIN movies m ON vs.movie_id = m.movie_id
  GROUP BY ra.age_range, m.main_genre
),
ranked AS (
  SELECT
    age_range,
    main_genre,
    total_views,
    RANK() OVER (
      PARTITION BY age_range
      ORDER BY total_views DESC
    ) AS rnk
  FROM genre_views
)
SELECT
  age_range,
  main_genre AS favorite_genre,
  total_views
FROM ranked
WHERE rnk = 1
ORDER BY age_range;

-- Completetion rate por rango etario
WITH age_per_user AS (
  SELECT
    user_id,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
  FROM users
),
range_age AS (
  SELECT
    *,
    CASE
      WHEN age BETWEEN 0 AND 17 THEN '0-17'
      WHEN age BETWEEN 18 AND 25 THEN '18-25'
      WHEN age BETWEEN 26 AND 35 THEN '26-35'
      WHEN age BETWEEN 36 AND 50 THEN '36-50'
      WHEN age > 50 THEN '50+'
      ELSE 'Sin especificar'
    END AS age_range
  FROM age_per_user
),
completetion_rate AS (
  SELECT
    ra.age_range,
    (SUM(vs.completed)*100/COUNT(*)) AS completed_ratio
  FROM viewing_session vs
  JOIN range_age ra ON vs.user_id = ra.user_id
  GROUP BY ra.age_range
)
SELECT
  age_range,
  completed_ratio
FROM completetion_rate
ORDER BY age_range;

-- Watch time promedio por genero de usuario
SELECT
  u.gender AS genero,
  ROUND(AVG(v.watch_time_minutes),2) AS watch_time_promedio
FROM viewing_session v
JOIN users u
  ON v.user_id = u.user_id
GROUP BY u.gender;

-- Usuarios que vieron mas de x películas distintas
WITH movies_per_user AS (
  SELECT
    u.user_id,
    COUNT(v.movie_id) AS cantidad_peliculas
  FROM viewing_session v
  INNER JOIN users u ON v.user_id = u.user_id
  GROUP BY u.user_id
)
SELECT
  COUNT(user_id) as cantidad_users
FROM movies_per_user
WHERE cantidad_peliculas > 200; -- Valor de x = 200

-- Películas que nunca fueron vistas
WITH views_per_movie AS (
  SELECT
    m.title,
    m.movie_id,
    COUNT(*) AS views
  FROM viewing_session v
  INNER JOIN movies m ON v.movie_id = m.movie_id
  GROUP BY m.movie_id
)
SELECT
  title
FROM views_per_movie
WHERE views = 0;

-- Usuarios que nunca completaron una película
WITH completed_per_user AS (
  SELECT
    u.user_id,
    SUM(v.completed) as cantidad_completados
  FROM viewing_session v
  INNER JOIN users u
    ON v.user_id = u.user_id
  GROUP BY u.user_id
)
SELECT user_id
FROM completed_per_user
WHERE cantidad_completados = 0;
