DROP TABLE IF EXISTS usuarios, marcas, variantes, categorias, productos, precios, carritos, empleados, departamentos, pedidos;

CREATE TABLE usuarios (
	id				serial,
	nombre			varchar(30) NOT NULL,
	apellidos		varchar(50) NOT NULL,
	dni				varchar(9) NOT NULL UNIQUE,
	direccion		varchar(150) NOT NULL,
	telefono		varchar(13) NOT NULL,
	email			varchar(255) NOT NULL UNIQUE,
	CONSTRAINT pk_usuarios PRIMARY KEY(id),
	CONSTRAINT ck_email_arroba CHECK (email ILIKE '%@%'),
	CONSTRAINT ck_dni_longitud CHECK (LENGTH(dni)=9),
	CONSTRAINT ck_dni_letra CHECK (dni ~ '\d{8}[A-Z]|[a-z]')
);

CREATE TABLE marcas (
	id				serial,
	nombre			varchar(30) NOT NULL UNIQUE,
	CONSTRAINT pk_marcas PRIMARY KEY (id)
);

CREATE TABLE variantes (
	id				serial,
	nombre			varchar(50) NOT NULL UNIQUE,
	descripcion		text,
	CONSTRAINT pk_variantes PRIMARY KEY (id)
);

CREATE TABLE categorias (
	id				serial,
	nombre			varchar(50) NOT NULL,
	descripcion		text,
	id_variante		int,
	CONSTRAINT pk_categorias PRIMARY KEY (id)
);

CREATE TABLE productos (
	id				serial,
	nombre			varchar(50) NOT NULL,
	descripcion		text,
	id_marca		int,
	id_categoria	int,
	CONSTRAINT pk_productos PRIMARY KEY(id)
);

CREATE TABLE precios (
	id				serial,
	cantidad		numeric NOT NULL,
	fecha			date NOT NULL,
	id_producto		int,
	CONSTRAINT pk_precios PRIMARY KEY(id),
	CONSTRAINT ck_cantidad_cero CHECK (cantidad>=0)
	--CONSTRAINT ck_restriccion_fecha CHECK (fecha >= CURRENT_DATE)
);

CREATE TABLE carritos (
	id				serial,
	cantidad		smallint,
	id_usuario		int,
	id_producto		int,
	CONSTRAINT pk_carritos PRIMARY KEY(id),
	CONSTRAINT ck_cantidad_cero CHECK (cantidad>=0)
);

CREATE TABLE departamentos (
	id				serial,
	nombre			varchar(50) NOT NULL UNIQUE,
	CONSTRAINT pk_departamentos PRIMARY KEY(id)
);

CREATE TABLE empleados (
	id					serial,
	nombre				varchar(30) NOT NULL,
	apellidos			varchar(50) NOT NULL,
	dni					varchar(9) NOT NULL UNIQUE,
	direccion			varchar(150) NOT NULL,
	telefono			varchar(13) NOT NULL,
	email				varchar(255) NOT NULL UNIQUE,
	num_seg_social		bigint NOT NULL UNIQUE,
	id_departamento		int,
	CONSTRAINT pk_empleados PRIMARY KEY(id),
	CONSTRAINT ck_email_arroba CHECK (email ILIKE '%@%'),
	CONSTRAINT ck_dni_longitud CHECK (LENGTH(dni)=9),
	CONSTRAINT ck_dni_letra CHECK (dni ~ '\d{8}[A-Z]|[a-z]')
);

CREATE TABLE pedidos (
	id				serial,
	descuento		numeric DEFAULT 0.0,
	fecha			date,
	id_carrito		int,
	id_empleado		int,
	CONSTRAINT pk_pedidos PRIMARY KEY(id),
	CONSTRAINT ck_restriccion_fecha CHECK (fecha >= CURRENT_DATE),
	CONSTRAINT ck_limites_descuento CHECK (descuento>=0 AND descuento<=100)
);

ALTER TABLE categorias ADD CONSTRAINT fk_categorias_variantes FOREIGN KEY (id_variante)
REFERENCES variantes(id) ON DELETE SET NULL;
ALTER TABLE productos ADD CONSTRAINT fk_productos_marcas FOREIGN KEY (id_marca)
REFERENCES marcas(id) ON DELETE CASCADE;
ALTER TABLE productos ADD CONSTRAINT fk_productos_categorias FOREIGN KEY(id_categoria)
REFERENCES categorias(id) ON DELETE CASCADE;
ALTER TABLE precios ADD CONSTRAINT fk_precios_productos FOREIGN KEY(id_producto)
REFERENCES productos(id) ON DELETE CASCADE;
ALTER TABLE carritos ADD CONSTRAINT fk_carritos_usuarios FOREIGN KEY(id_usuario)
REFERENCES usuarios(id) ON DELETE CASCADE;
ALTER TABLE carritos ADD CONSTRAINT fk_carritos_productos FOREIGN KEY(id_producto)
REFERENCES productos(id) ON DELETE CASCADE;
ALTER TABLE empleados ADD CONSTRAINT fk_empleados_departamentos FOREIGN KEY(id_departamento)
REFERENCES departamentos(id);
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_carritos FOREIGN KEY(id_carrito)
REFERENCES carritos(id) ON DELETE CASCADE;
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_empleados FOREIGN KEY(id_empleado)
REFERENCES empleados(id) ON DELETE SET NULL;

