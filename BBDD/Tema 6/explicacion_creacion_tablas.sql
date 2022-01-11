CREATE TABLE my_first_table(
	first_colum 		text,
	second_colum		integer
);

CREATE TABLE productos(
	num_producto		serial,
	nombre				text,
	precio				numeric DEFAULT 9.99,
	fecha_alta			timestamp DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE televisores;

SELECT *
FROM televisores;

INSERT INTO televisores (nombre, diagonal_in)
VALUES('LG MPEV 56', 56);

CREATE TABLE televisores(
	id_tv				serial,
	nombre				varchar(200),
	diagonal_in			numeric,
	diagonal_cm			numeric GENERATED ALWAYS AS (diagonal_in * 2.54) STORED
);