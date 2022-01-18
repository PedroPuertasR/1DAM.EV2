CREATE TABLE producto(
	num_producto		integer,
	nombre				text,
	precio				numeric,
	CONSTRAINT pk_producto PRIMARY KEY (num_producto)
);

-- Insertar fila en la tabla.

INSERT INTO producto
VALUES(1, 'Bocata de jamón', 2);

-- Tenemos que poner los valores en el orden que están en la tabla.

INSERT INTO producto
VALUES(1, 'Bocata de jamón', 2), (2, 'Carpa', 25);

-- También podemos poner una copa después de la primera fila para incorporar una segunda.

CREATE TABLE climatologia_media_mensual(
	mes					varchar(15),
	mes_num				smallint,
	estacion			varchar(255),
	provincia			varchar(255),
	media				numeric,
	CONSTRAINT pk_climatologia_media_mensual PRIMARY KEY (mes_num, estacion, provincia)
);

INSERT INTO climatologia_media_mensual
SELECT TO_CHAR(fecha, 'TMMonth'),
	   EXTRACT(month FROM fecha),
	   estacion, provincia, ROUND(AVG(temperatura_media),2)
FROM climatologia
GROUP BY TO_CHAR(fecha, 'TMMonth'),
	   EXTRACT(month FROM fecha),
	   estacion, provincia;
	   