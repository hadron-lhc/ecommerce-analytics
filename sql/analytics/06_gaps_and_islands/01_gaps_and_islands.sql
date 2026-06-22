-- Encontrar días consecutivos de actividad por usuario
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

-- Calcular la racha máxima de cada usuario


