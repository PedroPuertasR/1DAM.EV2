/*
6) Queremos saber cual es el proveedor que ha proporcionado ,en promedio, 
más productos que el proveedor que en promedio ha proporcionado menos productos
*/

SELECT s.company_name, ROUND(AVG(o.quantity),2) AS "promedio"
FROM suppliers s JOIN products USING (supplier_id)
	 JOIN order_details o USING (product_id)
GROUP BY s.company_name
HAVING ROUND(AVG(o.quantity),2) > ALL (SELECT ROUND(AVG(o2.quantity), 2) AS "promedio_dos"
					   				   FROM suppliers s2 JOIN products USING (supplier_id)
					   						JOIN order_details o2 USING (product_id)
					   				   GROUP BY s2.company_name
					   				   ORDER BY promedio_dos
					   				   LIMIT 1
					   				  )
ORDER BY promedio
LIMIT 1;

/*
7) Para tener control sobre la tendencia de provisionamiento (en cuanto a unidades se refiere) de los proveedores y 
poder descartar aquellos que no son aptos, hemos de tener un listado de los que si lo son. 
Se considera que un proveedor es apto si el promedio de unidades que ha proporcionado es superior al promedio total de unidades vendidas
*/

SELECT s.company_name, ROUND(AVG(o.quantity),2) AS "promedio"
FROM suppliers s JOIN products USING (supplier_id)
	 JOIN order_details o USING (product_id)
GROUP BY s.company_name
HAVING ROUND(AVG(o.quantity),2) > ALL (SELECT ROUND(AVG(o2.quantity),2)
									 FROM suppliers s2 JOIN products USING (supplier_id)
									 	  JOIN order_details o2 USING (product_id)
									);

/*
8) Para tener control sobre los beneficios de los proveedores y poder asi descartar aquellos no aptos,
hemos de tener un listado de los que son aptos.
Se considera que un proveedor es apto si las ventas obtenidas por el mismo es inferior al 2% de las ventas totales
*/

SELECT s.company_name, ROUND(SUM(o.quantity * (o.unit_price - o.unit_price * o.discount))::numeric,2) || ' €' AS "ventas"
FROM suppliers s JOIN products USING (supplier_id)
	 JOIN order_details o USING (product_id)
GROUP BY s.company_name
HAVING SUM(o.quantity * (o.unit_price - o.unit_price * o.discount)) 
				< ALL (SELECT 0.02 * (ROUND(SUM(o2.quantity * (o2.unit_price - o2.unit_price * o2.discount))::numeric, 2))
					   FROM suppliers JOIN products USING (supplier_id)
	 				   JOIN order_details o2 USING (product_id)
					  )
ORDER BY ventas;


/*
9) Queremos saber que proveedores son aptos en cuanto a provisionamiento de unidades así como en cuanto a beneficio obtenido
*/

SELECT s.company_name, SUM(o.quantity) AS "total_ventas", ROUND(SUM(o.quantity*o.unit_price*(1-discount))::numeric,2) AS "beneficio"
FROM suppliers s JOIN products USING (supplier_id)
  JOIN order_details o USING (product_id)
GROUP BY s.company_name
HAVING ROUND(SUM(o.quantity*o.unit_price*(1-discount))::numeric,2) < ALL (SELECT ROUND(SUM(quantity*unit_price*(1-discount))::numeric*2/100,2)
 FROM order_details)
   AND ROUND(AVG(o.quantity),2) >= ALL (SELECT AVG(quantity)
FROM order_details)
ORDER BY beneficio ASC;


/*
10.Queremos un listado de los proveedores y de la variedad de productos provistos por los mismos, cuyos precios sobrepasan
el promedio del precio de los productos provistos por dicho proveedor en dichas categorias
*/
SELECT *
FROM products;

SELECT s.company_name, COUNT(DISTINCT(pr.product_name))
FROM suppliers s JOIN products pr USING (supplier_id)
	 JOIN order_details o USING (product_id)
WHERE o.unit_price > ALL (SELECT AVG(o2.unit_price)
					    FROM suppliers s2 JOIN products pr2 USING (supplier_id)
	 						 JOIN order_details o2 USING (product_id)
					    WHERE pr.category_id = pr2.category_id)
GROUP BY s.company_name
ORDER BY s.company_name;

/*
11.Queremos potenciar las ventas de aquellas categorias de productos menos demandadas. 
Para ello necesitamos tener un listado por categorias y fecha del numero de productos vendidos
*/

SELECT category_name, order_date, COUNT(order_id)
FROM categories JOIN products USING (category_id)
	 JOIN order_details USING (product_id)
	 JOIN orders USING (order_id)
GROUP BY category_name, order_date;

/*
12.Listado de empresas de mensajeria que han cubierto cada región
*/

SELECT DISTINCT company_name, region_description
FROM region JOIN territories USING (region_id)
	 JOIN employee_territories USING (territory_id)
	 JOIN orders USING (employee_id)
	 JOIN shippers ON (ship_via = shipper_id);