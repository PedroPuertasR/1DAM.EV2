-- Ejercicio 1

SELECT ae.nombre, aeh.nombre, v1.llegada, v1.salida, AGE(llegada, salida) AS "duracion"
FROM aeropuerto ae JOIN vuelo v1 ON (desde = ae.id_aeropuerto)
	 JOIN aeropuerto aeh ON (hasta = aeh.id_aeropuerto)
WHERE AGE(llegada, salida) >= ALL (SELECT AGE(llegada, salida)
							 	   FROM vuelo v2
								   WHERE TO_CHAR(v1.salida, 'ID') = TO_CHAR(v2.salida, 'ID')
								  )
ORDER BY TO_CHAR(salida, 'ID'), ae.nombre, aeh.nombre;

-- Ejercicio 2

SELECT cl.nombre, cl.apellido1, cl.apellido2, ae.nombre, ciudad,
	   ROUND(v1.precio - (v1.precio * COALESCE(v1.descuento, 0) /100),2) || ' €' AS "precio"
FROM cliente cl JOIN reserva USING (id_cliente)
	 JOIN vuelo v1 USING (id_vuelo)
	 JOIN aeropuerto ae ON (desde = id_aeropuerto)
WHERE v1.precio - (v1.precio * COALESCE(v1.descuento, 0) /100) >= ANY (SELECT SUM(precio - (precio * COALESCE(descuento, 0) /100))
						   FROM vuelo v2
						   WHERE v1.precio = v2.precio
						  )
ORDER BY ae.nombre;

-- Corrección

SELECT cl.nombre, cl.apellido1, cl.apellido2, ae.nombre, ciudad,
	   ROUND(SUM(precio - (precio * COALESCE(descuento, 0) /100)),2) || ' €' AS "precio"
FROM cliente cl JOIN reserva r USING (id_cliente)
	 JOIN vuelo v1 USING (id_vuelo)
	 JOIN aeropuerto ae ON (desde = id_aeropuerto)
GROUP BY cl.nombre, cl.apellido1, cl.apellido2, ae.nombre, ciudad
HAVING SUM(precio - (precio * COALESCE(descuento, 0) /100)) >= ALL (SELECT SUM(precio - (precio * COALESCE(descuento, 0) /100))
						   										   FROM cliente cl2 JOIN reserva r2 USING (id_cliente)
	 																	JOIN vuelo v2 USING (id_vuelo)
	 																	JOIN aeropuerto ae2 ON (desde = id_aeropuerto)
						   										   WHERE ae.nombre = ae2.nombre
																   GROUP BY cl2.nombre, cl2.apellido1, cl2.apellido2, ae2.nombre, ciudad
						  										  );