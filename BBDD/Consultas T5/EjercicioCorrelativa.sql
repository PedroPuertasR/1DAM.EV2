-- Seleccionar el vuelo mas breve (con menos duracion) de cada aeropuerto de salida.
-- Debe aparece el nombre del aeropuerto de salida, el de llegada, la fecha y hora
-- de salida y llegada y la duracion.

-- MAL

SELECT nombre, MIN(age(llegada, salida))
FROM aeropuerto JOIN vuelo ON (desde = id_aeropuerto)
GROUP BY nombre;

-- BIEN

SELECT ae1.nombre, ae2.nombre, salida, llegada, AGE(llegada, salida) AS "duracion"
FROM aeropuerto ae1 JOIN vuelo v1 ON (ae1.id_aeropuerto = desde)
	 JOIN aeropuerto ae2 ON (ae2.id_aeropuerto = hasta)
WHERE AGE(llegada, salida) <= ALL(SELECT AGE(llegada, salida)
								  FROM vuelo v2
								  WHERE v1.desde = v2.desde
								 )
ORDER BY ae1.nombre, ae2.nombre, duracion ASC;