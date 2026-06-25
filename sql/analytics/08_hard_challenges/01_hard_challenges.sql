-- Exercise 49: Find each user's favorite genre
-- Concepts: Multiple CTEs (WITH x2), JOIN, COUNT, GROUP BY, ROW_NUMBER, PARTITION BY
WITH amount_per_genre AS (
  SELECT
    vs.user_id,
    m.main_genre,
    COUNT(*) AS cantidad
  FROM viewing_session vs
  JOIN movies m
    ON vs.movie_id = m.movie_id
  GROUP BY user_id, main_genre
),
making_ranking AS (
  SELECT
    user_id,
    main_genre,
    cantidad,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY cantidad DESC
    ) AS ranking
  FROM amount_per_genre
)
SELECT
  user_id,
  main_genre AS genero_favorito,
  cantidad AS veces_visto
FROM making_ranking
WHERE ranking = 1;

-- Exercise 50: Users who changed their favorite genre over time
-- Concepts: Multiple CTEs (WITH x4), JOIN, NTILE, PARTITION BY, COUNT, GROUP BY, ROW_NUMBER, CASE, MAX
WITH sesiones_ordenadas AS (
  SELECT
    vs.user_id,
    m.main_genre,
    NTILE(2) OVER (
      PARTITION BY vs.user_id
      ORDER BY vs.started_at ASC
    ) AS periodo
  FROM viewing_session vs
  JOIN movies m
    ON vs.movie_id = m.movie_id
),
conteo_por_periodo AS (
  SELECT
    user_id,
    main_genre,
    periodo,
    COUNT(*) AS cantidad
  FROM sesiones_ordenadas
  GROUP BY user_id, main_genre, periodo
),
ranking_por_periodo AS (
  SELECT
    user_id,
    main_genre,
    periodo,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, periodo
      ORDER BY cantidad DESC
    ) AS ranking
  FROM conteo_por_periodo
),
favoritos_etiquetados AS (
  SELECT
    user_id,
    MAX(CASE WHEN periodo = 1 THEN main_genre END) AS genero_inicial,
    MAX(CASE WHEN periodo = 2 THEN main_genre END) AS genero_actual
  FROM ranking_por_periodo
  WHERE ranking = 1
  GROUP BY user_id
)
SELECT
  user_id,
  genero_inicial,
  genero_actual
FROM favoritos_etiquetados
WHERE genero_inicial <> genero_actual;

-- Exercise 51: Organize users into cohorts by sign-up date
-- Concepts: CTE (WITH), CASE, GROUP BY, ORDER BY DESC
WITH usuarios_con_rango AS (
  SELECT
    user_id,
    sign_up_date,
    CASE
      WHEN sign_up_date < '2024-01-01' THEN 'Usuarios Antiguos (Pre-2024)'
      WHEN sign_up_date BETWEEN '2024-01-01' AND '2024-12-31' THEN 'Cohorte 2024'
      WHEN sign_up_date BETWEEN '2025-01-01' AND '2025-12-31' THEN 'Cohorte 2025'
      ELSE 'Nuevos Registros (2026+)'
    END AS cohorte_personalizada
  FROM users
)
SELECT
  cohorte_personalizada,
  COUNT(*) AS cantidad_usuarios
FROM usuarios_con_rango
GROUP BY cohorte_personalizada
ORDER BY cantidad_usuarios DESC;

-- Exercise 52: Month-over-month active users
-- Concepts: DATE_TRUNC, COUNT(DISTINCT), GROUP BY, ORDER BY ASC
SELECT
  DATE_TRUNC('month', started_at)::DATE AS mes,
  COUNT(DISTINCT user_id) AS total_usuarios
FROM viewing_session
GROUP BY DATE_TRUNC('month', started_at)::DATE
ORDER BY mes ASC;

-- Exercise 53: Monthly user retention by cohort
-- Concepts: Multiple CTEs (WITH x2), DATE_TRUNC, EXTRACT, AGE, JOIN, COUNT(DISTINCT), ROUND, GROUP BY, ORDER BY
WITH cohort_sizes AS (
  SELECT
    DATE_TRUNC('month', sign_up_date)::DATE AS cohorte,
    COUNT(DISTINCT user_id) AS usuarios_iniciales
  FROM users
  GROUP BY 1
),
user_activity AS (
  SELECT
    vs.user_id,
    DATE_TRUNC('month', u.sign_up_date)::DATE AS cohorte,
    1 + EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', vs.started_at), DATE_TRUNC('month', u.sign_up_date))) AS mes_periodo
  FROM viewing_session vs
  JOIN users u ON vs.user_id = u.user_id
  GROUP BY vs.user_id, u.sign_up_date, vs.started_at
)
SELECT
  c.cohorte,
  c.usuarios_iniciales,
  a.mes_periodo AS meses_despues,
  COUNT(DISTINCT a.user_id) AS usuarios_activos,
  ROUND(
    (COUNT(DISTINCT a.user_id)::NUMERIC / c.usuarios_iniciales) * 100,
    2
  ) AS porcentaje_retencion
FROM cohort_sizes c
JOIN user_activity a ON c.cohorte = a.cohorte
GROUP BY c.cohorte, c.usuarios_iniciales, a.mes_periodo
ORDER BY c.cohorte ASC, a.mes_periodo ASC;
