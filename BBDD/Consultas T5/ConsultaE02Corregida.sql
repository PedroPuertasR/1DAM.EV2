-- Ejercicio 1

SELECT first_name, last_name, COUNT(orders.*) "pedidos"
FROM employees JOIN orders USING (employee_id)
GROUP BY first_name, last_name
HAVING COUNT(orders.*) BETWEEN 100 AND 150;

-- Corrección

-- Ejercicio 2

SELECT company_name
FROM customers LEFT JOIN orders USING (customer_id)
WHERE order_id IS NULL;

-- Corrección

SELECT DISTINCT company_name
FROM customers
WHERE customer_id NOT IN ( SELECT DISTINCT customer_id
					   FROM orders
					 );
	
-- Otra corrección

SELECT company_name, COUNT(order_id)
FROM customers LEFT JOIN orders USING (customer_id)
GROUP BY company_name
HAVING COUNT(order_id) = 0;

-- Ejercicio 3

SELECT DISTINCT category_name, COUNT(DISTINCT product_id)
FROM categories JOIN products USING (category_id)
	 JOIN order_details USING (product_id)
GROUP BY category_name
ORDER BY COUNT(DISTINCT product_id) DESC
LIMIT 1;

-- Corrección

SELECT DISTINCT category_name, COUNT(DISTINCT product_id)
FROM categories JOIN products USING (category_id)
	 JOIN order_details USING (product_id)
GROUP BY category_name
HAVING COUNT(DISTINCT product_id) = ( SELECT MAX(valor)
									  FROM (SELECT COUNT(DISTINCT product_id) "valor"
									 		FROM order_details JOIN products USING (product_id)
									  		GROUP BY category_id
									  	   ) subconsulta
									);

-- Ejercicio 4

SELECT category_name, product_name, ROUND(SUM(ord.unit_price * 25/100 * (1-discount))::numeric,2) || ' €' AS "Beneficio"
FROM order_details ord JOIN products USING (product_id)
	 JOIN categories USING (category_id)
GROUP BY category_name, product_name
ORDER BY category_name, product_name;

-- Corrección

-- Ejercicio 5

SELECT DISTINCT customers.*
FROM customers JOIN orders USING (customer_id)
	 JOIN order_details USING (order_id)
WHERE ship_via NOT IN (SELECT shipper_id
				 	   FROM shippers
			 	 	   WHERE company_name != 'United Package'
				  	  )
ORDER BY company_name;

-- Corrección

SELECT DISTINCT cu.company_name
FROM customers cu JOIN orders o USING (customer_id)
	 JOIN shippers s ON (shipper_id = ship_via)
WHERE cu.customer_id NOT IN ( SELECT DISTINCT cu.customer_id
						  FROM customers cu JOIN orders o USING (customer_id)
	 						   JOIN shippers s ON (shipper_id = ship_via)
						  WHERE s.company_name != 'United Package'
						);
