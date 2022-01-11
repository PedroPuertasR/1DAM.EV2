-- Ejercicio 1

SELECT ROUND(AVG(precio),2) || ' €' AS "Precio medio"
FROM aeropuerto ae JOIN vuelo ON (desde = ae.id_aeropuerto)
	 JOIN aeropuerto aeh ON (hasta = aeh.id_aeropuerto)
WHERE ae.nombre = 'Heathrow'
	  AND aeh.nombre = 'JFK'
	  AND descuento IS NULL;
	  
-- Ejercicio 2

SELECT cl.nombre, apellido1, apellido2
FROM cliente cl JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
	 JOIN aeropuerto ae ON (desde = id_aeropuerto)
WHERE desde = 8
	  AND TO_CHAR(fecha_reserva, 'ID') IN ('1', '2', '3');

-- Ejercicio 3

SELECT ae.nombre, ae.ciudad, salida, aeh.nombre, aeh.ciudad, llegada
FROM aeropuerto ae JOIN vuelo ON (desde = ae.id_aeropuerto)
	 JOIN aeropuerto aeh ON (hasta = aeh.id_aeropuerto)
	 JOIN reserva USING (id_vuelo)
WHERE aeh.nombre = 'Ámsterdam-Schiphol'
	  AND TO_CHAR(llegada, 'ID/MM') = '5/04'
	  AND TO_CHAR(fecha_reserva, '24HH') BETWEEN '05' AND '06';

-- Ejercicio 4

SELECT ae.ciudad, aeh.ciudad, precio-precio*COALESCE(descuento,0)/100 || ' €' AS "Precio con descuento"
FROM aeropuerto ae JOIN vuelo ON (desde = ae.id_aeropuerto)
	 JOIN aeropuerto aeh ON (hasta = aeh.id_aeropuerto)
	 JOIN avion av USING (id_avion)
WHERE aeh.ciudad = 'Sevilla'
	  AND TO_CHAR(llegada, 'MM/YYYY') = '08/2021'
	  AND av.nombre ILIKE 'Boeing%';
	  
-- Ejercicio 5

SELECT cl.nombre, apellido1, apellido2
FROM cliente cl JOIN reserva USING (id_cliente)
	 JOIN vuelo USING (id_vuelo)
WHERE TO_CHAR(fecha_reserva, 'ID') = '3'
	  AND apellido2 ILIKE '____'
	  AND AGE(salida, fecha_reserva) BETWEEN
	  	'35 days'::interval AND '40 days'::interval;