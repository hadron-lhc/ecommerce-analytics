/*
-- VERIFICAR SI HAY DATOS

SELECT *
FROM users
LIMIT 5;
*/


/*
-- CONTAR LAS FILAS

SELECT COUNT(*)
FROM users
*/


/*
-- VERIFICAR TIPO DEL ID

SELECT pg_typeof(user_id)
FROM users
LIMIT 1;
*/


/*
-- VERIFICANDO SCHEMMA

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'users';
*/


/*
-- DISTRIBUCIÓN POR GENERO
SELECT
  gender,
  COUNT(*)
FROM users
GROUP BY gender;
*/


/*
--  USER MAS JOVEN Y MAS VIEJO
SELECT
    MIN(birth_date),
    MAX(birth_date)
FROM users;
*/


/*
-- EDADES

SELECT
    ROUND(AVG(EXTRACT(YEAR FROM AGE(birth_date))), 1)
FROM users;
*/


/*
-- DATOS IMPOSIBLES

SELECT *
FROM users
WHERE birth_date > CURRENT_DATE;

SELECT *
FROM users
WHERE sign_up_date::date < birth_date;
*/
