-- 1. VERIFICAR CUÁNTOS REGISTROS HAY
SELECT COUNT(*) AS total_sesiones
FROM viewing_session;


-- 2. VISTA PREVIA DE 5 REGISTROS (columnas específicas)
SELECT
    viewing_session_id,
    user_id,
    movie_id,
    started_at,
    watch_time_minutes,
    completed,
    video_quality,
    playback_speed
FROM viewing_session
LIMIT 5;


-- 3. VERIFICAR TIPOS DE DATOS
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'viewing_session';


-- 4. VERIFICAR QUE LAS FK TENGAN CORRESPONDENCIA
SELECT COUNT(*) AS sesiones_sin_usuario
FROM viewing_session vs
LEFT JOIN users u ON vs.user_id = u.user_id
WHERE u.user_id IS NULL;

SELECT COUNT(*) AS sesiones_sin_pelicula
FROM viewing_session vs
LEFT JOIN movies m ON vs.movie_id = m.movie_id
WHERE m.movie_id IS NULL;
