-- Ejercicio 1

SELECT department_name, MAX(salary)
FROM departments JOIN employees USING (department_id)
GROUP BY department_name;

-- Ejercicio 2

SELECT department_name, MIN(salary)
FROM departments JOIN employees USING (department_id)
GROUP BY department_name
HAVING MIN(salary) < 5000;

-- Ejercicio 3

SELECT COUNT(employee_id), street_address
FROM departments JOIN employees USING (department_id)
	 JOIN locations USING (location_id)
GROUP BY location_id, street_address
ORDER BY COUNT(employee_id) DESC;

-- Ejercicio 4

SELECT COUNT(employee_id), street_address
FROM departments JOIN employees USING (department_id)
	 RIGHT JOIN locations USING (location_id)
GROUP BY street_address
ORDER BY COUNT(employee_id) DESC;

-- Ejercicio 5

SELECT salary, COUNT(employee_id) AS "numero_empleados"
FROM employees
GROUP BY salary
ORDER BY COUNT(employee_id) DESC, salary DESC;

-- Ejercicio 6

SELECT COUNT(employee_id) "empleados", EXTRACT(year from hire_date) "anio"
FROM employees
GROUP BY EXTRACT(year from hire_date)
ORDER BY anio;