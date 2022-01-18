CREATE TABLE usuarios(
	dni					varchar(10) NOT NULL,
	nombre				varchar(100) NOT NULL,
	apellidos			varchar(100) NOT NULL,
	direccion			varchar(200),
	telefono			varchar(12) NOT NULL,
	email				varchar(50) NOT NULL,
	passw				numeric(8) DEFAULT 4,
	saldo_disponible	numeric NOT NULL DEFAULT 0,
	CONSTRAINT pk_usuarios PRIMARY KEY (dni)
);

CREATE TABLE estaciones(
	cod_estacion		varchar(50),
	num_estacion		serial NOT NULL, 
	direccion			varchar(200) NOT NULL,
	latitud				integer NOT NULL,
	longitud			integer NOT NULL,
	CONSTRAINT ck_cod_estacion_e CHECK (cod_estacion LIKE 'E%'),
	CONSTRAINT pk_estaciones PRIMARY KEY (cod_estacion)
);

CREATE TABLE bicicletas(
	cod_bicicleta		smallint,
	marca				varchar(100) NOT NULL,
	modelo				varchar(100) NOT NULL,
	fecha_alta			date NOT NULL,
	CONSTRAINT pk_bicicletas PRIMARY KEY (cod_bicicleta)
);

CREATE TABLE uso(
	estacion_salida		varchar(50),
	fecha_salida		timestamp,
	dni_usuario			varchar(10),
	cod_bicicleta		smallint,
	estacion_llegada	varchar(50),
	fecha_llegada		timestamp NOT NULL,
	CONSTRAINT pk_uso PRIMARY KEY (estacion_salida, fecha_salida, dni_usuario, cod_bicicleta, estacion_llegada),
	CONSTRAINT fk_uso_estacion_salida FOREIGN KEY (estacion_salida) REFERENCES estaciones,
	CONSTRAINT fk_uso_usuarios FOREIGN KEY (dni_usuario) REFERENCES usuarios,
	CONSTRAINT fk_uso_bicicletas FOREIGN KEY (cod_bicicleta) REFERENCES bicicletas,
	CONSTRAINT fk_uso_estacion_llegada FOREIGN KEY (estacion_llegada) REFERENCES estaciones
);

INSERT INTO usuarios
VALUES ('25185475S', 'Jorge', 'Valero Gómez', 'Calle ruavieja 20', '652123415', 'jorgevagom@outlook.es', 12355, 50),
	   ('58447125G', 'Marcos', 'Jiménez Domínguez', 'Calle albarán 12', '65293657', 'marquinhojd92@hotmail.com', 5527, 22),
	   ('53321142Z', 'Alfonso', 'López Blanco', 'Calle dos caminos 8', '624583521', 'alfonwhite@yahoo.es', 8832, 15);
	   
INSERT INTO estaciones (cod_estacion, direccion, latitud, longitud)
VALUES ('EST', 'Calle ruavieja 2', 250722, 192952),
	   ('EZX', 'Calle Hamilton 24', 141750, 396218),
	   ('ESE', 'Calle Dos Santos 18', 145260, 251829);
	   
INSERT INTO bicicletas
VALUES (1, 'BMW', '360 BMX L', '30-12-2020'),
	   (2, 'BMW', 'xTreme Mount 12', '12-04-2020'),
	   (3, 'BMW', 'Tour DaFr 1400', '15-08-2020'),
	   (4, 'BMW', 'Solid Green L14', '06-03-2020'),
	   (5, 'Artengo', 'Vibranium 3000', '09-11-2020'),
	   (6, 'Artengo', 'Fimonsus XL 50', '24-06-2020'),
	   (7, 'Artengo', 'Jabali ash xP', '30-05-2020');
	   
INSERT INTO uso
VALUES ('EST', '12-08-2021', '25185475S', 1, 'EZX', '13-08-2021'),
	   ('ESE', '20-04-2021', '25185475S', 5, 'EZX', '20-04-2021'),
	   ('ESE', '19-06-2021', '58447125G', 4, 'EST', '19-06-2021');
	   
ALTER TABLE usuarios ADD COLUMN fecha_baja date;

INSERT INTO estaciones (cod_estacion, direccion, latitud, longitud)
VALUES ('ESJ', 'Calle San Jacinto', 526987, 265214),
	   ('EPP', 'Parque de los Principes', 256332, 211125);
	   
INSERT INTO uso
VALUES ('ESJ', '11-02-2020 13:35:00', '53321142Z', 7, 'EPP', '11-02-2020 13:43:00');