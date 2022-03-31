/*
Queremos un listado de las reservas de los clientes (nombre y apellidos), así como del importe de
las mismas teniendo en cuenta el descuento. El listado ha de estar ordenado ascendentemente
por importe total.
*/

SELECT nombre, apellido1, apellido2, ROUND(precio - precio * descuento/100, 2) || ' €' AS "importe"
FROM cliente JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
WHERE descuento IS NOT NULL
ORDER BY importe ASC;

/*
Queremos un listado del número de vuelos de llegada programados en cada aeropuerto para el
mes de agosto.
La salida será:
nombre , mes, num_vuelos
*/

SELECT ae.nombre, TO_CHAR(llegada, 'TMMonth'), COUNT(id_vuelo) AS "num_vuelos"
FROM vuelo JOIN aeropuerto ae ON (hasta = ae.id_aeropuerto)
WHERE TO_CHAR(llegada, 'MM') = '08'
GROUP BY ae.nombre, TO_CHAR(llegada, 'TMMonth');

/*
Queremos un listado del número total de vuelos de aquellos aeropuertos que han tenido al menos
el 10% de los vuelos totales.
La salida será:
Nombre, aeropuerto, num_vuelos
*/

SELECT ae.nombre, ae.ciudad, COUNT(id_vuelo) AS "num_vuelos"
FROM vuelo JOIN aeropuerto ae ON (desde = ae.id_aeropuerto)
GROUP BY ae.nombre, ae.ciudad
HAVING COUNT(id_vuelo) >= (SELECT COUNT(id_vuelo) * 0.1
					 	   FROM vuelo);

/*
Queremos un listado de aquellos aeropuertos en los cuales el Boeing 787-8 ha realizado un
número de vuelos mayor que el promedio de vuelos realizados trimestralmente en 2021 en dicho
aeropuerto.
*/

SELECT ae.nombre, COUNT(id_vuelo)
FROM vuelo JOIN avion av USING (id_avion)
	 JOIN aeropuerto ae ON(desde = ae.id_aeropuerto)
WHERE av.nombre = 'Boeing 787-8'
GROUP BY ae.nombre
HAVING COUNT(id_vuelo) > (SELECT AVG(promedio)
						  FROM (SELECT desde, COUNT(id_vuelo) AS "promedio"
								FROM vuelo JOIN aeropuerto ae2 ON (desde = ae2.id_aeropuerto)
								WHERE TO_CHAR(salida, 'YYYY') = '2021'
									  AND ae.nombre = ae2.nombre
								GROUP BY desde, TO_CHAR(salida, 'Q')
						  	   ) sub
						 );
						 
/*						 
Se consideran aptos aquellos vuelos cuyas plazas están cubiertas al menos al 50%.
Queremos un listado detallado de dichos vuelos, de la siguiente manera:
Aeropuerto, fecha_salida, avión, max_plaza, plazas_reservadas, plazas_disponibles
NOTA: ¡NO SE PUEDE EMPLEAR HAVING!
*/

WITH reservaSalida AS(
	SELECT ae.nombre AS "nombre", max_pasajeros AS "max_salida", COUNT(id_reserva) AS "total"
	FROM reserva JOIN vuelo USING (id_vuelo)
		 JOIN avion USING (id_avion)
		 JOIN aeropuerto ae ON (desde = id_aeropuerto)
	GROUP BY ae.nombre, max_pasajeros
), reservaLlegada AS(
	SELECT ae.nombre AS "nombre", max_pasajeros AS "max_llegada", COUNT(id_reserva) AS "total2"
	FROM reserva JOIN vuelo USING (id_vuelo)
		 JOIN avion USING (id_avion)
		 JOIN aeropuerto ae ON (hasta = id_aeropuerto)
	GROUP BY ae.nombre, max_pasajeros
), reservaTotal AS (
	SELECT ae.nombre, salida, max_salida + max_llegada AS "plazas", total + total2 AS "reservadas",
		   (max_salida + max_llegada) - (total + total2) AS "disponibles"
	FROM reservaSalida JOIN reservaLlegada USING (nombre)
		 JOIN aeropuerto ae USING (nombre)
		 JOIN vuelo ON (desde = id_aeropuerto)
		 JOIN avion USING (id_avion)
	GROUP BY ae.nombre, salida, plazas, reservadas
)
SELECT *
FROM reservaTotal;

/*
Necesitamos saber el promedio de pasajeros transportados por 'aeropuertos en uso' en cada mes
de reserva.
El listado mostrará:

mes, pasajeros_por_aeropuertos, num_aeropuertos

PISTA:¡NO TODOS LOS AEROPUERTOS TRANSPORTAN PASAJEROS TODOS LOS MESES!
*/

SELECT nombre, mes, ROUND(AVG(cuenta),2) AS "promedio"
FROM (SELECT ae.nombre AS "nombre", TO_CHAR(salida, 'MM') AS "mes", COUNT(id_cliente) AS "cuenta"
	  FROM aeropuerto ae JOIN vuelo ON (desde = id_aeropuerto)
	 	   JOIN reserva USING (id_vuelo)
	 	   JOIN cliente USING (id_cliente)
	  GROUP BY ae.nombre, TO_CHAR(salida, 'MM')
	  HAVING COUNT(id_cliente) != 0
	  ORDER BY nombre, TO_CHAR(salida, 'MM')) sub
GROUP BY nombre, mes;