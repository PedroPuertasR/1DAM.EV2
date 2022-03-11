-- Seleccionar el número de pedidos atendidos por cada empleado, sí y sólo si dicho número está entre 100 y 150.

WITH pedidos AS (
	SELECT first_name, last_name, COUNT(order_id) AS "cuenta"
	FROM orders JOIN employees USING (employee_id)
	GROUP BY first_name, last_name
	HAVING COUNT(order_id) BETWEEN 100 AND 150
	ORDER BY first_name, last_name
)
SELECT *
FROM pedidos;

-- Seleccionar el nombre de las empresas que no han realizado ningún pedido.

SELECT DISTINCT company_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id
						  FROM orders);
						  
-- Seleccionar la categoría que tiene más productos diferentes solicitados en pedidos.
-- Mostrar el nombre de la categoría y dicho número.

SELECT category_name, COUNT(product_id)
FROM categories JOIN products USING (category_id)
WHERE product_id IN (SELECT DISTINCT product_id
					 FROM order_details)
GROUP BY category_name
ORDER BY COUNT(product_id) DESC
LIMIT 1;


-- Si suponemos que nuestro margen de beneficio con los productos es de un 25% 
-- (es decir, el 25% de su precio, son beneficios, y el 75% son costes), 
-- calcular la cantidad de beneficio que hemos obtenido, agrupado por categoría y producto. 
-- Las cantidades deben redondearse a dos decimales.


WITH beneficio AS (
	SELECT category_name, product_name, quantity * (o.unit_price - o.unit_price * discount) AS "precio_final"
	FROM order_details o JOIN products USING (product_id)
		 JOIN categories USING (category_id)
)
SELECT category_name, product_name, ROUND(SUM((precio_final * 25/100)::numeric),2) || ' €' AS "beneficio"
FROM beneficio
GROUP BY category_name, product_name
ORDER BY category_name, product_name;

-- Selecciona aquellos clientes (CUSTOMERS) para los que todos los envíos que ha recibido (sí, todos) 
-- los haya transportado (SHIPPERS) la empresa United Package.

SELECT *
FROM shippers;

SELECT *
FROM orders;

SELECT cu.company_name, COUNT(order_id)
FROM orders JOIN customers cu USING (customer_id)
	 JOIN shippers ON (shipper_id = ship_via)
WHERE ship_via IN (SELECT shipper_id
				   FROM shippers
				   WHERE company_name = 'United Package')
GROUP BY cu.company_name;