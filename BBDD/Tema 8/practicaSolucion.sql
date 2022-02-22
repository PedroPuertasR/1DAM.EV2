-- Ejercicio 1

CREATE OR REPLACE FUNCTION devolverMaxima (fechaUsuario date) 
RETURNS numeric AS
$$
	SELECT temperatura_maxima
	FROM climatologia
	WHERE $1 = fecha
$$ LANGUAGE sql;


-- Ejercicio 2

CREATE OR REPLACE FUNCTION devolverMaxEstacion (fechaUsuario date) 
RETURNS TABLE (temperatura numeric,
			   estacion varchar) AS
$$
	SELECT temperatura_maxima, array_agg(estacion || '; ')
	FROM climatologia
	WHERE fecha = $1
	GROUP BY temperatura_maxima
	ORDER BY temperatura_maxima DESC
	LIMIT 1
$$ LANGUAGE sql;


-- Ejercicio 3

CREATE OR REPLACE FUNCTION temperaturas (fechaInicio date, fechaFin date, nombre varchar)
RETURNS TABLE(temperatura_maxima numeric,
			  temperatura_minima numeric,
			  estacion varchar) AS
$$
	SELECT ROUND(AVG(temperatura_maxima),2), ROUND(AVG(temperatura_minima),2), estacion
	FROM climatologia
	WHERE fecha BETWEEN $1 AND $2
		  AND $3 = estacion
	GROUP BY estacion
$$ LANGUAGE sql;


SELECT devolverMaxima(MAKE_DATE(2019, 11, 12));
SELECT * FROM devolverMaxEstacion (MAKE_DATE(2019, 08, 01));
SELECT * FROM temperaturas(MAKE_DATE(2019,10,11), MAKE_DATE(2019,11,10), 'Boiro');