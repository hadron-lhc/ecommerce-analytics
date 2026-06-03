/*
-- VERIFICAR SI HAY DATOS

SELECT *
FROM movies
LIMIT 5;


-- CONTAR LAS FILAS

SELECT COUNT(*)
FROM movies;


-- VERIFICAR TIPO DEL ID

SELECT pg_typeof(movie_id)
FROM movies
LIMIT 1;


-- VERIFICANDO SCHEMMA

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'movies';

*/
