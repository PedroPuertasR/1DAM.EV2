SELECT *
FROM vuelos;

CREATE OR REPLACE FUNCTION modificarPrecio(nuevo numeric)
RETURNS integer AS $$
	DECLARE
		id_vuelo integer;
	BEGIN
		UPDATE vuelos SET precio = $1 WHERE precio <= 100;
		SELECT COUNT(id) INTO id_vuelo FROM vuelos WHERE precio = $1;
		RETURN id_vuelo;
	END;
$$ LANGUAGE plpgsql;

SELECT modificarPrecio(110);

CREATE OR REPLACE FUNCTION exportar ()
RETURNS boolean AS $$
BEGIN
	COPY (SELECT * FROM vuelos) TO 'C:\Users\puertas.roped22\Desktop\practicaSQL1.csv' WITH CSV;
	RETURN true;
END;
$$ LANGUAGE plpgsql;

SELECT exportar();