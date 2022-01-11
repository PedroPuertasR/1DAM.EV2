--Ejercicio 1

SELECT e.nombre, apellido1, apellido2, pr.nombre, COUNT(id_producto) AS "nº unidades"
FROM empleado e JOIN venta v USING (id_empleado)
	 JOIN lineaventa lv ON (v.id = id_venta)
	 JOIN producto pr ON (pr.id = id_producto)
WHERE id_producto >= ALL (SELECT id_producto
						  FROM lineaventa lv2 JOIN venta v2 ON (v2.id = id_venta)
						  	   JOIN empleado e2 USING (id_empleado)
						  WHERE e.id_empleado = e2.id_empleado
						 )
GROUP BY e.nombre, apellido1, apellido2, pr.nombre
ORDER BY e.nombre, apellido1, apellido2;

-- Ejercicio 2

WITH setenta AS (
	SELECT id
	FROM cliente
	WHERE EXTRACT(year from fecha_nacimiento) <= 1949
), cinco AS (
	SELECT id_empleado
	FROM empleado
	WHERE EXTRACT(year from fecha_alta) <= 2015
)

SELECT AGE(CURRENT_DATE, fecha_alta)
FROM empleado;

SELECT e.*
FROM empleado e JOIN venta v USING (id_empleado)
	 JOIN cliente cl ON (cl.id = id_cliente)
WHERE id_empleado IN (SELECT id_empleado
					  FROM cinco
				     )
	  AND cl.id IN (SELECT id
					FROM setenta
				   );
				 
-- Ejercicio 3

SELECT anio, ROUND(AVG(suma),2) || ' €' AS "media"
FROM (SELECT TO_CHAR(fecha_nacimiento, 'YYYY') AS "anio", SUM(precio_total) AS "suma"
	  FROM cliente cl JOIN venta ON (cl.id = id_cliente)
	  GROUP BY anio
	 ) sub
GROUP BY anio
ORDER BY anio;
				 
-- Ejercicio 4

WITH jefes AS (
	SELECT e2.nombre AS "nombre", e2.apellido1 AS "apellido1", e2.apellido2, e.jefe_id
	FROM empleado e JOIN empleado e2 ON (e.id_empleado = e2.jefe_id)
	WHERE e.jefe_id IS NULL
)
SELECT e.nombre, apellido1, apellido2, COUNT(v.id) AS "ventas",
	   SUM(precio_total) || ' €' AS "precio_total",
	   COUNT(v.id) * 100 / (SELECT SUM(id)
							FROM venta
						   ) AS "% de ventas"
FROM empleado e JOIN venta v USING (id_empleado)
	 JOIN lineaventa lv ON (v.id = id_venta)
	 JOIN producto pr ON (pr.id = id_producto)
WHERE e.nombre IN (SELECT nombre
				 FROM jefes
				)
	  AND apellido1 IN (SELECT apellido1
						FROM jefes
					   )
GROUP BY e.nombre, apellido1, apellido2;


-- Ejercicio 5

SELECT nombre, apellido1, apellido2, dia, ROUND(AVG(cuenta),2) "media_empleado"
FROM (SELECT nombre, apellido1, apellido2, TO_CHAR(fecha, 'TMDay') AS "dia", COUNT(v.id) AS "cuenta"
	  FROM empleado e JOIN venta v USING (id_empleado)
	  GROUP BY nombre, apellido1, apellido2, dia
	 ) sub
GROUP BY nombre, apellido1, apellido2, dia
ORDER BY nombre, apellido1, apellido2;