-- Ejercicio 1

SELECT nombre, ROUND(AVG(ocupacion),2) AS ocupacion
FROM (SELECT nombre, id_vuelo, COUNT(id_reserva),
	  		 (SELECT max_pasajeros
			  FROM avion 
			  WHERE v.id_avion = id_avion),
	  		 ROUND(COUNT(id_reserva) / (SELECT max_pasajeros
								 		FROM avion
								 		WHERE v.id_avion = id_avion)::numeric*100,2) AS ocupacion
	  FROM vuelo v JOIN reserva USING(id_vuelo)
	  	   JOIN aeropuerto ON (desde = id_aeropuerto)
	  GROUP BY nombre, id_vuelo
	 ) datos
GROUP BY nombre;

-- Otra forma

WITH ocupacion_por_vuelo AS (
	SELECT nombre, id_vuelo,
	  		 ROUND(COUNT(id_reserva) / (SELECT max_pasajeros
								 		FROM avion
								 		WHERE v.id_avion = id_avion)::numeric*100,2) AS ocupacion
	  FROM vuelo v JOIN reserva USING(id_vuelo)
	  	   JOIN aeropuerto ON (desde = id_aeropuerto)
	  GROUP BY nombre, id_vuelo
)
SELECT nombre, ROUND(AVG(ocupacion),2)
FROM ocupacion_por_vuelo
GROUP BY nombre;

-- Ejercicio 2

SELECT mes, nombre, SUM(numero)
FROM ((SELECT TO_CHAR(salida, 'TMMonth') AS "mes", nombre, COUNT(id_reserva) AS "numero"
	   FROM vuelo JOIN aeropuerto ON (desde = id_aeropuerto)
	   		JOIN reserva USING (id_vuelo)
	   GROUP BY TO_CHAR(salida, 'TMMonth'), nombre
	  )
UNION
	  (SELECT TO_CHAR(llegada, 'TMMonth') AS "mes", nombre, COUNT(id_reserva) AS "numero"
	   FROM vuelo JOIN aeropuerto ON (hasta = id_aeropuerto)
	   		JOIN reserva USING (id_vuelo)
	   GROUP BY TO_CHAR(llegada, 'TMMonth'), nombre)
	 ) datos
GROUP BY mes, nombre;

-- Otra

WITH trafico_salida AS (
		SELECT TO_CHAR(salida, 'TMMonth') as "mes", nombre, COUNT(id_reserva) as "numero", 'salida'
		FROM vuelo JOIN aeropuerto ON (desde = id_aeropuerto)
				JOIN reserva using (id_vuelo)
		GROUP BY TO_CHAR(salida, 'TMMonth'), nombre
), trafico_llegada AS (
		SELECT TO_CHAR(llegada, 'TMMonth') as "mes", nombre, COUNT(id_reserva) as "numero", 'llegada'
		FROM vuelo JOIN aeropuerto ON (hasta = id_aeropuerto)
				JOIN reserva using (id_vuelo)
		GROUP BY TO_CHAR(llegada, 'TMMonth'), nombre
), trafico AS (
	SELECT *
	FROM trafico_salida	
	UNION
	SELECT * 
	FROM trafico_llegada		
)
SELECT mes, nombre, SUM(numero)
FROM trafico
GROUP BY mes, nombre;

-- Ejercicio 3

WITH suma_por_trayecto AS (
		SELECT ae1.ciudad, ae2.ciudad, SUM(round(coalesce(precio * (1 - descuento::numeric / 100), precio) * 0.30,2)) as numval
		FROM vuelo JOIN reserva USING (id_vuelo)
				JOIN aeropuerto ae1 ON (desde = ae1.id_aeropuerto)
				JOIN aeropuerto ae2 ON (hasta = ae2.id_aeropuerto)
		GROUP BY ae1.ciudad, ae2.ciudad
), maximo_por_trayecto AS (
		SELECT max(numval) as "maximo"
		FROM suma_por_trayecto
), minimo_por_trayecto AS (
		SELECT min(numval) as "minimo"
		FROM suma_por_trayecto
), trayecto_maximo AS (
		SELECT ae1.ciudad, ae2.ciudad, SUM(round(coalesce(precio * (1 - descuento::numeric / 100), precio) * 0.30,2)) as suma
		FROM vuelo JOIN reserva USING (id_vuelo)
				JOIN aeropuerto ae1 ON (desde = ae1.id_aeropuerto)
				JOIN aeropuerto ae2 ON (hasta = ae2.id_aeropuerto)
		GROUP BY ae1.ciudad, ae2.ciudad
		HAVING SUM(round(coalesce(precio * (1 - descuento::numeric / 100), precio) * 0.30,2)) = 
				(
					SELECT maximo
					FROM maximo_por_trayecto
				)
), trayecto_minimo AS (
		SELECT ae1.ciudad, ae2.ciudad, SUM(round(coalesce(precio * (1 - descuento::numeric / 100), precio) * 0.30,2)) as suma
		FROM vuelo JOIN reserva USING (id_vuelo)
				JOIN aeropuerto ae1 ON (desde = ae1.id_aeropuerto)
				JOIN aeropuerto ae2 ON (hasta = ae2.id_aeropuerto)
		GROUP BY ae1.ciudad, ae2.ciudad
		HAVING SUM(round(coalesce(precio * (1 - descuento::numeric / 100), precio) * 0.30,2)) = 
				(
					SELECT minimo
					FROM minimo_por_trayecto
				)
)
SELECT *
FROM trayecto_maximo
UNION
SELECT *
FROM trayecto_minimo;

-- Ejercicio 4

WITH novuelo AS (
	SELECT id_cliente AS todos
	FROM cliente JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
	WHERE TO_CHAR(salida, 'Q') = '3'
)
SELECT DISTINCT nombre, apellido1, apellido2
FROM cliente
WHERE id_cliente NOT IN (SELECT todos
						 FROM novuelo
						);
			
-- Ejercicio 5

WITH gasto_por_cliente AS (
		SELECT SUM(COALESCE(PRECIO * (1 - (DESCUENTO::numeric / 100)),PRECIO)) sumval
		FROM VUELO VU JOIN AEROPUERTO AER ON (VU.HASTA = AER.ID_AEROPUERTO)
				JOIN RESERVA USING (ID_VUELO)
		WHERE UPPER(AER.CIUDAD) NOT IN ('SEVILLA','MÁLAGA','MADRID','BILBAO','BARCELONA')
		GROUP BY ID_CLIENTE
), gasto_medio AS (
		SELECT AVG(sumval) as "media"
		FROM gasto_por_cliente
)
SELECT CL.NOMBRE "NOMBRE", APELLIDO1, APELLIDO2, 
		SUM(COALESCE(PRECIO * (1 - (DESCUENTO::numeric / 100)),PRECIO)) "GASTO"
FROM CLIENTE CL JOIN RESERVA USING (ID_CLIENTE)
JOIN VUELO V USING (ID_VUELO)
JOIN AEROPUERTO AE ON (V.DESDE = AE.ID_AEROPUERTO)
WHERE UPPER(AE.CIUDAD) IN ('SEVILLA','MÁLAGA','MADRID','BILBAO','BARCELONA')
GROUP BY CL.NOMBRE, APELLIDO1, APELLIDO2
HAVING SUM(COALESCE(DESCUENTO, PRECIO * (1 - (DESCUENTO / 100)),PRECIO)) >=
		(SELECT media
		 FROM gasto_medio);