INSERT INTO usuarios(nombre, apellidos, dni, direccion, telefono, email)
VALUES('Manuel', 'Tejado Morilla', '25589952S', 'Pino Montano', '695852684', 'manolo@gmail.com'),
('Pedro', 'Puertas Gómez', '25585952T', 'Sevilla Este', '695852697', 'pedro@gmail.com');

INSERT INTO marcas(nombre)
VALUES ('Nike'), ('Adidas'), ('Rebook');

INSERT INTO variantes (nombre, descripcion)
VALUES ('Pantalón corto', 'Pantalón a la altura de la rodilla'), ('Pantalón largo', 'Pantalón hasta el tobillo'), 
('Pantalón invierno', 'Pantalón de buen grosor'), ('Pantalón verano', 'Pantalón de tela fina y fresca'), ('Pantalón primavera', 'Pantalón con estampado llamativo'), 
('Pantalón otoño', 'Pantalón con colores apagados'), ('Moda hombre', 'Ropa masculina'), ('Moda mujer', 'Ropa para damas');

INSERT INTO categorias(nombre, descripcion, id_variante) --el id_variante sigue el orden de los valores de variantes
VALUES ('Vaqueros', '', 1), ('Vaqueros', '', 2), ('Vaqueros', '', 3), ('Chándal', '', 1);

INSERT INTO productos(nombre, descripcion, id_marca, id_categoria)
VALUES ('Vaqueros Slim Fit', 'Unos vaqueros muy ajustados', 1, 3);

INSERT INTO precios(cantidad, fecha, id_producto)
VALUES (29.95, '2022-01-23', 1);

INSERT INTO carritos(cantidad, id_usuario, id_producto)
VALUES(2, 1, 1);

INSERT INTO departamentos(nombre)
VALUES ('Ventas'), ('Marketing'), ('Director'), ('Logística'), ('Recursos Humanos');

