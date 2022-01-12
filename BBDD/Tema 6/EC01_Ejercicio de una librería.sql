CREATE TABLE libro(
	isbn				varchar(13),
	titulo				text,
	dni_autor			varchar(9),
	cod_genero			smallint,
	cod_editorial		smallint
);

CREATE TABLE autor(
	dni					varchar(9),
	nombre				varchar,
	nacionalidad		varchar
);

CREATE TABLE editorial(
	cod_editorial		smallserial,
	nombre				varchar,
	direccion			varchar,
	poblacion			varchar
);

CREATE TABLE genero(
	id_genero			smallserial,
	nombre				varchar,
	descripcion			text
);

CREATE TABLE edicion(
	isbn				varchar(13),
	fecha_publicacion	date,
	cantidad			int
);