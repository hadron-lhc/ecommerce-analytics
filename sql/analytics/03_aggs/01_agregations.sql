-- Exercise 19: Average user age
-- Concepts: CTE (WITH), EXTRACT, AGE, AVG, ROUND
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

-- Exercise 20: User count by age range
-- Concepts: Multiple CTEs (WITH x2), EXTRACT, AGE, CASE, GROUP BY, ORDER BY
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

-- Exercise 21: Favorite genre by age range
-- Concepts: Multiple CTEs (WITH x4), EXTRACT, AGE, CASE, JOIN, GROUP BY, RANK, PARTITION BY
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

-- Exercise 22: Completion rate by age range
-- Concepts: Multiple CTEs (WITH x3), EXTRACT, AGE, CASE, JOIN, SUM, GROUP BY, ORDER BY
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

-- Exercise 23: Average watch time by user gender
-- Concepts: JOIN, AVG, ROUND, GROUP BY
SELECT
  u.gender AS genero,
  ROUND(AVG(v.watch_time_minutes),2) AS watch_time_promedio
FROM viewing_session v
JOIN users u
  ON v.user_id = u.user_id
GROUP BY u.gender;

-- Exercise 24: Users who watched more than 200 distinct movies
-- Concepts: CTE (WITH), INNER JOIN, COUNT, GROUP BY, WHERE
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
WHERE cantidad_peliculas > 200;

-- Exercise 25: Movies that were never watched
-- Concepts: CTE (WITH), INNER JOIN, COUNT, GROUP BY, WHERE
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

-- Exercise 26: Users who never completed a movie
-- Concepts: CTE (WITH), INNER JOIN, SUM, GROUP BY, WHERE
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
