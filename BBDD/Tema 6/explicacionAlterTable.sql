CREATE TABLE autor(
	dni					varchar(9),
	nombre				varchar NOT NULL,
	nacionalidad		varchar
);

ALTER TABLE autor ADD CONSTRAINT pk_autor PRIMARY KEY (dni);

CREATE TABLE editorial(
	cod_editorial		smallserial,
	nombre				varchar NOT NULL,
	direccion			varchar,
	poblacion			varchar
);

ALTER TABLE editorial ADD CONSTRAINT pk_editorial PRIMARY KEY (cod_editorial);

CREATE TABLE genero(
	id_genero			smallserial,
	nombre				varchar NOT NULL,
	descripcion			text
);

ALTER TABLE genero ADD CONSTRAINT pk_genero PRIMARY KEY (id_genero);

CREATE TABLE libro(
	isbn				varchar(13),
	titulo				text NOT NULL,
	dni_autor			varchar(9) NOT NULL,
	cod_genero			smallint NOT NULL,
	cod_editorial		smallint NOT NULL
);

ALTER TABLE libro ADD CONSTRAINT pk_libro PRIMARY KEY (isbn);
ALTER TABLE libro ADD CONSTRAINT fk_libro_autor FOREIGN KEY (dni_autor) REFERENCES autor ON DELETE CASCADE;
ALTER TABLE libro ADD CONSTRAINT fk_libro_genero FOREIGN KEY (cod_genero) REFERENCES genero;
ALTER TABLE libro ADD CONSTRAINT fk_libro_editorial FOREIGN KEY (cod_editorial) REFERENCES editorial;

CREATE TABLE edicion(
	isbn				varchar(13),
	fecha_publicacion	date,
	cantidad			int
);

ALTER TABLE edicion ADD CONSTRAINT pk_edicion PRIMARY KEY (isbn, fecha_publicacion);
ALTER TABLE edicion ADD CONSTRAINT fk_edicion_libro FOREIGN KEY (isbn) REFERENCES libro ON DELETE CASCADE;
ALTER TABLE edicion ADD CONSTRAINT ck_cantidad_edicion CHECK (cantidad > 0);