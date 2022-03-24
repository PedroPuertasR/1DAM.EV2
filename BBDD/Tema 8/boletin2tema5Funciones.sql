-- Seleccionar el número de pedidos atendidos por cada empleado, sí y sólo si dicho número está entre 100 y 150.
DROP FUNCTION IF EXISTS entreNumeros(integer);

CREATE OR REPLACE FUNCTION entreNumeros(empleado integer)
RETURNS integer AS
$$
	SELECT COUNT(order_id)
	FROM employees JOIN orders USING (employee_id)
	WHERE employee_id = $1
	GROUP BY employee_id
	HAVING COUNT(order_id) IN (SELECT COUNT(order_id)
							   FROM employees JOIN orders USING (employee_id)
							   GROUP BY employee_id
							   HAVING COUNT(order_id) BETWEEN 100 AND 150)
$$ LANGUAGE 'sql';

SELECT * FROM entreNumeros(1);

-- Seleccionar el nombre de las empresas que no han realizado ningún pedido.

DROP FUNCTION IF EXISTS sinPedido();

CREATE OR REPLACE FUNCTION sinPedido()
RETURNS TABLE (company varchar) AS
$$
	SELECT company_name
	FROM customers
	WHERE customer_id NOT IN (SELECT DISTINCT customer_id
							  FROM orders)
$$ LANGUAGE 'sql';

SELECT * FROM sinPedido();
						  
-- Seleccionar la categoría que tiene más productos diferentes solicitados en pedidos.
-- Mostrar el nombre de la categoría y dicho número.
DROP FUNCTION IF EXISTS productosDif;

CREATE OR REPLACE FUNCTION productosDif(varchar)
RETURNS TABLE (nombre varchar, productos integer) AS
$$
	SELECT $1, COUNT(product_id)
	FROM categories JOIN products USING (category_id)
	WHERE product_id IN (SELECT DISTINCT product_id
						 FROM order_details)
		  AND category_name = $1
$$ LANGUAGE 'sql';

SELECT * FROM productosDif('Confections');

-- Si suponemos que nuestro margen de beneficio con los productos es de un 25% 
-- (es decir, el 25% de su precio, son beneficios, y el 75% son costes), 
-- calcular la cantidad de beneficio que hemos obtenido, agrupado por categoría y producto. 
-- Las cantidades deben redondearse a dos decimales.

DROP FUNCTION IF EXISTS beneficioProducto;

CREATE OR REPLACE FUNCTION beneficioProducto (varchar)
RETURNS TABLE (categoria varchar, nombre varchar, beneficio numeric) AS
$$
	SELECT category_name, product_name, ROUND(SUM(0.25 * (o.quantity * (o.unit_price - 1 * o.discount)))::numeric, 2) AS "precio_final"
	FROM order_details o JOIN products USING (product_id)
		 JOIN categories USING (category_id)
	GROUP BY category_name, product_name
	HAVING product_name = $1
$$ LANGUAGE 'sql';

SELECT * FROM beneficioProducto('Chang');


-- Selecciona aquellos clientes (CUSTOMERS) para los que todos los envíos que ha recibido (sí, todos) 
-- los haya transportado (SHIPPERS) la empresa United Package.

DROP FUNCTION IF EXISTS buscarCustomer;

CREATE OR REPLACE FUNCTION buscarCustomer(varchar)
RETURNS TABLE (empresa varchar, mensajeria varchar) AS
$$
	SELECT cu.company_name, s.company_name
	FROM customers cu JOIN orders o USING (customer_id)
		 JOIN shippers s ON (shipper_id = ship_via)
	GROUP BY cu.company_name, s.company_name
	HAVING cu.company_name = $1
$$ LANGUAGE 'sql';

SELECT * FROM buscarCustomer('Around the Horn');