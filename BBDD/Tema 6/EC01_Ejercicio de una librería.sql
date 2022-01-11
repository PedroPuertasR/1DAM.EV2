CREATE TABLE libro(
	isbn				char(13),
	titulo				varchar,
	dni					char(9),
	cod_genero			smallint,
	cod_editorial		smallint
);

CREATE TABLE autor(
	dni					char(9),
	nombre				varchar,
	nacionalidad		varchar
);

CREATE TABLE editorial(
	cod_editorial		serial,
	nombre				varchar,
	direccion			varchar,
	poblacion			varchar
);

CREATE TABLE genero(
	id_genero			serial,
	nombre				varchar,
	descripcion			varchar
);

CREATE TABLE edicion(
	isbn				char(13),
	fecha_publicacion	date,
	cantidad			smallint
);