-- Ejercicio 3

SELECT provincia, cl.nombre, fecha_operacion, precio_final || ' €' AS "cuantía"
FROM inmueble i1 JOIN operacion USING (id_inmueble)
	 JOIN comprador cl USING (id_cliente)
	 JOIN tipo ti ON (id_tipo = tipo_inmueble)
WHERE precio_final >= ALL (SELECT precio_final
					  FROM operacion JOIN inmueble i2 USING (id_inmueble)
						   JOIN tipo ti2 ON (id_tipo = tipo_inmueble)
					  WHERE i1.provincia = i2.provincia
						   	AND ti2.nombre = 'Piso'
						    AND tipo_operacion = 'Venta'
					 )
	  AND ti.nombre = 'Piso'
	  AND tipo_operacion = 'Venta'
ORDER BY provincia;

-- Ejercicio 4

SELECT provincia, TO_CHAR(fecha_operacion, 'TMMonth'), i1.id_inmueble, i1.fecha_alta, i1.tipo_inmueble,
	   i1.tipo_operacion, i1.superficie, i1.precio AS "precio inicial", precio_final
FROM inmueble i1 JOIN operacion op1 USING (id_inmueble)
WHERE tipo_operacion = 'Alquiler'
	  AND precio_final <= ALL (SELECT precio_final
							   FROM operacion op2 JOIN inmueble i2 USING (id_inmueble)
							   		JOIN tipo ON (id_tipo = tipo_inmueble)
							   WHERE i1.provincia = i2.provincia
							   		 AND TO_CHAR(op1.fecha_operacion, 'MM') = TO_CHAR(op2.fecha_operacion, 'MM')
							   		 AND tipo_operacion = 'Alquiler'
	  						  )
ORDER BY provincia, TO_CHAR(fecha_operacion, 'MM');