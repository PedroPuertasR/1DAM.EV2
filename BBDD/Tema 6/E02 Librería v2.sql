CREATE TABLE libro(
	isbn				varchar(13),
	titulo				text NOT NULL,
	dni_autor			varchar(9) NOT NULL,
	cod_genero			smallint NOT NULL,
	cod_editorial		smallint NOT NULL,
	CONSTRAINT pk_libro PRIMARY KEY (isbn),
	CONSTRAINT fk_libro_autor FOREIGN KEY (dni_autor) REFERENCES autor ON DELETE RESTRICT,
	CONSTRAINT fk_libro_genero FOREIGN KEY (cod_genero) REFERENCES genero ON DELETE SET NULL,
	CONSTRAINT fk_libro_editorial FOREIGN KEY (cod_editorial) REFERENCES editorial ON DELETE SET NULL
);

CREATE TABLE autor(
	dni					varchar(9),
	nombre				varchar NOT NULL,
	nacionalidad		varchar,
	CONSTRAINT pk_autor PRIMARY KEY (dni)
);

CREATE TABLE editorial(
	cod_editorial		smallserial,
	nombre				varchar NOT NULL,
	direccion			varchar,
	poblacion			varchar,
	CONSTRAINT pk_editorial PRIMARY KEY (cod_editorial)
);

CREATE TABLE genero(
	id_genero			smallserial,
	nombre				varchar NOT NULL,
	descripcion			text,
	CONSTRAINT pk_genero PRIMARY KEY (id_genero)
);

CREATE TABLE edicion(
	isbn				varchar(13),
	fecha_publicacion	date,
	cantidad			int,
	CONSTRAINT pk_edicion PRIMARY KEY (isbn, fecha_publicacion),
	CONSTRAINT fk_edicion_libro FOREIGN KEY (isbn) REFERENCES libro ON DELETE CASCADE,
	CONSTRAINT cantidad_positiva CHECK (cantidad > 0)
);