CREATE OR REPLACE FUNCTION eliminarAeropuerto()
RETURNS void AS $$
	DELETE FROM aeropuerto WHERE ciudad = 'Sevilla'
$$ LANGUAGE sql;

SELECT eliminarAeropuerto();

CREATE OR REPLACE FUNCTION insertarAeropuerto(id_aero integer, nombre varchar, ciudad varchar)
RETURNS void AS $$
	INSERT INTO aeropuerto (id_aeropuerto, nombre, ciudad) VALUES ($1, $2, $3);
$$ LANGUAGE sql;

SELECT insertarAeropuerto(12, 'Pisa', 'Italia');
SELECT insertarAeropuerto(1, 'San Pablo', 'Sevilla');

SELECT *
FROM aeropuerto;

CREATE OR REPLACE FUNCTION sumarValores(valor1 int, valor2 int)
RETURNS int AS $$
BEGIN
	RETURN $1 + $2;
END;
$$ LANGUAGE plpgsql;

SELECT sumarValores(1,10);