-- Seleccionar los 3 vuelos más largos (con mayor duración) de cada día de la semana. Debe aparecer el nombre del aeropuerto de salida,
-- el de llegada, la fecha y hora de salida y llegada y la duración.
-- Se debe ordenar la salida por aeropuerto, ascendente, y duración, descendente.

SELECT ae.nombre, aeh.nombre, salida, llegada, AGE(llegada, salida), TO_CHAR(salida, 'ID')
FROM aeropuerto ae JOIN vuelo v1 ON (ae.id_aeropuerto = desde)
	 JOIN aeropuerto aeh ON (aeh.id_aeropuerto = hasta)
WHERE AGE(llegada, salida) >= ALL (SELECT AGE(llegada, salida)
								   FROM vuelo v2
								   WHERE TO_CHAR(v1.salida, 'ID') = TO_CHAR(v2.salida, 'ID')
								   LIMIT 3
								  )
ORDER BY ae.nombre, AGE(llegada,salida) DESC;

-- Corrección

SELECT ae.nombre, aeh.nombre, salida, llegada, AGE(llegada, salida), TO_CHAR(salida, 'ID')
FROM aeropuerto ae JOIN vuelo v1 ON (ae.id_aeropuerto = desde)
	 JOIN aeropuerto aeh ON (aeh.id_aeropuerto = hasta)
WHERE AGE(llegada, salida) IN (SELECT AGE(llegada, salida)
							   FROM vuelo v2
							   WHERE TO_CHAR(v1.salida, 'ID') = TO_CHAR(v2.salida, 'ID')
							   ORDER BY AGE(llegada, salida) DESC
							   LIMIT 3
							  )
ORDER BY ae.nombre, AGE(llegada,salida) DESC;