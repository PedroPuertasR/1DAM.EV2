-- Selecciona, agrupando por vendedor, el precio final medio de pisos y casas que se han vendido en cada provincia.
-- Debe aparecer el nombre del vendedor, la provincia y el precio medio.

SELECT v.nombre, provincia, ROUND(AVG(precio_final),2) || ' €' AS "precio final medio"
FROM inmueble JOIN operacion USING (id_inmueble)
	 JOIN vendedor v USING (id_vendedor)
	 JOIN tipo ti ON (id_tipo = tipo_inmueble)
WHERE tipo_operacion = 'Venta'
	  AND ti.nombre IN ('Casa', 'Piso')
GROUP BY v.nombre, provincia
ORDER BY v.nombre, provincia;


-- Seleccionar la suma del precio final, agrupado por provincia, de aquellos locales donde su precio sea superior 
-- al producto del número de metros cuadrados de ese local por el precio medio del metro cuadrado de los locales de esa provincia.




-- Selecciona la media de pisos vendidos al día que se han vendido en cada provincia. 
-- Es decir, debes calcular primero el número de pisos que se han vendido cada día de la semana en cada provincia, 
-- y después, sobre eso, calcular la media por provincia.


SELECT provincia, TO_CHAR(fecha_operacion, 'TMDay'), AVG(pisos)
FROM (SELECT COUNT(id_inmueble) AS pisos
	  FROM inmueble i JOIN operacion USING (id_inmueble)
	  GROUP BY provincia, TO_CHAR(fecha_operacion, 'TMDay')
	 ) hla
GROUP BY provincia, TO_CHAR(fecha_operacion, 'TMDay');

SELECT *
FROM operacion;

WITH contar AS (
	SELECT provincia, TO_CHAR(fecha_operacion, 'TMDay') AS "fecha_operacion", COUNT(id_inmueble) AS pisos
	FROM inmueble i JOIN operacion op USING (id_inmueble)
		 JOIN tipo ti ON (id_tipo = tipo_inmueble)
	WHERE tipo_operacion = 'Venta'
		  AND ti.nombre = 'Piso'
	GROUP BY provincia, TO_CHAR(fecha_operacion, 'TMDay'), TO_CHAR(fecha_operacion, 'ID')
	ORDER BY provincia, TO_CHAR(fecha_operacion, 'ID')
)
SELECT provincia, fecha_operacion, ROUND(AVG(pisos),2) AS "pisos"
FROM contar
GROUP BY provincia, fecha_operacion
ORDER BY provincia;


-- Selecciona el cliente que ha comprado más barato cada tipo de inmueble (casa, piso, local, …). 
-- Debe aparecer el nombre del cliente, la provincia del inmueble, la fecha de operación, 
-- el precio final y el nombre del tipo de inmueble. ¿Te ves capaz de modificar la consulta para que en lugar de que salga el más barato,
-- salgan los 3 más baratos?

SELECT cl.nombre, provincia, fecha_operacion, ti.nombre, op.precio_final
FROM comprador cl JOIN operacion op USING (id_cliente)
	 JOIN inmueble USING (id_inmueble)
	 JOIN tipo ti ON (id_tipo = tipo_inmueble)
WHERE precio_final <= ALL (SELECT precio_final
						   FROM operacion JOIN comprador cl2 USING (id_cliente)
						   		JOIN tipo ON (id_tipo = tipo_inmueble)
						   WHERE ti.nombre = ti2.nombre
						  )
ORDER BY ti.nombre;

-- De entre todos los clientes que han comprado un piso en Sevilla, selecciona a los que no han realizado ninguna compra en fin de semana.
WITH finde AS(
	SELECT nombre
	FROM comprador JOIN operacion USING (id_cliente)
		 JOIN inmueble USING (id_inmueble)
	WHERE tipo_operacion = 'Venta'
		  AND TO_CHAR(fecha_operacion, 'ID') IN ('5', '6', '7')
)
SELECT nombre
FROM comprador JOIN operacion USING (id_cliente)
	 JOIN inmueble USING (id_inmueble)
WHERE provincia = 'Sevilla'
	  AND nombre NOT IN (SELECT nombre
						 FROM finde
	  					);


-- El responsable de la inmobiliaria quiere saber el rendimiento de operaciones de alquiler que realiza cada vendedor 
-- durante los días de la semana (de lunes a sábado). Se debe mostrar el nombre del vendedor, 
-- el % del número de operaciones de alquiler que ha realizado en ese día de la semana ese vendedor 
-- y el precio medio por metro cuadrado de las operaciones de alquiler que ha realizado ese vendedor en ese día de la semana.
