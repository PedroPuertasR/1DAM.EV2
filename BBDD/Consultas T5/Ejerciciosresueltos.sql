-- Obtener el número de productos diferentes que ha vendido cada empleado. Debe aparecer el id de empleado
-- y el número de productos diferentes que ha vendido.

SELECT employee_id, product_name, SUM(DISTINCT quantity) AS "vendidos"
FROM products JOIN order_details USING (product_id)
	JOIN orders USING (order_id)
GROUP BY employee_id, product_id
ORDER BY employee_id, product_name;

-- Seleccionar las categorias de productos de las que hayan comprado más de 5 productos
-- diferentes los clientes que no son de Brasil. Debe aparecer el nombre de la categoría
-- y el número de productos diferentes comprados.

SELECT category_name, SUM(quantity) || ' unidades' AS "Productos comprados"
FROM customers JOIN orders USING (customer_id)
	 JOIN order_details USING (order_id)
	 JOIN products USING (product_id)
	 JOIN categories USING (category_id)
WHERE quantity > 5
	  AND country != 'Brazil'
GROUP BY category_name;

-- Corrección

SELECT category_name, COUNT(DISTINCT product_id) || ' unidades' AS "Productos comprados"
FROM customers JOIN orders USING (customer_id)
	 JOIN order_details USING (order_id)
	 JOIN products USING (product_id)
	 JOIN categories USING (category_id)
WHERE country != 'Brazil'
GROUP BY category_name
HAVING COUNT(DISTINCT product_id) > 5;

-- 