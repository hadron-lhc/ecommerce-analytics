-- Exercise 39: Consecutive active days per user (Gaps and Islands)
-- Concepts: DISTINCT, ROW_NUMBER, PARTITION BY, date subtraction with INTERVAL, GROUP BY, MIN, MAX
WITH fechas_unicas AS (
  SELECT DISTINCT
    user_id,
    started_at::date AS fecha_antividad
  FROM viewing_session
),
crear_islas AS (
  SELECT
    user_id,
    fecha_antividad,
    (fecha_antividad - ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY fecha_antividad
    ) * INTERVAL '1 day')::date AS fecha_base_isla
  FROM fechas_unicas
)
SELECT
  user_id,
  MIN(fecha_antividad) AS desde_fecha,
  MAX(fecha_antividad) AS hasta_fehca,
  COUNT(*) AS total_dias_consecutivos
FROM crear_islas
GROUP BY user_id, fecha_base_isla
ORDER BY user_id, desde_fecha;

-- Exercise 40: Maximum streak per user
-- Concepts: Multiple CTEs (WITH x3), DISTINCT, ROW_NUMBER, PARTITION BY, INTERVAL, GROUP BY, MAX
WITH fechas_unicas AS (
  SELECT DISTINCT
    user_id,
    started_at::date AS fecha_antividad
  FROM viewing_session
),
crear_islas AS (
  SELECT
    user_id,
    fecha_antividad,
    (fecha_antividad - ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY fecha_antividad
    ) * INTERVAL '1 day')::date AS fecha_base_isla
  FROM fechas_unicas
),
encontrar_maximo AS (
  SELECT
    user_id,
    COUNT(*) AS longitud_racha
  FROM crear_islas
  GROUP BY user_id, fecha_base_isla
)
SELECT
  user_id,
  MAX(longitud_racha) AS maxima_racha
FROM encontrar_maximo
GROUP BY user_id
ORDER BY maxima_racha DESC;

-- Exercise 41: Users with streaks of exactly 7 days
-- Concepts: Multiple CTEs (WITH x3), DISTINCT, ROW_NUMBER, PARTITION BY, INTERVAL, GROUP BY, WHERE
WITH fechas_unicas AS (
  SELECT DISTINCT
    user_id,
    started_at::date AS fecha_antividad
  FROM viewing_session
),
crear_islas AS (
  SELECT
    user_id,
    fecha_antividad,
    (fecha_antividad - ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY fecha_antividad
    ) * INTERVAL '1 day')::date AS fecha_base_isla
  FROM fechas_unicas
),
encontrar_longitud AS (
  SELECT
    user_id,
    COUNT(*) AS longitud_racha
  FROM crear_islas
  GROUP BY user_id, fecha_base_isla
)
SELECT
  user_id
FROM encontrar_longitud
WHERE longitud_racha = 7
GROUP BY user_id;

-- Exercise 42: Top 10 users by historical streak
-- Concepts: Multiple CTEs (WITH x3), DISTINCT, ROW_NUMBER, PARTITION BY, INTERVAL, GROUP BY, MAX, ORDER BY DESC, LIMIT
WITH fechas_unicas AS (
  SELECT DISTINCT
    user_id,
    started_at::date AS fecha_antividad
  FROM viewing_session
),
crear_islas AS (
  SELECT
    user_id,
    fecha_antividad,
    (fecha_antividad - ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY fecha_antividad
    ) * INTERVAL '1 day')::date AS fecha_base_isla
  FROM fechas_unicas
),
encontrar_longitud AS (
  SELECT
    user_id,
    COUNT(*) AS longitud_racha
  FROM crear_islas
  GROUP BY user_id, fecha_base_isla
)
SELECT
  user_id,
  MAX(longitud_racha) AS racha_maxima
FROM encontrar_longitud
GROUP BY user_id
ORDER BY racha_maxima DESC
LIMIT 10;


