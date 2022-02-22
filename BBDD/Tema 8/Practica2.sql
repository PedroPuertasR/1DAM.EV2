-- Ejercicio 1

CREATE OR REPLACE FUNCTION mostrarOcupantes(vuelo integer)
RETURNS numeric AS
$$
	SELECT COUNT(id_cliente)
	FROM reserva
	WHERE $1 = id_vuelo
$$ LANGUAGE sql;

-- Ejercicio 2

CREATE OR REPLACE FUNCTION mostrarReservas(vuelo integer)
RETURNS numeric AS
$$
	SELECT COUNT(id_reserva)
	FROM reserva
	WHERE $1 = id_vuelo
$$ LANGUAGE sql;

-- aeropuerto de salida, ciudad de salida, fecha y hora de salida, aeropuerto de llegada, ciudad de llegada,
-- fecha y hora de llegada, nº máximo de pasajeros del avión, nº de reservas que hay actualmente

CREATE OR REPLACE FUNCTION mostrarVuelos(fecha date, ciudad varchar)
RETURNS TABLE (salida integer,
			   salidaciudad varchar,
			   fechasalida timestamp,
			   llegada integer,
			   llegadaciudad varchar,
			   fechallegada timestamp,
			   pasajeros numeric,
			   reservas numeric) AS
$$
	SELECT a2.id_aeropuerto, a2.ciudad, salida, a1.id_aeropuerto, a1.ciudad, llegada,
		   max_pasajeros, mostrarReservas(id_vuelo)
	FROM vuelo JOIN aeropuerto a1 ON (hasta = a1.id_aeropuerto)
	 	 JOIN aeropuerto a2 ON (desde = a2.id_aeropuerto)
		 JOIN avion USING (id_avion)
	WHERE ($2 = a2.ciudad OR $2 = a1.ciudad)
		  OR ($1 = llegada OR $1 = salida)
$$ LANGUAGE sql;

-- Ejercicio 3

/*
En la misma base de datos, crea una función que nos permita crear un nuevo vuelo. Debe recibir como argumento: 
ciudad de salida, ciudad de llegada, fecha y hora de salida, fecha y hora de llegada, precio y descuento. 
Debe insertar una nueva fila en vuelo, obteniendo el ID de los aeropuertos a partir de sus nombres, y estableciendo un avión aleatorio 
(puedes consultar cómo obtener una fila aleatoria de una tabla en este enlace: 
http://blog.jmacoe.com/gestion_ti/base_de_datos/sql-para-seleccionar-una-fila-aleatoriamente/ 
*/

SELECT *
FROM vuelo;

CREATE OR REPLACE FUNCTION crearVuelo(ciudadSalida varchar(100), ciudadLlegada varchar(100), fechaSalida timestamp, fechaLlegada timestamp,
									  precio numeric, descuento integer)
RETURNS integer AS
$$
	INSERT INTO vuelo (desde, hasta, salida, llegada, precio, descuento, id_avion)
	VALUES ((SELECT id_aeropuerto
			 FROM aeropuerto
			 WHERE $1 = ciudad),
		    (SELECT id_aeropuerto
			 FROM aeropuerto
			 WHERE $2 = ciudad),
		    $3, $4, $5, $6, (SELECT id_avion 
							FROM avion
							ORDER BY RANDOM()
							LIMIT 1))
	RETURNING (SELECT id_vuelo
			   FROM vuelo
			   ORDER BY id_vuelo DESC
			   LIMIT 1)
$$ LANGUAGE sql;

SELECT *
FROM vuelo;

SELECT mostrarOcupantes(1);
SELECT * FROM mostrarVuelos('2019-12-10', 'Sevilla');
SELECT crearVuelo('Sevilla', 'París', MAKE_DATE(2022, 10, 04), MAKE_DATE(2022, 10, 05), 250.35, 20);