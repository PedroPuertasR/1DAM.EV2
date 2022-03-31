/*
Selecciona la media, agrupada por nombre de aeropuerto de salida, del % de ocupación de los vuelos. 
PISTA: tendrás que incluir una subconsulta dentro de otra y, en la interior, usar una subconsulta en el select :S
*/

SELECT nombre_salida, id_avion, ROUND(AVG(promedio),2) AS "media_pasajeros"
FROM(SELECT ae.nombre AS "nombre_salida", id_avion, COUNT(id_reserva) AS "promedio"
	 FROM reserva JOIN vuelo USING (id_vuelo)
	 	  JOIN avion USING (id_avion)
	 	  JOIN aeropuerto ae ON (desde = id_aeropuerto)
	 GROUP BY nombre_salida, id_avion)conteo
GROUP BY nombre_salida, id_avion
ORDER BY nombre_salida, id_avion;

/*
Suponiendo que el 30% del precio de cada billete son beneficios (y el 70% son gastos), 
¿cuál es el trayecto que más rendimiento económico da? Es decir, ¿en qué trayecto estamos ganando más dinero? 
¿Y con el que menos? Lo puedes hacer en consultas diferentes usando WITH
*/

WITH beneficios AS (
	SELECT id_vuelo, ROUND((precio - precio * COALESCE(descuento, 0)/100),2)::numeric  AS "beneficio"
	FROM vuelo
	GROUP BY id_vuelo
)
SELECT id_vuelo, beneficio || ' €'
FROM beneficios
ORDER BY beneficio DESC
LIMIT 1;


WITH beneficios AS (
	SELECT id_vuelo, ROUND((precio - precio * COALESCE(descuento, 0)/100),2)::numeric  AS "beneficio"
	FROM vuelo
	GROUP BY id_vuelo
)
SELECT id_vuelo, beneficio || ' €'
FROM beneficios
ORDER BY beneficio
LIMIT 1;



/*
Seleccionar el nombre y apellidos de los clientes que 
no han hecho ninguna reserva para un vuelo que salga en el tercer trimestre desde Sevilla.
*/

SELECT nombre, apellido1, apellido2, salida
FROM cliente JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
WHERE salida NOT IN (SELECT salida
					 FROM vuelo
					 WHERE TO_CHAR(salida, 'MM') IN ('10','11','12'));
					 
/*
Selecciona el nombre y apellidos de aquellos clientes cuyo gasto en reservas de vuelos con origen en España 
(Sevilla, Málaga, Madrid, Bilbao y Barcelona) ha sido superior a la media total de gasto de vuelos con origen fuera de España.
*/


WITH fuera AS (
	SELECT ROUND(AVG(precio - (precio * COALESCE(descuento, 0) / 100)),2) AS media
	FROM vuelo JOIN aeropuerto ON (desde = id_aeropuerto)
	WHERE nombre NOT IN ('Sevilla', 'Barcelona', 'Madrid', 'Málaga', 'Bilbao')
)
SELECT cl.nombre, cl.apellido1, cl.apellido2, ROUND(precio - (precio * COALESCE(descuento, 0) / 100),2) || ' €' AS "precio"
FROM cliente cl JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
	 JOIN aeropuerto ae ON (desde = id_aeropuerto)
WHERE precio > (SELECT media
				FROM fuera)
	  AND ae.nombre IN ('Sevilla', 'Barcelona', 'Madrid', 'Málaga', 'Bilbao');