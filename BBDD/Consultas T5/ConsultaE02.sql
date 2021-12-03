-- Ejercicio 1

SELECT first_name, last_name, COUNT(orders.*) "pedidos"
FROM employees JOIN orders USING (employee_id)
GROUP BY first_name, last_name
HAVING COUNT(orders.*) BETWEEN 100 AND 150;

-- Ejercicio 2

SELECT company_name
FROM customers LEFT JOIN orders USING (customer_id)
WHERE order_id IS NULL;

-- Ejercicio 3

SELECT category_name, COUNT(DISTINCT product_id)
FROM categories JOIN products USING (category_id)
	 JOIN order_details USING (product_id)
GROUP BY category_name
LIMIT 1;

-- Ejercicio 4

SELECT category_name, product_name, ROUND(SUM(ord.unit_price * 25/100 * (1-discount))::numeric,2) || ' €' AS "Beneficio"
FROM order_details ord JOIN products USING (product_id)
	 JOIN categories USING (category_id)
GROUP BY category_name, product_name
ORDER BY category_name, product_name;

-- Ejercicio 5

SELECT DISTINCT customers.*
FROM customers JOIN orders USING (customer_id)
	 JOIN order_details USING (order_id)
WHERE ship_via = ( SELECT shipper_id
					  FROM shippers
					  WHERE company_name = 'United Package'
					)
ORDER BY company_name;