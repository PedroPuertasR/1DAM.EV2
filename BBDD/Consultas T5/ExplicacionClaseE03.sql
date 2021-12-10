SELECT *
FROM employees 
WHERE (salary, job_id) = (SELECT salary, job_id
						  FROM employees
						  WHERE first_name = 'Lex'
						  		AND last_name = 'De Haan'
						 );
						 
-- Seleccionar los datos de aquellos empleados que cobran lo mismo y tienen el mismo puesto que los 
-- empleados del departamento ejecutivo o de contabilidad.

SELECT *
FROM employees
WHERE (salary, job_id) IN (SELECT salary, job_id
						   FROM departments JOIN employees USING (department_id)
						   WHERE department_name IN ('Executive', 'Accounting')
						  );