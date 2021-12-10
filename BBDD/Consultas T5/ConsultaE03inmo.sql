-- Ejercicio 2

SELECT nombre
FROM comprador JOIN operacion USING (id_cliente)
	 JOIN inmueble USING (id_inmueble)
WHERE provincia = 'Almería'
	  AND tipo_operacion = 'Venta'
	  AND precio_final > (SELECT AVG(precio)
						  FROM inmueble
						  WHERE tipo_operacion = 'Venta'
						  		AND provincia = 'Almería'
	  					 );
						 
-- Corrección

-- Ejercicio 3

SELECT DISTINCT v.nombre
FROM vendedor v JOIN operacion USING (id_vendedor)
	 JOIN inmueble USING (id_inmueble)
WHERE tipo_operacion = 'Venta'
	  AND tipo_inmueble = (SELECT id_tipo
						   FROM tipo
						   WHERE nombre = 'Parking'
						  );
						  
-- Corrección