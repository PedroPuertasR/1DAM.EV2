DROP TABLE IF EXISTS precio;
DROP TABLE IF EXISTS entradas;
DROP TABLE IF EXISTS invitados;
DROP TABLE IF EXISTS exhibe;
DROP TABLE IF EXISTS teatros;
DROP TABLE IF EXISTS obras;
DROP TABLE IF EXISTS asiento_tipos;
DROP TABLE IF EXISTS tipos_asientos;

CREATE TABLE invitados(
	nro_invitado		serial,
	nombre				varchar(50) NOT NULL,
	categoria			varchar(50) NOT NULL,
	origen				varchar(150) NOT NULL,
	CONSTRAINT pk_invitados PRIMARY KEY (nro_invitado) 
);

CREATE TABLE teatros(
	cod_teat			smallint,
	nombre				varchar(50) NOT NULL,
	direccion			varchar(150) NOT NULL,
	cant_asientos		integer NOT NULL,
	CONSTRAINT pk_teatros PRIMARY KEY (cod_teat)
);

CREATE TABLE obras(
	cod_obra			smallint,
	nombre_obra			varchar(100) NOT NULL,
	autor				varchar(100),
	CONSTRAINT pk_obras PRIMARY KEY (cod_obra)
);

CREATE TABLE exhibe(
	cod_teat			smallint,
	fecha				date NOT NULL,
	cod_obra			smallint,
	CONSTRAINT pk_exhibe PRIMARY KEY (cod_teat, fecha)
);

ALTER TABLE exhibe ADD CONSTRAINT fk_exhibe_teatros FOREIGN KEY (cod_teat) REFERENCES teatros ON DELETE SET NULL;
ALTER TABLE exhibe ADD CONSTRAINT fk_exhibe_obras FOREIGN KEY (cod_obra) REFERENCES obras ON DELETE CASCADE;

CREATE TABLE tipos_asientos(
	tipo				smallint,
	nombre				varchar(100) NOT NULL,
	descripcion			text,
	CONSTRAINT pk_tipos_asientos PRIMARY KEY (tipo)
);

CREATE TABLE asiento_tipos(
	nro_asiento			integer,
	tipo				smallint,
	CONSTRAINT pk_asiento_tipos PRIMARY KEY (nro_asiento)
);

ALTER TABLE asiento_tipos ADD CONSTRAINT fk_asiento_tipos_tipos_asientos FOREIGN KEY (tipo) REFERENCES tipos_asientos ON DELETE CASCADE;

CREATE TABLE precio(
	cod_teat			smallint,
	fecha				date,
	tipo				smallint,
	precio				smallint,
	CONSTRAINT pk_precio PRIMARY KEY (cod_teat, fecha, tipo)
);

ALTER TABLE precio ADD CONSTRAINT fk_precio_exhibe_cod_teatro FOREIGN KEY (cod_teat, fecha) REFERENCES exhibe ON DELETE CASCADE;
ALTER TABLE precio ADD CONSTRAINT fk_precio_tipos_asientos FOREIGN KEY (tipo) REFERENCES tipos_asientos ON DELETE SET NULL;

CREATE TABLE entradas(
	cod_teat			smallint,
	fecha				date,
	nro_asiento			integer,
	nro_invit			integer,
	CONSTRAINT pk_entradas PRIMARY KEY (cod_teat, fecha, nro_asiento)
);

ALTER TABLE entradas ADD CONSTRAINT fk_entradas_exhibe_cod_teatro FOREIGN KEY (cod_teat, fecha) REFERENCES exhibe ON DELETE CASCADE;
ALTER TABLE entradas ADD CONSTRAINT fk_entradas_asientos_tipos FOREIGN KEY (nro_asiento) REFERENCES asiento_tipos;
ALTER TABLE entradas ADD CONSTRAINT fk_entradas_invitados FOREIGN KEY (nro_invit) REFERENCES invitados ON DELETE SET NULL;