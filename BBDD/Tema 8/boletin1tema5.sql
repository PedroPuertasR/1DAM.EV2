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

-- Seleccionar el salario más alto cobrado a la vez por más personas.

SELECT salary, COUNT(employee_id) AS "empleados"
FROM employees
GROUP BY salary
ORDER BY empleados DESC, salary DESC
LIMIT 1;

-- Usando subconsultas seleccionar el menor salario de los empleados

SELECT salary
FROM (SELECT salary
	  FROM employees
	  GROUP BY salary
	  ORDER BY salary
	  LIMIT 1) datos;
	
	
-- listar los empleados, nombre y salario cuya remuneracion es inferior al promedio esperado para su puesto

SELECT *
FROM jobs;

SELECT *
FROM employees;

SELECT first_name, last_name, salary || ' €' AS "salario"
FROM employees JOIN jobs j1 USING (job_id)
WHERE salary < (SELECT (min_salary + max_salary)/2
				FROM jobs j2
				WHERE j1.job_id = j2.job_id);


-- Seleccionar el salario que es cobrado a la vez por más personas. Mostrar dicho salario y el número de personas. CON WITH

WITH agrupacion AS (
	SELECT salary || ' €' AS "salario", COUNT(employee_id) AS "empleados"
	FROM employees
	GROUP BY salary
	ORDER BY empleados DESC, salary DESC
	LIMIT 1
)
SELECT *
FROM agrupacion;