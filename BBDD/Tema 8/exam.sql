-- Queremos un listado de las reservas de los clientes (nombre y apellidos), así como del importe de las mismas
--teniendo en cuenta el descuento. El listado ha de estar ordenado ascendentemente por fecha, la cual
--también ha de reflejarse en el mismo.

SELECT nombre, apellido1, apellido2, id_reserva, ROUND(precio - precio * COALESCE(descuento, 0)/100, 2) || ' €' AS "precio",
	   fecha_reserva
FROM cliente JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
ORDER BY fecha_reserva ASC;


--Queremos un listado del número de vuelos de salida programados en cada aeropuerto para el més de abril.
--La salida será:
--nombre , mes, num_vuelos

SELECT ae.nombre, EXTRACT(month from salida) AS "mes", COUNT(id_vuelo) AS "vuelos"
FROM aeropuerto ae JOIN vuelo ON (id_aeropuerto = desde)
WHERE TO_CHAR(salida, 'MM') = '04'
GROUP BY ae.nombre, EXTRACT(month from salida);

--Queremos un listado del número total de vuelos de aquellos aeropuertos que han tenido al menos 50 vuelos
--La salida será:
--Nombre, aeropuerto, num_vuelos

WITH vuelosSalida AS(
	SELECT ae.nombre AS "nombre", COUNT(id_vuelo) AS "total"
	FROM aeropuerto ae JOIN vuelo ON (desde = ae.id_aeropuerto)
	GROUP BY ae.nombre
),  vuelosLlegada AS(
	SELECT ae2.nombre, COUNT(id_vuelo) AS "total2"
	FROM aeropuerto ae2 JOIN vuelo ON (hasta = ae2.id_aeropuerto)
	GROUP BY ae2.nombre
),  totalVuelos AS(
	SELECT nombre, total + total2 AS "vuelos_totales"
	FROM vuelosSalida JOIN vuelosLlegada USING(nombre)
	WHERE total + total2 >= 50
)
SELECT *
FROM totalVuelos;

--Queremos un listado de aquellos aeropuertos en los cuales el Boeing 737-300 ha realizado un número de
--vuelos mayor que el promedio de vuelos realizados por mes en 2021 en el correspondiente aeropuerto.

SELECT ae.nombre, COUNT(id_vuelo)
FROM vuelo JOIN avion av USING (id_avion)
	 JOIN aeropuerto ae ON(desde = ae.id_aeropuerto)
WHERE av.nombre = 'Boeing 737-300'
GROUP BY ae.nombre
HAVING COUNT(id_vuelo) > (SELECT AVG(conteo)
						  FROM (SELECT desde, COUNT(id_vuelo) AS "conteo"
								FROM vuelo v2 JOIN aeropuerto ae2 ON (desde = ae2.id_aeropuerto)
								WHERE TO_CHAR(salida, 'YYYY') = '2021'
									  AND ae.nombre = ae2.nombre
								GROUP BY desde, TO_CHAR(salida, 'MM')
						  	   ) promedio
						 );	 

--Se consideran aptos aquellos vuelos cuyas plazas están cubiertas al menos al 80% durante los meses de
--verano (junio, julio, agosto y septiembre), ó al menos al 50% el resto del año.
--Queremos un listado detallado de dichos vuelos, de la siguiente manera:
--Aeropuerto, fecha_salida, avión, max_plaza, plazas_reservadas, plazas_disponibles

SELECT ae.nombre, salida, id_avion, max_pasajeros, promedio, max_pasajeros - promedio
FROM (SELECT id_vuelo, COUNT(id_reserva) AS "promedio"
	  FROM vuelo JOIN reserva USING(id_vuelo)
	  GROUP BY id_vuelo) conteo JOIN vuelo USING (id_vuelo)
	  					 JOIN avion USING (id_avion)
						 JOIN aeropuerto ae ON (desde = id_aeropuerto)
WHERE (TO_CHAR(salida, 'MM') IN ('06', '07', '08', '09')
	  AND promedio > max_pasajeros * 0.8)
	  OR 
	  (TO_CHAR(salida, 'MM') NOT IN ('06', '07', '08', '09'));
	  
--Necesitamos saber el promedio de pasajeros transportados por 'aeropuertos en uso' en cada mes de reserva.
--El listado mostrará:
--mes, pasajeros_por_aeropuertos, num_aeropuertos

SELECT salida_aero, mes, ROUND(AVG(promedio),2) AS "promedio"
FROM (SELECT COUNT(id_reserva) AS "promedio", TO_CHAR(salida,'MM') AS "mes", ae.nombre AS "salida_aero"
	  FROM reserva JOIN vuelo USING (id_vuelo)
	 	   JOIN aeropuerto ae ON (desde = id_aeropuerto)
	  GROUP BY TO_CHAR(salida,'MM'), salida_aero) conteo
GROUP BY salida_aero, mes
ORDER BY mes;