INSERT INTO empleados (nombre, apellidos, dni, direccion, telefono, email, num_seg_social, id_departamento) 
VALUES ('Ashil', 'Gartside', '83718203A', '53 Iowa Lane', '531234748', 'agartside0@zimbio.com', 15543652102, 1),
('Ajay', 'Durden', '23711113B', '2 Thierer Center', '866319578', 'adurden1@imgur.com', 15543652103, 2),
('Avrom', 'Beard', '64482054C', '75 Stoughton Trail', '454615265', 'abeard2@bbb.org', 15543624102, 2),
('Gusti', 'Cleve', '01281329D', '120 Morningstar Hill', '455594765', 'gcleve3@google.nl', 21543652102, 2),
('Nada', 'Ginnaly', '57691614E', '1 Brown Avenue', '309454747', 'nginnaly4@harvard.edu', 15543558102, 1),
('Lanny', 'Casa', '06539887F', '818 Manley Alley', '124348914', 'lcasa5@nsw.gov.au', 15543652412, 3),
('Cammi', 'Darkott', '58899391G', '60 Stang Center', '463371399', 'cdarkott6@lulu.com', 15543652112, 1),
('Shepperd', 'Schermick', '32313731H', '873 Thierer Terrace', '502786750', 'sschermick7@chron.com', 51543652102, 4),
('Curr', 'Perton', '75534411A', '9 Scoville Avenue', '395530910', 'cperton8@msu.edu', 15543652151, 4),
('Bessie', 'Greenly', '97586439C', '1339 Hollow Ridge Hill', '458835338', 'bgreenly9@cargocollective.com', 31543652102, 4),
('Libby', 'Daye', '45861845X', '8918 Grayhawk Plaza', '926263396', 'ldayea@constantcontact.com', 13143652102, 4),
('Isaiah', 'Birney', '77753705D', '61266 Graceland Pass', '507625418', 'ibirneyb@technorati.com', 15543641102, 1),
('Lina', 'Feige', '17654794A', '903 Carioca Terrace', '280627536', 'lfeigec@wikia.com', 15543650902, 1),
('Vinnie', 'Caldwall', '15243461X', '422 Helena Street', '924159548', 'vcaldwalld@youku.com', 15543652108, 2),
('Verla', 'Pladen', '76958639V', '398 Maywood Way', '157878042', 'vpladene@clickbank.net', 15543652180, 5),
('Abdul', 'Debill', '40334337S', '06372 Grasskamp Alley', '415747573', 'adebillf@squarespace.com', 56543652102, 5),
('Ethe', 'McCrostie', '32325116Z', '5 Sachs Trail', '117724440', 'emccrostieg@usda.gov', 15543657602, 5),
('Herta', 'Ailsbury', '14593626W', '3 Merchant Center', '269670394', 'hailsburyh@about.com', 79543652102, 5),
('Myrtia', 'Moat', '31191843S', '39674 Cottonwood Place', '288143334', 'mmoati@newsvine.com', 15543972102, 5),
('Loni', 'Shade', '86461274G', '9528 Village Lane', '995394993', 'lshadej@ed.gov', 15543650202, 1),
('Baillie', 'Yule', '30748343G', '841 Crownhardt Drive', '995934854', 'byulek@smugmug.com', 54365210210, 1),
('Freida', 'Leipelt', '02809890V', '9 Iowa Circle', '281970835', 'fleipeltl@live.com', 15544152102, 1),
('Rusty', 'Grellis', '68073276S', '0812 Red Cloud Point', '601675238', 'rgrellism@soundcloud.com', 15543652456, 1),
('Rozanne', 'Kingdon', '59262678B', '10127 Vernon Point', '959237114', 'rkingdonn@earthlink.net', 15543904102, 1),
('Loretta', 'Crossfield', '13549927W', '36 Valley Edge Parkway', '847897783', 'lcrossfieldo@friendfeed.com', 15543652113, 1),
('Jeniffer', 'Peret', '67015941T', '05693 Anderson Crossing', '233605410', 'jperetp@dailymotion.com', 15543650471, 1),
('Alyosha', 'Pietrzyk', '06240058S', '557 Veith Crossing', '420825136', 'apietrzykq@pcworld.com', 15543658102, 1),
('Rolfe', 'Klaassens', '68573613G', '3517 Lien Park', '131298373', 'rklaassensr@huffingtonpost.com', 15543609827, 1),
('Stanton', 'Trew', '59293884B', '742 Schlimgen Lane', '137859088', 'strews@google.co.jp', 41273652102, 1),
('Alfreda', 'Dyos', '11121985C', '35 Fulton Crossing', '858785593', 'adyost@skyrock.com', 14563652102, 1),
('Janina', 'McGovern', '49788506B', '36 Glendale Hill', '786671887', 'jmcgovernu@cisco.com', 12155452102, 2),
('Maggy', 'Buncher', '67793235R', '1400 Anderson Circle', '325774705', 'mbuncherv@ca.gov', 15543659712, 2),
('Oralla', 'Harle', '87192918F', '7 Sage Parkway', '838700445', 'oharlew@scientificamerican.com', 91976652102, 4),
('Sibel', 'Raymond', '56621157W', '1405 Northfield Court', '748668036', 'sraymondx@netscape.com', 15543652121, 1),
('Nickey', 'Tsar', '64524626G', '18797 Crowley Crossing', '906437638', 'ntsary@wp.com', 15543622102, 1),
('Miquela', 'Royse', '18292144Q', '914 Hoepker Parkway', '959149595', 'mroysez@irs.gov', 15543652332, 1),
('Janeen', 'Karppi', '91485582V', '5957 Huxley Park', '571595617', 'jkarppi10@youtube.com', 15542365212, 1),
('Pet', 'Aulds', '96400285H', '71849 Vernon Drive', '108137280', 'paulds11@live.com', 15542982102, 2),
('Bryant', 'Toffano', '81032665B', '510 Waywood Lane', '772602645', 'btoffano12@pcworld.com', 16554221302, 5),
('Konstantine', 'Rihosek', '38690176Q', '08497 5th Alley', '787219233', 'krihosek13@aboutads.info', 155136521121, 1);

INSERT INTO pedidos(descuento, fecha, id_carrito, id_empleado)
VALUES(5, '2022-1-24', 1, 1);




SELECT *
FROM usuarios;

SELECT *
FROM categorias;

SELECT *
FROM carritos;

SELECT *
FROM departamentos;

SELECT *
FROM empleados;

SELECT *
FROM marcas;

SELECT *
FROM pedidos;

SELECT *
FROM precios;

SELECT *
FROM productos;

SELECT *
FROM variantes;

