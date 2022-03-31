/*13.Queremos un listado de los empleados y sus edades*/

SELECT employee_id, first_name, last_name, EXTRACT(year from AGE(CURRENT_DATE, birth_date)) || ' años' AS "anios"
FROM employees;

/*14.Queremos un listado del numero de empleados contratados cada mes del año*/

SELECT EXTRACT(month from hire_date), COUNT(employee_id)
FROM employees
GROUP BY EXTRACT(month from hire_date)
ORDER BY EXTRACT(month from hire_date);

/*15.Queremos un listado del promedio de edad de los empleados por region*/

SELECT region_description, EXTRACT(year from AVG(AGE(CURRENT_DATE, birth_date)))
FROM employees JOIN employee_territories USING (employee_id)
	 JOIN territories USING (territory_id)
	 JOIN region USING (region_id)
GROUP BY region_description;

/*16.Queremos un listado de los pedidos los cuales tardaron en ser enviados menos de 11 días*/

SELECT order_id, AGE(shipped_date, order_date)
FROM orders
WHERE AGE(shipped_date, order_date) < '11 d';

/*17.Queremos un listado de los años laborables pendientes por cada empleado para jubilarse,
suponiendo que se jubilarán pasado los 65 años de edad*/

SELECT employee_id, first_name, last_name, AGE(CURRENT_DATE, birth_date), 65 - EXTRACT(year from AGE(CURRENT_DATE, birth_date))
FROM employees
WHERE AGE(CURRENT_DATE, birth_date) <= '65 y';

/*18.Queremos un listado de los 5 empleados que más pronto comenzaron a trabajar y que más tiempo lleven trabajando
en la empresa, con la condición que estos sean de los 5 empleados mas rentables de la empresa, aquellos que más ventas
han realizado*/

SELECT employee_id, first_name, last_name, hire_date, COUNT(order_id)
FROM employees e JOIN orders USING (employee_id)
WHERE hire_date <= ALL (SELECT hire_date
				   		FROM employees e3
						WHERE e.employee_id = e3.employee_id
				   		ORDER BY hire_date
				   		LIMIT 5)
GROUP BY employee_id
HAVING COUNT(order_id) >= ALL(SELECT COUNT(order_id)
							  FROM employees e2 JOIN orders USING (employee_id)
						      WHERE e.employee_id = e2.employee_id
							  GROUP BY employee_id)
ORDER BY COUNT(order_id) DESC
LIMIT 5;

/*19.Queremos un listado del promedio de días disponibles para entregar un pedido, agrupando por categoria y producto*/

SELECT category_name, product_name, AVG(AGE(required_date, order_date)) AS "promedio"
FROM categories JOIN products USING (category_id)
	 JOIN order_details USING (product_id)
	 JOIN orders USING (order_id)
GROUP BY category_name, product_name, order_id;

/*20.Queremos un listado de aquellos empleados que deberían estar jubilados*/

SELECT employee_id, first_name, last_name, AGE(CURRENT_DATE, birth_date)
FROM employees
WHERE employee_id NOT IN (SELECT employee_id
						  FROM employees
						  WHERE AGE(CURRENT_DATE, birth_date) <= '65 y');

/*21.Queremos un listado del numero de pedidos por fecha para aquellos pedidos de productos nacionales destinados al extranjero
en el año 1998*/

SELECT cu.country, su.country, order_date, COUNT(order_id)
FROM customers cu JOIN orders o USING (customer_id)
	 JOIN order_details USING (order_id)
	 JOIN products USING (product_id)
	 JOIN suppliers su USING (supplier_id)
WHERE TO_CHAR(order_date, 'YYYY') = '1998'
	  AND su.country != ALL (SELECT country
							 FROM customers JOIN orders o2 USING (customer_id)
							 WHERE o2.order_id = o.order_id)
GROUP BY cu.country, su.country, order_date
ORDER BY order_date;