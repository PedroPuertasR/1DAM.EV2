-- Ejercicio 1

SELECT ae.nombre, COUNT(cliente.*) "personas"
FROM aeropuerto ae JOIN vuelo ON (id_aeropuerto = hasta)
	 JOIN reserva USING (id_vuelo)
	 JOIN cliente USING (id_cliente)
WHERE TO_CHAR(llegada, 'MM') IN ('01', '02', '03')
GROUP BY ae.nombre
ORDER BY COUNT(cliente.*)
LIMIT 3;

-- Corrección



-- Ejercicio 4

SELECT ae.nombre, aeh.nombre, AGE(llegada, salida) AS "duracion"
FROM aeropuerto ae JOIN vuelo ON (desde = ae.id_aeropuerto)
	 JOIN aeropuerto aeh ON (aeh.id_aeropuerto = hasta)
ORDER BY duracion
LIMIT 10;

-- Corrección



-- Ejercicio 5

SELECT id_vuelo, salida, llegada, COUNT(id_cliente) AS "personas", ROUND(COUNT(id_cliente) * precio, 2) || ' €' AS "dinero total"
FROM vuelo JOIN reserva USING (id_vuelo)
	 JOIN cliente USING (id_cliente)
WHERE TO_CHAR(salida, 'ID') IN ('5', '6', '7')
	  AND TO_CHAR(salida, 'MM') IN ('07', '08')
	  AND TO_CHAR(llegada, 'ID') IN ('5', '6', '7')
	  AND TO_CHAR(llegada, 'MM') IN ('07', '08')
GROUP BY id_vuelo;

-- Corrección

