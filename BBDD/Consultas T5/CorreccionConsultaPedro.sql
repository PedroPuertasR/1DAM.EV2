-- Si suponemos que nuestro margen de beneficio con los productos es de un 25% (es decir, el 25% de su precio,
-- son beneficios, y el 75% son costes), calcular la cantidad de beneficio que hemos obtenido, 
-- agrupado por (nombre de) categoría y (nombre de) producto, siempre que el producto empiece por P o contenga una h.
-- Las cantidades deben redondearse a dos decimales. Recuerda que en cada línea de pedido (order_details)
-- tienes el número de unidades que se piden de ese producto, y el precio de una unidad.

-- Corrección

SELECT DISTINCT category_name, product_name, ROUND(SUM(ord.unit_price * 25/100 
												   * quantity * (1-discount))::numeric,2) || ' €' AS "beneficio"
FROM order_details ord JOIN products USING (product_id)
	 JOIN categories USING (category_id)
WHERE (product_name ILIKE 'p%')
	  OR product_name ILIKE '%h%'
GROUP BY category_name, product_name
ORDER BY category_name;