DROP TABLE IF EXISTS venta, empleado, cliente, producto, linea_venta, categoria;

CREATE TABLE empleado(
	num_empleado			serial,
	nombre					varchar(100) NOT NULL,
	apellidos				varchar(100) NOT NULL,
	email					varchar(100),
	cuenta_corriente		varchar(24),
	pass					varchar(8),
	CONSTRAINT pk_empleado PRIMARY KEY (num_empleado),
	CONSTRAINT ck_email_arroba CHECK (email ILIKE '%@%'),
	CONSTRAINT ck_cuenta_es CHECK (cuenta_corriente ILIKE 'ES%')
);

CREATE TABLE venta(
	id_venta				serial,
	fecha					date NOT NULL,
	empleado				integer NOT NULL,
	cliente					varchar(10),
	CONSTRAINT pk_venta PRIMARY KEY (id_venta),
	CONSTRAINT fk_venta_empleado FOREIGN KEY (empleado) REFERENCES empleado
	--No se haría nada para respetar la venta y que se quede en el histórico
);

CREATE TABLE cliente(
	dni						varchar(10),
	nombre					varchar(100) NOT NULL,
	apellidos				varchar(100) NOT NULL,
	email					varchar(100),
	direccion				varchar(100),
	fecha_alta				date,
	CONSTRAINT pk_cliente PRIMARY KEY (dni),
	CONSTRAINT ck_email_arroba CHECK (email ILIKE '%@%')
);

ALTER TABLE venta ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente) REFERENCES cliente;
--Tampoco se haría nada para llevar el histórico de la venta

CREATE TABLE producto(
	cup						serial,
	nombre					varchar(100) NOT NULL,
	descripcion				text,
	pvp						numeric(10,2) NOT NULL,
	categoria				integer,
	CONSTRAINT pk_producto PRIMARY KEY (cup),
	CONSTRAINT ck_categoria_maximo CHECK (categoria < 10 AND categoria > 0)
);

CREATE TABLE categoria(
	id_categoria			serial,
	nombre					varchar(100) NOT NULL,
	descripcion				text,
	CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

ALTER TABLE producto ADD CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria) REFERENCES categoria ON DELETE SET NULL;
--Set a null ya que el producto no tiene por qué desaparecer si desaparece la categoría

CREATE TABLE linea_venta(
	id_venta				integer,
	id_linea				serial,
	cantidad				smallint NOT NULL,
	producto				integer NOT NULL,
	precio					numeric(10,2) NOT NULL,
	CONSTRAINT pk_linea_venta PRIMARY KEY (id_venta, id_linea),
	CONSTRAINT fk_linea_venta_venta FOREIGN KEY (id_venta) REFERENCES venta ON DELETE CASCADE,
	CONSTRAINT fk_linea_venta_producto FOREIGN KEY (producto) REFERENCES producto ON DELETE CASCADE
);

INSERT INTO EMPLEADO VALUES (
    DEFAULT,
    'ANGEL',
    'NARANJO',
    'ANGEL.NARANJO@MITIENDA.ES',
    'ES1234567890123456789012',
    '12345'
);

INSERT INTO EMPLEADO VALUES (
    DEFAULT,
    'MIGUEL',
    'CAMPOS',
    'MIGUEL.CAMPOS@MITIENDA.ES',
    'ES9087564312213465780937',
    'USER1234'
);

INSERT INTO CLIENTE VALUES (
    '12345678A',
    'JESÚS',
    'CASANOVA',
    'JESUS.CASANOVA@CORREO.COM',
    'C/ CONDES DE BUSTILLO S/N',
    CURRENT_DATE
);

INSERT INTO CATEGORIA VALUES (
    DEFAULT,
    'Macbook',
    'Todos los modelos de Macbook'
);

INSERT INTO CATEGORIA VALUES (
    DEFAULT,
    'Iphone',
    'Todos los modelos de Iphone'
);

INSERT INTO CATEGORIA VALUES (
    DEFAULT,
    'Apple Watch',
    'Todos los modelos de Apple Watch'
);


INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Macbook Pro 13" Chip M1 8/8 8GB 265GB',
    'Chip M1, con 8 núcleos de CPU y 8 de GPU, 8 GB de memoria unificada y 256 GB de almacenamiento SSD',
    1449.0,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Macbook')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Macbook Pro 14" Chip M1 Pro 8/14 16GB/512GB',
    'Chip M1 Pro, con 8 núcleos de CPU, 14 de GPU, 16 GB de RAM y 512 GB de almacenamiento SSD',
    2249.0,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Macbook')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Macbook Pro 16" Chip M1 Max 10/32 32GB/1TB',
    'Chip M1 Max, con 10 núcleos de CPU, 32 de GPU, 32 GB de RAM y 1TB de almacenamiento SSD',
    3849.0,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Macbook')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'iPhone Xs 5,8" 64GB',
    'Acabado en plata',
    1159,
    2
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'iPhone 13 Mini 5,4" 128GB',
    'Acabado medianoche',
    809.0,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Iphone')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'iPhone 13 Pro Max 6,7" 1TB',
    'Acabado en grafito',
    1839.0,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Iphone')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Apple Watch Serie 7 41 mm',
    'Caja de aluminio verde y correa con eslabones de piel',
    479,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Apple Watch')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Apple Watch SE 40mm',
    'Caja de aluminio en gris espacial - correa deportiva',
    299,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Apple Watch')
);

INSERT INTO PRODUCTO VALUES (
    DEFAULT,
    'Apple Watch Nike 45mm',
    'Caja de aluminio en plata y correa Nike Sport platino puro/negra',
    459,
    (SELECT ID_CATEGORIA FROM CATEGORIA WHERE nombre = 'Apple Watch')
);

INSERT INTO venta (fecha, empleado, cliente)
VALUES(CURRENT_DATE, 1, '12345678A');

INSERT INTO linea_venta(id_venta, cantidad, producto, precio)
VALUES(1, 1, 2, 2249.00);

INSERT INTO cliente
VALUES ('25123568F', 'Rafael', 'Villar', 'rafael.villar@correo.com', 'Calle Rue del Percebe 13', CURRENT_DATE);

INSERT INTO venta(fecha, empleado, cliente)
VALUES(CURRENT_DATE, 2, '25123568F');

INSERT INTO linea_venta(id_venta, cantidad, producto, precio)
VALUES(2, 1, 9, 459.00);

CREATE TABLE resumen_mensual_ventas(
	id_cliente			integer,
	nombre				varchar(200) NOT NULL,
	mes					varchar(20),
	importe_total		numeric(10,2),
	CONSTRAINT pk_resumen_mensual_ventas PRIMARY KEY (id_cliente, mes, importe_total)
	--CONSTRAINT fk_resumen_cliente FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE
);



SELECT*
FROM producto;