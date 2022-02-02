DROP TABLE IF EXISTS usuarios, marcas, variantes, categorias, productos, empleados, departamentos, linea_pedido, pedidos;

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
	id_categoria	int,
	CONSTRAINT pk_variantes PRIMARY KEY (id)
);

CREATE TABLE categorias (
	id				serial,
	nombre			varchar(50) NOT NULL,
	descripcion		text,
	CONSTRAINT pk_categorias PRIMARY KEY (id)
);

CREATE TABLE productos (
	id				serial,
	nombre			varchar(50) NOT NULL,
	descripcion		text,
	id_marca		int,
	id_categoria	int,
	talla			varchar(10),
	color			varchar(20),
	CONSTRAINT pk_productos PRIMARY KEY(id)
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

CREATE TABLE pedidos(
	id				serial,
	fecha_pedido	date,
	id_empleado		int,
	precio_total	numeric,
	id_usuario		int,
	CONSTRAINT pk_pedidos PRIMARY KEY(id),
	CONSTRAINT ck_restriccion_fecha CHECK (fecha_pedido >= MAKE_DATE(2020,01,20))
);

CREATE TABLE linea_pedido(
	id_pedido		integer NOT NULL,
	id_linea		serial,
	id_producto		integer NOT NULL,
	cantidad		integer DEFAULT 1,
	precio_unitario	numeric NOT NULL,
	descuento		integer DEFAULT 0,
	precio_final	numeric,
	CONSTRAINT pk_linea_pedido PRIMARY KEY (id_pedido, id_linea),
	CONSTRAINT ck_precio_positivo CHECK (precio_unitario > 0),
	CONSTRAINT ck_limites_descuento CHECK (descuento>=0 AND descuento<=100)
);

ALTER TABLE variantes ADD CONSTRAINT fk_variantes_categoria FOREIGN KEY (id_categoria)
REFERENCES categorias(id) ON DELETE SET NULL;
ALTER TABLE productos ADD CONSTRAINT fk_productos_marcas FOREIGN KEY (id_marca)
REFERENCES marcas(id) ON DELETE CASCADE;
ALTER TABLE productos ADD CONSTRAINT fk_productos_categorias FOREIGN KEY(id_categoria)
REFERENCES categorias(id) ON DELETE CASCADE;
ALTER TABLE empleados ADD CONSTRAINT fk_empleados_departamentos FOREIGN KEY(id_departamento)
REFERENCES departamentos(id);
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_empleados FOREIGN KEY(id_empleado)
REFERENCES empleados(id) ON DELETE SET NULL;
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_usuario FOREIGN KEY (id_usuario) 
REFERENCES usuarios (id);
ALTER TABLE linea_pedido ADD CONSTRAINT fk_pedidos_linea_pedidos FOREIGN KEY (id_pedido)
REFERENCES pedidos(id) ON DELETE CASCADE;
ALTER TABLE linea_pedido ADD CONSTRAINT fk_linea_pedido_productos FOREIGN KEY (id_producto)
REFERENCES productos(id) ON DELETE CASCADE;

INSERT INTO usuarios(nombre, apellidos, dni, direccion, telefono, email)
VALUES('Manuel', 'Tejado Morilla', '25589952S', 'Pino Montano', '695852684', 'manolo@gmail.com'),
('Pedro', 'Puertas Gómez', '25585952T', 'Sevilla Este', '695852697', 'pedro@gmail.com'), 
('José Ignacio', 'Rivas Rivas', '25585859T', 'Las Almenas', '695882697', 'ignacio@gmail.com'),
('Alejandro', 'López Mesa', '25585911D', 'María Auxiliadora', '6951212697', 'ale@gmail.com'),
('David', 'Puerta García', '25585999S', 'Sevilla Oeste', '695892697', 'david@gmail.com'),
('José Luis', 'Mesa Robles', '25585111B', 'Sevilla Norte', '695112697', 'joselu@gmail.com'),
('Roberto', 'Rodríguez León', '25585911C', 'Sevilla Sur', '695812397', 'roberto@gmail.com'),
('Titín', 'García Menéndez', '24485952D', 'Sevilla Noreste', '695852777', 'titin@gmail.com'),
('Rogelio', 'Galván Gómez', '25585333E', 'Sevilla Noroeste', '695866697', 'roge@gmail.com'),
('Mario', 'Barco Gómez', '25585555F', 'Sevilla Sureste', '695852666', 'mario@gmail.com'),
('Mario Antonio', 'Silla Puerta', '25585922G', 'Sevilla Suroeste', '695587697', 'marioantonio@gmail.com'),
('Víctor', 'Armario Redondo', '25585952H', 'La Alameda', '695888997', 'victor@gmail.com'),
('Álvaro', 'Puertas Chávez', '25585952I', 'Los Remedios', '695999697', 'alvaro@gmail.com'),
('Arturo', 'Adánez Rivas', '25585952J', 'La Barzola', '695852111', 'arturo@gmail.com'),
('Nacho', 'Puertas Puerta', '25585952K', 'Los Arcos', '695852622', 'nacho@gmail.com'),
('Durbán', 'Andamio Muro', '25585952L', 'Nervión', '695888697', 'durban@gmail.com'),
('Álvaro Manuel', 'Cabeza Grande', '25585952M', 'Virgen del Rocío', '695852369', 'alvarom@gmail.com'),
('Antonio', 'García Gómez', '25585952N', 'Las 3000', '695811697', 'antonio@gmail.com'),
('Ana Pilar', 'Rodríguez Candela', '25585952O', 'La Estrella', '695852987', 'ana@gmail.com'),
('Maylor', 'Rondón Mesa', '25585952P', 'Triana', '692252697', 'maylor@gmail.com'),
('Luis Miguel', 'Roddríguez Camino', '25585952Q', 'Sevilla la Nueva', '695859997', 'luismi@gmail.com'),
('Nicolás', 'Puertas Portón', '25585952R', 'Sevilla la Grande', '695111197', 'nicolas@gmail.com'),
('Jerónimo', 'Lirón Pérez', '25585333S', 'Los Remedios', '695844497', 'jeronimo@gmail.com'),
('Joselu', 'Páez Martínez', '25111952T', 'Camino de los toros', '695999997', 'joselu91@gmail.com'),
('Adrían', 'García García', '25585952U', 'Calle Feria', '695812345', 'adrian@gmail.com'),
('Miguel', 'Camino Gómez', '25111952V', 'El Prado', '695898797', 'miguel@gmail.com'),
('Rafael', 'Lenguaje Marcas', '25585952X', 'Estrella Poniente', '695852453', 'rafael@gmail.com');

INSERT INTO marcas(nombre)
VALUES ('Nike'), ('Adidas'), ('Rebook'),('Calvin Klein'),('Casio'),
('Levis'),('Dolce Gabbana'),('Lacoste'),('Corte Inglés'),('Puma') ;

INSERT INTO categorias(nombre, descripcion)
VALUES ('Vaqueros', ''),('Botines','Botines deportivos'),('Camisetas','Camisetas de manga corta'),
('Camisas','Camisas elegantes'),('Jerseys',''),('Ropa interior', 'Ropa interior de mujeres y hombres'),
('Calcetines','Calcetines unisex'), ('Chándal','Sudaderas de chandal'),
('Sandalias','Sandalias unisex'),('Zapatos','Zapatos elegantes'),
('Accesorios', 'Gafas, gorras, relojes etc...');

INSERT INTO variantes (nombre, descripcion,id_categoria)
VALUES ('Pantalón corto', 'Pantalón a la altura de la rodilla',1), ('Pantalón largo', 'Pantalón hasta el tobillo',1), 
('Pantalón invierno', 'Pantalón de buen grosor',1), ('Pantalón verano', 'Pantalón de tela fina y fresca',1), 
('Pantalón primavera', 'Pantalón con estampado llamativo',1), ('Pantalón otoño', 'Pantalón con colores apagados',1), 
('Botines sport','Botines cómodos para combinar',2), ('Camisetas','Camisetas deportivas',3),
('Camisas','Camisas elegantes',4),('Jersey', 'Jersey de cuello alto',8), ('Bragas', 'Bragas con encaje',5), 
('Calzoncillos', 'Boxers elásticos',5),('Calcetines', 'Calcetines mixtos',6),('Zapatos', 'Zapatos para traje',10), 
('Sudadera','Partes de arriba chandal',7),('Jersey cuello bajo', 'Jerseys de cuello bajo',8),
('Sandalias','Sandalias de hombre y mujer',9), ('Zapatos muiltiusos','Zapatos de uso diario',10), 
('Gafas', 'Gafas de sol unisex',11),('Gorras', 'Gorras deportivas',11), ('Relojes', 'Todo tipo de relojes',11);


INSERT INTO productos(nombre, descripcion, id_marca, id_categoria, talla, color)
VALUES ('Vaqueros Slim Fit', 'Unos vaqueros muy ajustados', 9, 1,'40','Azul'),('Vaqueros de campana', 'Vaqueros antiguos', 9, 1,'40','Azul'),
('Vaqueros Rotos', 'Unos vaqueros rotos', 6, 1,'38','Negro'),('Air Force One', 'Unas zapatillas para combinar', 1, 2,'42','Blanco'),
('Sudera PSG', 'Una sudadera de fútbol', 1, 7,'M','Granate'),('Zapatos de punta', 'Unos zapatos que combinan con todo', 9, 10,'42/3','Nergo'),
('Jersey abrigado', 'Un jersey para invierno', 8, 8,'L','Azul'),('Camiseta Real Betis', 'Una camiseta del Real Betis', 2, 3,'XL','Verde'),
('Boxer CK', 'Calsonzillos para hombre Calvin Klein', 4, 5,'S','Negro'),('Bragas con agujeros', 'Unas bragas con agujeros', 7, 5,'S/M','Blanco'),
('Playeras', 'Sandalias comodas para la playa', 1, 9,'40','Amarillo'),('Camisa ajustada', 'Una camisa ajustada para usar con traje', 9, 4,'M','Blanco'),
('Camiseta ancha', 'Una camiseta ancha de uso diario', 3, 3,'M/L','Negro'),('Jordan Airmax', 'Botines deportivos', 1, 2,'40/42','Rojo'),
('Bambas', 'Zapatillas de uso diario', 10, 2,'40/42','Rojo'),('Vaqueros anchos', 'Unos vaqueros anchos unisex', 6, 1,'40','Negro'),
('Calcetines tobilleros', 'Calcetines cortos de tobillo', 4, 6,'40/42','Negro'),('Camiseta del Sevilla FC', 'Una camiseta del equipo Sevilla FC', 10, 3,'M/L','Rojo'),
('Gorra del FC Barcelona', 'Una gorra del FC Barcelona', 2, 11,'Única','Granate'),('Gafas para playa', 'Unas gafas veraniegas', 4, 11,'Única','Negro'),
('Calcetines largos', 'Unos calcetines largos para invierno', 7, 6,'40/42','Negro'),('Gorra ancha', 'Una gorra ancha al estilo noventero', 3, 11,'Única','Violeta'),
('Calzoncillos cortos', 'Calzoncillos boxers cortos tradicionales', 4, 5,'S','Blanco'),('Chándal PSG', 'Pantalón de chándal del equipo PSG', 1, 7,'M/L','Granate'),
('Zapatos de feria', 'Unos zapatos arreglados para trajes de feria', 9, 10,'42/43','Marrón'), ('Zancos', 'Unos botines sin talon de uso diario', 1, 2,'40/41','Rojo'),
('Calzonas ajustadas', 'Unas calzonas ajustadas deportivas', 10, 7,'XS','Azul'),('Calzona bañador', 'Calzonas que sirven de bañador ', 2, 7,'S','Azul'),
('Vaqueros fly', 'Unos vaqueros largos rotos', 6, 1,'40','Azul'),('Reloj deportivo', 'Un reloj que combina con todo tipo de ropa', 5, 11,'Única','Negro'),
('Camisa ancha', 'Una camisa ancha muy facil de combinar', 3, 4,'M','Blanco'),('Gafas de sol', 'Unas gafas de sol de uso diario', 4, 11,'Única','Negro'),
('Gorra ajustable deportiva', 'Una gorra unisex para hacer deporte', 10, 11,'Única','Blanco'),('Total 90', 'Unos botines para jugar a futbol 11', 1, 2,'42/43','Rojiblanco'),
('Botines multitacos', 'Unos botines para validos para fútbol 11 y fútbol sala', 10, 2,'45','Rojo'),('Botines lisos', 'Unos botines para jugar a fútbol sala', 2, 2,'41/42','Azul'),
('Calcetines arreglados', 'Calcetines largos para traje', 1, 6,'40/42','Negro'), ('Calzoncillo tradicional', 'Calzoncillos boxers adicionales', 1, 5,'S','Negro'),
('Tangas', 'Bragas de mujer estilo brasileiro', 4, 5,'S','Rojo'),('Pantalon tela gruesa', 'Un pantalon muy calido y cómodo', 8, 1,'40','Marrón');

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

insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('31/3/2021',1,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('24/6/2022', 5,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('17/10/2021', 7,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/2/2021', 12,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('10/6/2022', 40,25);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/10/2022', 34,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/12/2022', 7,27);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/1/2022', 40,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('26/10/2022', 30,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/9/2021', 7,19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/12/2021', 25,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('21/1/2021', 30,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/8/2021', 20,8);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/5/2021', 7,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/12/2021', 5,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('29/1/2021', 30,19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/10/2021', 35,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/9/2022', 13,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('26/1/2022', 12,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/1/2022', 7,15);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/3/2022', 12,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/9/2022', 1,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('20/1/2022', 22,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/12/2022', 37,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('17/8/2022', 7,	19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('28/1/2022', 23,9);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/10/2022', 13,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('19/11/2021',7,	3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/10/2021', 34,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/5/2021', 36,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('6/3/2021', 22,	8);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/5/2021', 35,26);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('17/4/2021', 24,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/1/2022', 13,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('5/2/2021', 30,	12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/2/2022', 34,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('6/12/2021', 7,	10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('25/1/2021', 30,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('9/9/2022', 20,	27);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('21/7/2021', 34,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/5/2021', 13,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('24/2/2022', 22,23);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/3/2022', 1,	12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/3/2021', 7,	6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('10/10/2021', 37,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/4/2021', 23,24);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('15/11/2021', 25,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('9/2/2021', 7,15);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/3/2022', 5,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/9/2021', 30,20);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('20/10/2021',1,	23);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/10/2021',5,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('20/7/2021',7,24);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/2/2021',12,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/12/2021',40,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/2/2021',34,13);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/12/2021',7,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/4/2021',40,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/1/2022',30,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/4/2021',7,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/7/2021',25,16);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/1/2022',30,5);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('19/1/2022',20,20);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('5/7/2021', 7,13);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/10/2021',5,7);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('21/10/2021',30,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/11/2021',35,24);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/6/2021',13,9);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('10/3/2021',12,17);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('1/9/2021', 7,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/7/2021',12,9);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('4/8/2021', 1,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/6/2021',22,16);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('9/10/2021',37,20);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/1/2022',7,25);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/1/2022', 23,16);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('5/11/2021',13,26);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('15/2/2021',7,17);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('28/10/2021',34,20);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/11/2021',36,23);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/5/2021',22,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('8/9/2021', 35,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('11/3/2021',24,25);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('25/7/2021',13,23);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('7/6/2021', 30,5);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('6/1/2022', 34,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('29/5/2021',7,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('9/9/2021', 30,20);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/1/2022',20,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('12/8/2021',34,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('31/5/2021',13,25);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('31/8/2021',22,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('3/5/2021', 1,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('4/12/2021',7,7);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/9/2021', 37,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/7/2021',23,14);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/1/2022',25,27);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('26/11/2021',7,13);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('24/2/2021',5,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/5/2021',30,4);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('6/1/2022', 1,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('30/10/2021',5,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('1/10/2021',7,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('18/8/2021',12,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('5/4/2021', 40,25);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/6/2021',34,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('10/5/2021',7,27);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('21/1/2022',40,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('17/12/2021',30,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('31/7/2021',7,19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('8/11/2021',25,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('21/6/2021',30,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('15/2/2021',20,8);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('22/7/2021',7,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('8/6/2021', 5,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/10/2021',30,19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('25/10/2021',35,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('20/6/2021',13,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/10/2021',12,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('4/11/2021',7,15);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('16/9/2021',12,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('19/8/2021',1,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('7/3/2021', 22,11);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('20/3/2021',37,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/5/2021',7,19);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/10/2021',23,9);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('19/5/2021',13,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/2/2021',7,3);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('1/1/2022', 34,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('3/11/2021',36,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('31/8/2021',22,8);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('26/3/2021',35,26);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('25/1/2022',24,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/8/2021', 13,18);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('13/2/2021',30,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('28/8/2021',34,1);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('5/10/2021',7,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('27/6/2021',30,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('24/11/2021',20,27);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('26/9/2021',34,22);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/6/2021',13,2);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('14/1/2022',22,23);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('2/3/2021', 1,12);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('9/9/2021', 7,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('24/8/2021',37,6);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('11/11/2021',3,24);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('19/10/2021',5,21);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('23/11/2021', 7,15);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('11/3/2021',5,10);
insert into pedidos (fecha_pedido, id_empleado, id_usuario) values ('30/7/2021',30,20);


insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 43, 3, 9.77, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 54, 2, 11.38, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 34, 4, 23.03, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 18, 9, 10.64, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 47, 2, 29.98, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (1, 21, 6, 23.99, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 56, 7, 12.08, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 24, 3, 29.64, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 8, 7, 32.96, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 30, 5, 21.71, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 65, 6, 10.39, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (2, 33, 7, 14.11, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 22, 2, 11.26, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 37, 6, 17.52, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 38, 6, 13.51, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 18, 10, 30.85, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 36, 4, 10.85, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (3, 67, 3, 24.63, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 56, 9, 25.7, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 18, 7, 33.62, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 52, 9, 11.62, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 55, 10, 29.0, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 67, 10, 22.89, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (4, 53, 3, 26.22, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 15, 2, 14.98, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 31, 1, 34.6, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 27, 2, 14.73, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 15, 5, 10.45, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 57, 9, 24.37, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (5, 42, 4, 26.99, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 70, 8, 34.16, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 57, 1, 22.63, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 61, 6, 14.58, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 41, 10, 28.88, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 17, 1, 24.6, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (6, 66, 7, 10.29, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 22, 6, 8.08, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 26, 4, 6.37, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 10, 9, 14.68, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 55, 10, 4.45, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 24, 1, 8.04, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (7, 59, 8, 8.99, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 11, 1, 28.4, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 12, 9, 5.22, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 64, 8, 5.6, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 21, 5, 11.17, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 55, 6, 6.6, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (8, 16, 4, 26.09, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 40, 4, 26.19, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 67, 7, 27.19, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 21, 10, 11.16, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 65, 9, 28.78, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 8, 5, 31.94, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (9, 22, 4, 11.17, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 25, 10, 20.2, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 73, 10, 12.92, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 49, 8, 7.12, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 59, 6, 10.93, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 46, 4, 4.88, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (10, 58, 8, 16.13, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 4, 5, 21.16, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 50, 6, 20.88, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 61, 4, 24.85, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 3, 7, 16.25, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 13, 1, 13.27, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (11, 60, 2, 30.13, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 32, 2, 6.22, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 25, 4, 4.18, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 65, 10, 14.6, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 4, 4, 24.64, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 15, 3, 26.03, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (12, 14, 6, 28.46, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 59, 8, 34.92, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 70, 5, 29.53, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 57, 4, 10.01, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 43, 6, 17.08, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 7, 10, 30.07, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (13, 25, 10, 7.55, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 18, 4, 23.94, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 16, 5, 34.9, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 38, 5, 32.02, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 61, 1, 23.56, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 52, 1, 29.49, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (14, 60, 4, 6.64, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 32, 9, 22.3, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 51, 5, 12.74, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 12, 6, 34.66, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 30, 3, 21.28, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 29, 3, 17.53, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (15, 41, 4, 31.68, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 5, 1, 22.54, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 56, 1, 7.47, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 62, 1, 15.49, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 24, 3, 23.06, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 32, 2, 32.68, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (16, 53, 7, 17.81, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 19, 9, 33.0, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 56, 4, 8.8, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 30, 5, 30.36, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 71, 2, 21.83, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 23, 1, 4.67, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (17, 62, 2, 33.84, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 65, 1, 27.6, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 54, 3, 18.86, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 7, 1, 21.26, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 73, 2, 13.41, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 26, 1, 34.87, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (18, 44, 8, 23.21, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 18, 10, 19.08, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 56, 2, 11.83, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 45, 1, 27.11, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 50, 9, 12.23, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 38, 1, 24.61, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (19, 29, 1, 7.24, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 75, 10, 34.81, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 3, 6, 9.82, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 12, 10, 33.28, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 48, 8, 15.39, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 40, 7, 9.04, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (20, 65, 6, 23.15, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 12, 5, 17.44, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 45, 4, 5.4, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 7, 9, 9.34, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 55, 1, 31.4, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 59, 3, 21.55, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (21, 6, 4, 7.97, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 40, 4, 24.56, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 9, 5, 24.21, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 17, 5, 25.46, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 22, 2, 7.28, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 61, 5, 13.71, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (22, 37, 5, 10.41, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 2, 7, 4.75, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 27, 9, 33.24, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 64, 10, 6.63, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 29, 6, 4.73, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 65, 10, 33.78, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (23, 29, 2, 30.37, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 1, 4, 22.97, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 19, 7, 34.54, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 57, 4, 4.63, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 33, 4, 18.41, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 73, 7, 24.62, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (24, 26, 4, 13.88, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 42, 9, 34.23, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 29, 10, 22.16, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 25, 9, 7.94, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 5, 1, 26.48, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 65, 1, 27.47, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (25, 52, 7, 12.36, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 72, 8, 13.09, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 50, 4, 6.35, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 27, 3, 21.49, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 10, 4, 17.75, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 42, 3, 24.72, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (26, 69, 5, 29.33, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 71, 8, 34.35, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 22, 9, 7.32, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 69, 6, 24.9, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 18, 1, 16.01, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 52, 8, 19.4, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (27, 30, 2, 22.22, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 28, 8, 34.55, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 20, 5, 22.68, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 35, 7, 16.79, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 66, 4, 30.4, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 2, 2, 19.09, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (28, 52, 4, 23.6, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 33, 4, 33.45, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 66, 3, 10.33, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 27, 2, 20.27, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 23, 3, 8.07, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 1, 10, 21.75, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (29, 72, 9, 11.59, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 59, 4, 15.49, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 50, 4, 34.01, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 15, 8, 19.14, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 16, 1, 25.89, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 60, 10, 6.0, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (30, 73, 7, 4.96, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 49, 8, 9.65, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 10, 2, 9.35, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 28, 1, 19.8, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 29, 10, 27.72, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 17, 8, 13.74, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (31, 37, 6, 25.82, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 63, 10, 33.29, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 19, 2, 22.91, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 57, 1, 33.83, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 67, 4, 26.83, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 45, 6, 6.97, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (32, 53, 6, 8.97, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 46, 3, 14.56, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 71, 5, 6.2, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 72, 7, 9.53, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 65, 7, 7.31, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 22, 8, 33.22, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (33, 29, 9, 13.47, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 24, 8, 13.58, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 24, 7, 15.9, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 46, 1, 21.91, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 64, 6, 10.04, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 56, 6, 28.82, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (34, 6, 4, 21.62, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 15, 7, 7.53, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 57, 1, 24.64, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 21, 6, 25.51, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 74, 6, 31.34, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 22, 4, 29.88, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (35, 53, 4, 7.37, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 13, 2, 12.52, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 73, 7, 21.55, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 36, 4, 15.52, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 25, 3, 26.46, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 38, 6, 8.89, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (36, 20, 3, 29.43, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 24, 2, 9.04, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 12, 1, 4.38, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 64, 4, 13.04, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 72, 9, 20.0, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 7, 3, 26.48, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (37, 73, 7, 10.57, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 68, 9, 9.53, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 63, 10, 27.45, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 27, 6, 13.73, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 47, 2, 11.48, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 23, 7, 16.97, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (38, 23, 6, 8.44, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 23, 9, 20.95, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 59, 9, 16.69, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 8, 4, 27.06, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 50, 9, 10.77, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 27, 1, 24.58, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (39, 35, 10, 23.05, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 20, 6, 6.11, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 48, 6, 5.94, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 56, 5, 16.55, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 11, 2, 19.94, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 12, 5, 5.42, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (40, 54, 9, 8.6, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 47, 8, 23.53, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 3, 6, 23.05, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 7, 9, 22.85, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 57, 7, 29.83, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 64, 1, 5.18, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (41, 36, 2, 16.95, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 15, 1, 15.98, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 50, 9, 16.66, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 19, 5, 23.21, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 37, 7, 20.82, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 14, 2, 32.85, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (42, 73, 5, 19.5, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 35, 6, 15.65, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 12, 6, 22.07, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 69, 8, 25.77, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 53, 10, 23.42, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 67, 5, 20.67, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (43, 3, 2, 8.89, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 12, 10, 25.45, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 15, 10, 9.71, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 5, 4, 27.9, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 45, 6, 13.37, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 12, 10, 16.16, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (44, 11, 7, 15.39, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 39, 4, 27.33, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 42, 7, 12.77, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 38, 2, 17.37, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 43, 9, 13.3, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 27, 6, 32.16, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (45, 36, 2, 22.5, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 50, 3, 5.94, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 62, 2, 32.63, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 5, 2, 15.83, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 32, 6, 29.25, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 11, 4, 28.82, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (46, 28, 5, 12.15, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 36, 10, 11.6, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 39, 6, 34.27, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 16, 9, 12.75, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 70, 3, 25.46, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 75, 8, 24.18, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (47, 22, 3, 4.85, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 41, 3, 15.78, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 21, 5, 33.55, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 27, 10, 25.26, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 69, 8, 24.82, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 30, 7, 12.34, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (48, 56, 8, 9.44, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 40, 4, 18.76, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 57, 6, 24.11, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 32, 10, 22.75, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 29, 7, 24.39, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 66, 2, 10.59, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (49, 64, 8, 25.85, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 37, 3, 31.39, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 73, 6, 20.68, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 24, 4, 6.91, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 45, 6, 6.75, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 43, 4, 31.99, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 24, 2, 23.18, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 19, 1, 26.99, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 7, 8, 24.31, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 8, 2, 35.22, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 24, 5, 25.09, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 34, 8, 27.18, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 73, 9, 5.65, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 34, 4, 27.22, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 41, 4, 13.76, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 6, 9, 18.26, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (50, 58, 6, 16.59, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 13, 1, 19.23, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 59, 2, 7.3, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 44, 9, 10.24, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 26, 4, 10.87, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 37, 8, 15.37, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 58, 8, 32.06, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 11, 7, 32.82, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 75, 3, 31.95, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 12, 8, 29.52, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (51, 22, 6, 25.9, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 67, 9, 26.26, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 16, 10, 14.56, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 43, 3, 4.03, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 73, 8, 28.93, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 69, 3, 34.34, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 4, 1, 19.44, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 68, 6, 39.77, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 70, 3, 24.75, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 32, 1, 31.17, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (52, 38, 8, 31.04, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 40, 10, 34.71, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 28, 5, 25.75, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 12, 6, 22.61, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 5, 9, 36.29, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 8, 9, 11.72, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 57, 7, 30.09, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 61, 7, 27.98, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 38, 1, 10.55, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 65, 3, 9.69, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (53, 39, 9, 17.84, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 22, 5, 24.83, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 57, 7, 39.26, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 2, 9, 21.21, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 44, 6, 15.23, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 15, 7, 32.64, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 53, 8, 33.91, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 64, 1, 34.93, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 15, 6, 29.89, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 21, 7, 16.91, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (54, 9, 4, 6.52, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 46, 3, 11.65, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 58, 6, 16.01, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 53, 9, 4.61, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 13, 10, 38.58, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 39, 6, 21.28, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 21, 4, 17.53, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 61, 3, 36.04, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 62, 10, 34.53, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 38, 4, 16.03, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (55, 35, 9, 34.54, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 68, 8, 35.74, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 39, 2, 29.95, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 54, 6, 11.91, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 58, 3, 19.07, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 3, 10, 28.59, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 39, 1, 20.01, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 33, 3, 33.08, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 40, 5, 18.81, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 59, 10, 29.84, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (56, 33, 2, 14.07, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 40, 10, 17.25, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 58, 1, 31.8, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 37, 2, 12.84, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 50, 7, 33.77, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 62, 10, 11.0, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 21, 5, 20.43, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 75, 2, 4.95, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 43, 3, 39.05, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 55, 10, 10.07, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (57, 25, 7, 15.34, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 32, 7, 26.78, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 69, 9, 23.19, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 21, 5, 14.02, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 57, 9, 13.58, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 53, 10, 34.97, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 49, 10, 24.72, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 22, 8, 38.43, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 3, 2, 22.35, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 56, 2, 19.32, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (58, 45, 5, 19.91, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 26, 1, 6.29, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 33, 5, 17.53, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 47, 6, 5.95, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 16, 6, 21.91, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 40, 7, 18.45, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 59, 7, 28.26, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 38, 8, 9.87, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 47, 1, 19.4, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 23, 6, 11.23, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (59, 42, 2, 13.29, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 69, 6, 11.55, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 62, 4, 19.87, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 72, 8, 31.18, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 28, 2, 15.23, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 74, 4, 39.36, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 3, 9, 34.83, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 58, 3, 4.06, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 32, 9, 18.4, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 17, 4, 32.51, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (60, 17, 5, 27.23, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 46, 6, 9.45, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 39, 3, 20.67, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 23, 4, 34.36, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 49, 6, 10.17, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 73, 1, 39.87, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 41, 9, 16.53, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 2, 7, 21.42, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 9, 6, 7.75, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 27, 10, 31.27, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (61, 17, 6, 19.57, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 23, 8, 14.54, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 31, 6, 19.05, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 40, 3, 27.04, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 57, 6, 9.19, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 56, 9, 4.5, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 15, 9, 24.86, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 8, 2, 8.33, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 66, 9, 17.76, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 23, 6, 36.16, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (62, 32, 1, 4.19, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 46, 10, 22.24, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 14, 10, 39.63, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 33, 10, 4.76, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 29, 10, 22.19, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 1, 10, 17.01, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 53, 4, 16.78, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 64, 6, 20.2, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 8, 7, 13.18, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 56, 9, 27.97, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (63, 58, 4, 19.64, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 72, 7, 7.31, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 63, 8, 22.1, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 25, 2, 12.33, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 68, 2, 33.96, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 48, 9, 26.62, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 26, 6, 35.55, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 22, 6, 13.45, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 8, 8, 15.2, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 45, 5, 39.23, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (64, 70, 4, 16.86, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 29, 9, 13.35, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 2, 9, 19.9, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 3, 1, 34.79, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 35, 7, 30.27, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 4, 1, 15.96, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 68, 1, 25.44, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 32, 6, 35.18, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 73, 8, 15.22, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 39, 7, 8.23, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (65, 48, 4, 7.77, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 6, 8, 31.7, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 63, 1, 13.92, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 68, 3, 29.0, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 19, 7, 39.9, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 57, 5, 36.86, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 55, 3, 18.17, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 36, 6, 19.27, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 62, 4, 25.81, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 66, 7, 33.44, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (66, 45, 7, 9.83, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 67, 1, 10.59, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 2, 3, 7.06, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 1, 9, 17.0, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 13, 7, 33.82, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 14, 3, 28.59, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 58, 9, 18.77, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 24, 1, 8.79, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 52, 10, 16.52, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 15, 2, 5.48, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (67, 70, 1, 18.37, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 63, 6, 5.76, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 75, 10, 28.41, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 31, 1, 16.96, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 6, 10, 22.64, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 63, 3, 11.41, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 20, 9, 15.69, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 44, 4, 25.51, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 74, 5, 26.41, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 66, 10, 9.87, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (68, 4, 7, 5.26, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 29, 7, 27.91, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 18, 7, 31.38, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 9, 9, 35.8, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 19, 3, 35.29, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 56, 1, 5.67, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 32, 8, 32.71, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 30, 10, 21.1, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 30, 2, 9.13, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 20, 1, 36.4, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (69, 20, 8, 4.66, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 26, 2, 20.06, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 67, 10, 36.71, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 47, 7, 30.6, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 47, 4, 25.41, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 13, 1, 26.0, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 32, 10, 25.93, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 12, 5, 4.18, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 58, 5, 17.57, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 57, 9, 14.81, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (70, 20, 7, 6.45, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 30, 3, 4.34, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 66, 8, 29.03, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 11, 10, 28.87, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 31, 5, 24.53, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 9, 4, 17.28, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 21, 8, 21.44, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 28, 3, 4.74, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 42, 4, 9.2, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 7, 6, 17.74, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (71, 43, 2, 22.18, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 25, 8, 4.67, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 57, 3, 23.08, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 38, 9, 16.11, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 43, 6, 24.73, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 8, 3, 24.72, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 29, 8, 22.92, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 32, 10, 14.89, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 9, 9, 10.17, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 43, 8, 5.74, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (72, 72, 10, 17.41, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 54, 8, 7.62, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 50, 9, 18.01, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 31, 1, 15.08, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 5, 5, 21.79, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 18, 10, 36.38, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 43, 10, 13.98, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 29, 1, 38.78, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 13, 4, 8.56, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 38, 1, 30.04, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (73, 43, 1, 10.44, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 10, 8, 26.94, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 1, 3, 18.56, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 68, 3, 29.25, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 40, 5, 13.21, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 28, 8, 11.32, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 31, 5, 19.86, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 40, 9, 11.57, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 37, 7, 34.62, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 31, 6, 32.49, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (74, 30, 6, 34.36, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 17, 10, 39.19, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 53, 2, 39.05, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 5, 4, 20.5, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 22, 1, 17.85, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 8, 8, 10.5, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 37, 5, 14.71, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 53, 9, 8.93, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 30, 8, 18.08, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 14, 3, 14.88, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (75, 21, 3, 20.64, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 21, 10, 38.95, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 36, 9, 10.93, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 62, 5, 35.2, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 58, 2, 7.57, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 1, 10, 40.0, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 44, 1, 37.04, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 11, 3, 6.98, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 36, 1, 21.63, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 59, 7, 30.23, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (76, 19, 6, 25.38, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 61, 6, 12.77, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 65, 2, 23.97, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 16, 6, 26.2, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 11, 9, 30.37, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 17, 2, 30.11, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 23, 4, 20.31, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 35, 9, 37.92, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 46, 6, 35.77, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 5, 3, 28.53, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (77, 42, 9, 32.57, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 19, 1, 31.19, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 54, 5, 10.64, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 16, 5, 37.64, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 19, 5, 25.27, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 53, 6, 23.0, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 45, 6, 13.3, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 39, 4, 6.41, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 14, 6, 30.18, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 55, 9, 4.57, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (78, 1, 2, 14.53, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 15, 4, 38.85, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 69, 3, 29.68, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 37, 1, 6.75, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 48, 10, 28.55, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 26, 2, 14.82, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 72, 8, 22.37, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 40, 3, 31.72, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 35, 8, 24.23, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 12, 7, 24.93, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (79, 40, 9, 28.72, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 51, 4, 23.82, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 29, 8, 26.96, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 55, 7, 38.67, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 20, 10, 17.86, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 13, 10, 16.28, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 3, 7, 13.0, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 9, 9, 34.27, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 29, 4, 39.42, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 59, 2, 30.12, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (80, 53, 9, 29.87, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 71, 2, 21.3, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 28, 2, 15.97, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 5, 6, 25.47, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 68, 1, 9.85, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 58, 8, 8.88, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 13, 1, 32.89, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 31, 10, 13.17, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 53, 1, 4.26, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 11, 8, 16.16, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (81, 37, 5, 24.95, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 54, 10, 26.11, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 74, 9, 4.09, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 22, 1, 7.56, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 29, 8, 15.06, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 33, 9, 14.0, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 73, 8, 31.55, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 41, 10, 17.15, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 55, 6, 32.96, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 33, 10, 16.92, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (82, 29, 7, 11.89, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 66, 7, 15.73, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 5, 4, 9.84, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 56, 8, 5.98, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 58, 2, 4.29, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 44, 4, 7.83, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 2, 7, 4.89, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 55, 4, 19.3, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 9, 3, 10.72, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 74, 2, 37.77, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (83, 48, 4, 20.31, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 27, 4, 39.9, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 48, 9, 23.66, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 55, 7, 39.0, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 32, 6, 23.08, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 25, 1, 6.17, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 25, 4, 19.94, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 44, 9, 28.68, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 57, 9, 4.81, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 1, 5, 5.35, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (84, 53, 6, 11.85, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 12, 5, 34.15, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 69, 5, 15.37, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 12, 7, 11.35, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 73, 6, 18.74, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 66, 6, 29.62, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 74, 3, 14.27, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 75, 6, 29.71, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 20, 10, 36.38, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 61, 6, 7.92, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (85, 29, 8, 11.13, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 74, 4, 32.19, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 61, 4, 20.91, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 39, 8, 37.61, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 64, 7, 10.05, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 42, 10, 34.29, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 58, 2, 26.63, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 30, 2, 29.89, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 3, 3, 11.97, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 2, 4, 19.15, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (86, 61, 3, 33.93, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 52, 6, 27.74, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 67, 8, 6.58, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 18, 7, 10.77, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 13, 4, 39.33, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 63, 10, 24.45, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 48, 6, 9.94, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 34, 10, 32.97, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 59, 8, 36.5, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 70, 2, 18.45, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (87, 57, 1, 16.37, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 43, 4, 16.34, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 6, 3, 37.63, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 35, 4, 6.02, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 53, 2, 6.93, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 17, 6, 18.45, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 68, 9, 32.79, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 58, 2, 30.24, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 4, 1, 31.6, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 66, 4, 38.85, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (88, 69, 9, 25.45, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 33, 4, 34.51, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 51, 6, 14.6, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 34, 5, 15.02, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 70, 4, 14.3, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 20, 6, 19.07, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 43, 10, 5.6, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 18, 5, 28.33, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 62, 8, 39.37, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 75, 9, 23.91, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (89, 38, 9, 7.92, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 28, 8, 38.28, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 3, 4, 11.5, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 51, 10, 21.5, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 6, 4, 19.28, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 18, 9, 6.91, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 19, 6, 14.6, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 24, 5, 23.31, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 57, 10, 38.12, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 40, 4, 37.74, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (90, 11, 2, 14.0, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 1, 4, 11.92, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 32, 9, 23.72, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 30, 4, 17.39, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 3, 6, 13.77, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 63, 4, 20.93, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 13, 3, 6.85, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 51, 8, 36.88, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 50, 5, 35.29, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 67, 10, 19.06, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (91, 10, 2, 28.95, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 52, 9, 24.05, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 36, 1, 25.84, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 53, 7, 35.42, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 69, 7, 37.05, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 29, 7, 16.16, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 49, 8, 33.66, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 3, 1, 16.17, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 19, 8, 38.68, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 27, 3, 9.33, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (92, 12, 4, 9.62, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 52, 5, 4.37, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 53, 7, 39.14, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 50, 10, 4.02, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 62, 4, 18.05, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 45, 3, 34.7, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 31, 8, 26.01, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 39, 4, 25.57, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 26, 2, 10.86, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 60, 1, 19.69, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (93, 60, 10, 31.14, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 18, 1, 14.63, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 4, 3, 10.37, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 35, 5, 38.36, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 16, 5, 19.43, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 25, 10, 30.68, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 63, 2, 28.68, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 43, 4, 4.54, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 54, 4, 34.62, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 7, 9, 32.02, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (94, 31, 9, 10.09, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 30, 2, 38.3, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 72, 3, 23.51, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 67, 9, 27.63, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 62, 1, 15.42, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 42, 10, 4.46, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 12, 4, 31.9, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 45, 8, 39.06, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 71, 6, 30.69, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 49, 3, 18.99, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (95, 71, 4, 19.57, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 29, 4, 20.68, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 2, 2, 31.26, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 42, 7, 15.43, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 16, 7, 20.29, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 74, 4, 38.04, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 33, 8, 31.92, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 13, 7, 36.96, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 73, 7, 34.96, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 39, 3, 30.99, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (96, 22, 8, 9.54, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 39, 10, 35.58, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 47, 9, 29.31, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 5, 10, 21.97, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 32, 10, 24.62, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 30, 2, 13.72, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 37, 9, 5.07, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 19, 5, 26.59, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 45, 10, 37.14, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 41, 7, 23.74, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (97, 11, 4, 10.91, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 22, 2, 14.33, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 60, 1, 20.6, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 16, 3, 23.4, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 6, 8, 8.93, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 7, 3, 32.01, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 25, 9, 30.27, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 12, 1, 6.2, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 1, 8, 10.57, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 62, 6, 5.19, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (98, 50, 3, 8.96, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 6, 4, 16.46, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 61, 1, 34.09, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 21, 9, 28.65, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 34, 9, 18.59, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 7, 7, 36.74, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 48, 3, 12.98, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 3, 3, 33.58, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 32, 4, 14.5, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 64, 1, 32.35, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (99, 26, 2, 22.56, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 71, 2, 10.37, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 40, 3, 21.45, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 37, 3, 33.07, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 18, 2, 23.04, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 37, 8, 24.74, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 26, 2, 8.48, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 74, 6, 9.58, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 11, 4, 13.48, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 43, 6, 20.78, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (100, 75, 6, 29.01, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 69, 4, 17.43, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 55, 3, 24.45, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 67, 2, 16.02, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 54, 3, 12.39, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 3, 8, 33.98, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 39, 1, 20.54, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 68, 1, 33.03, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 34, 6, 25.34, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 15, 8, 5.12, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (101, 24, 8, 38.82, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 32, 5, 30.94, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 22, 8, 12.41, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 20, 7, 31.84, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 25, 10, 4.25, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 29, 10, 25.18, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 73, 8, 23.17, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 52, 5, 7.88, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 1, 8, 27.4, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 10, 3, 24.12, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (102, 69, 1, 16.38, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 39, 2, 22.53, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 42, 6, 21.67, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 22, 3, 35.24, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 63, 4, 23.95, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 28, 5, 36.81, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 72, 6, 35.54, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 61, 7, 25.24, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 36, 4, 29.33, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 70, 5, 33.51, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (103, 13, 7, 30.27, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 62, 2, 5.57, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 60, 8, 35.33, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 10, 1, 10.51, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 58, 1, 6.59, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 39, 1, 13.36, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 48, 5, 15.44, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 5, 7, 30.55, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 27, 2, 24.84, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 54, 8, 9.14, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (104, 71, 6, 17.52, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 5, 6, 22.43, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 48, 4, 38.06, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 28, 7, 23.19, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 63, 5, 39.54, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 26, 7, 28.7, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 48, 2, 12.79, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 48, 5, 18.52, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 53, 7, 4.98, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 59, 8, 14.26, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (105, 53, 6, 32.96, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 60, 4, 11.97, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 6, 4, 28.33, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 74, 7, 27.35, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 64, 2, 35.38, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 1, 6, 17.4, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 73, 10, 25.39, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 25, 10, 23.52, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 58, 7, 28.82, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 2, 6, 8.15, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (106, 18, 7, 39.41, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 36, 3, 12.34, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 53, 5, 38.93, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 33, 2, 20.08, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 66, 4, 25.71, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 39, 9, 23.64, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 58, 2, 25.86, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 2, 6, 10.04, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 67, 9, 22.78, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 24, 10, 31.15, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (107, 63, 6, 10.58, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 28, 7, 19.03, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 31, 9, 26.17, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 21, 10, 13.89, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 42, 6, 28.97, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 29, 3, 13.18, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 11, 7, 9.69, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 15, 9, 36.45, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 10, 3, 28.44, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 50, 6, 28.2, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (108, 26, 4, 12.77, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 56, 3, 29.02, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 55, 5, 34.12, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 67, 3, 36.51, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 38, 5, 17.1, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 71, 5, 14.41, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 35, 2, 15.35, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 46, 1, 8.61, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 52, 6, 23.54, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 61, 7, 13.45, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (109, 9, 6, 18.99, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 75, 3, 15.71, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 6, 8, 16.15, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 49, 2, 5.76, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 36, 7, 26.91, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 46, 9, 19.82, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 44, 10, 8.34, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 61, 2, 15.61, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 70, 1, 12.61, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 70, 9, 18.36, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (110, 39, 6, 13.84, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 17, 3, 38.82, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 7, 2, 9.84, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 74, 7, 17.94, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 73, 2, 4.44, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 20, 2, 10.58, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 26, 10, 8.89, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 23, 8, 33.43, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 33, 4, 9.7, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 5, 8, 6.68, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (111, 57, 4, 16.15, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 45, 8, 33.42, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 49, 3, 34.38, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 29, 9, 15.06, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 13, 1, 21.36, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 72, 9, 15.23, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 63, 6, 30.98, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 31, 7, 21.81, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 65, 3, 22.5, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 3, 7, 36.86, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (112, 67, 1, 14.89, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 39, 5, 9.56, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 36, 10, 33.99, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 61, 8, 9.39, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 14, 4, 5.71, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 35, 5, 31.92, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 10, 4, 16.26, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 1, 2, 38.74, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 3, 1, 9.56, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 19, 2, 27.75, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (113, 43, 10, 18.78, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 73, 8, 17.02, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 20, 1, 9.89, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 35, 9, 33.05, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 43, 7, 5.12, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 11, 2, 14.44, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 20, 3, 9.2, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 68, 9, 19.1, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 18, 8, 13.87, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 31, 1, 37.28, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (114, 25, 7, 15.3, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 44, 7, 26.2, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 58, 1, 38.87, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 72, 6, 13.23, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 29, 3, 7.5, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 1, 10, 7.4, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 45, 7, 24.63, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 17, 5, 28.19, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 71, 2, 7.48, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 24, 1, 31.31, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (115, 59, 10, 26.09, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 63, 4, 19.18, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 63, 10, 38.37, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 19, 1, 13.16, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 22, 3, 4.53, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 49, 10, 5.64, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 15, 10, 18.72, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 43, 1, 38.34, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 38, 6, 28.26, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 60, 7, 18.37, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (116, 23, 2, 39.61, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 64, 3, 14.26, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 56, 10, 35.41, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 34, 3, 31.71, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 2, 6, 10.3, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 50, 5, 30.53, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 38, 5, 12.67, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 25, 6, 14.53, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 38, 5, 5.34, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 17, 1, 38.14, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (117, 75, 3, 19.54, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 10, 10, 26.44, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 67, 4, 5.92, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 61, 2, 7.79, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 26, 1, 24.36, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 62, 7, 22.33, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 20, 3, 15.92, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 2, 4, 5.96, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 51, 9, 14.16, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 54, 10, 34.64, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (118, 44, 7, 13.81, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 8, 6, 12.21, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 62, 7, 14.01, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 47, 3, 38.7, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 30, 8, 9.66, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 17, 9, 32.87, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 50, 6, 15.02, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 22, 9, 17.28, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 50, 3, 28.87, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 30, 7, 27.48, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (119, 31, 6, 19.12, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 13, 4, 25.38, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 17, 9, 4.02, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 63, 3, 39.91, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 73, 1, 27.51, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 57, 7, 4.62, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 18, 3, 35.96, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 70, 3, 25.07, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 46, 6, 11.52, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 66, 3, 35.88, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (120, 16, 3, 8.77, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 30, 6, 30.25, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 45, 4, 34.33, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 28, 6, 33.72, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 49, 5, 6.13, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 60, 9, 17.33, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 3, 7, 38.12, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 21, 10, 17.2, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 6, 2, 32.61, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 38, 4, 6.14, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (121, 5, 8, 33.49, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 46, 3, 34.07, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 36, 9, 37.1, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 31, 5, 22.86, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 34, 8, 11.92, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 63, 1, 37.45, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 69, 7, 27.95, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 42, 8, 22.57, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 18, 9, 10.45, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 56, 6, 14.74, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (122, 48, 4, 8.87, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 29, 8, 23.68, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 38, 7, 38.79, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 65, 6, 13.52, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 13, 5, 6.35, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 6, 6, 17.95, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 10, 3, 4.6, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 25, 3, 27.33, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 60, 4, 19.21, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 51, 10, 5.57, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (123, 6, 2, 37.07, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 18, 7, 26.4, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 63, 7, 5.38, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 55, 5, 21.2, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 30, 9, 19.78, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 3, 6, 22.46, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 61, 5, 21.18, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 43, 10, 27.42, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 16, 10, 37.45, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 30, 5, 37.27, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (124, 30, 7, 4.64, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 28, 1, 9.3, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 2, 1, 22.59, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 7, 9, 34.16, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 60, 6, 34.3, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 10, 10, 30.66, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 3, 10, 8.26, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 9, 4, 32.14, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 21, 1, 33.05, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 40, 9, 21.31, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (125, 17, 5, 5.06, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 69, 5, 30.19, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 48, 4, 30.4, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 3, 8, 8.08, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 2, 5, 38.11, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 19, 2, 30.07, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 16, 7, 14.91, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 24, 1, 9.15, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 8, 5, 37.93, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 41, 1, 39.58, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (126, 43, 8, 29.24, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 28, 10, 9.33, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 41, 2, 20.64, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 52, 9, 25.33, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 4, 5, 26.06, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 62, 7, 31.42, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 38, 2, 5.18, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 58, 2, 14.1, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 65, 2, 6.06, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 74, 2, 20.04, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (127, 50, 1, 20.06, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 43, 5, 33.87, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 2, 1, 5.92, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 10, 2, 21.17, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 72, 4, 29.95, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 75, 1, 28.39, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 49, 5, 25.1, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 5, 6, 15.26, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 10, 2, 38.56, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 47, 3, 11.89, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (128, 16, 3, 27.32, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 32, 1, 35.28, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 71, 9, 38.11, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 44, 7, 39.97, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 64, 2, 11.87, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 1, 3, 15.3, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 71, 7, 24.88, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 16, 7, 17.45, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 71, 1, 8.07, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 28, 5, 14.21, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (129, 48, 4, 13.41, 19);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 42, 2, 29.25, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 65, 3, 36.9, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 10, 9, 25.45, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 48, 5, 4.73, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 67, 4, 28.48, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 67, 2, 33.7, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 18, 5, 37.94, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 21, 7, 22.77, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 67, 7, 15.85, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (130, 67, 2, 23.71, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 2, 3, 7.22, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 51, 9, 10.74, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 41, 2, 31.06, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 2, 6, 20.76, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 20, 4, 16.43, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 43, 10, 17.41, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 3, 5, 34.55, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 18, 6, 16.45, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 4, 2, 20.48, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (131, 58, 5, 36.19, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 53, 9, 14.53, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 39, 7, 9.2, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 67, 2, 11.41, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 15, 6, 11.58, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 2, 7, 6.76, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 16, 2, 36.75, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 13, 6, 11.71, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 49, 1, 31.13, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 29, 9, 6.99, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (132, 25, 4, 31.06, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 34, 2, 23.91, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 59, 9, 11.06, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 32, 3, 22.04, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 9, 5, 19.46, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 43, 8, 22.02, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 38, 4, 33.06, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 7, 1, 30.07, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 24, 5, 16.3, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 4, 4, 8.69, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (133, 60, 10, 13.25, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 8, 2, 17.08, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 22, 6, 37.22, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 37, 10, 24.39, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 10, 1, 16.05, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 61, 9, 34.52, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 23, 8, 33.04, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 42, 1, 8.96, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 74, 4, 23.91, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 66, 10, 8.67, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (134, 6, 10, 22.96, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 10, 10, 19.14, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 19, 6, 4.49, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 58, 3, 27.49, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 25, 1, 23.92, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 24, 2, 7.24, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 41, 2, 37.94, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 4, 10, 25.69, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 23, 4, 11.96, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 74, 7, 24.78, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (135, 45, 1, 13.86, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 5, 6, 38.48, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 16, 3, 14.32, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 66, 2, 15.37, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 74, 4, 10.1, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 1, 8, 14.4, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 65, 9, 35.41, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 67, 7, 7.67, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 68, 1, 39.15, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 21, 9, 37.59, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (136, 40, 9, 33.74, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 43, 4, 9.91, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 70, 2, 27.3, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 6, 2, 27.57, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 58, 6, 37.65, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 16, 5, 17.37, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 51, 4, 6.14, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 23, 1, 34.4, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 17, 2, 37.27, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 75, 3, 36.81, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (137, 60, 2, 23.45, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 73, 1, 34.83, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 45, 4, 24.17, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 64, 5, 15.59, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 72, 7, 28.11, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 29, 6, 25.6, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 71, 4, 29.4, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 74, 10, 13.58, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 32, 1, 33.24, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 41, 2, 25.51, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (138, 58, 1, 10.39, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 23, 3, 10.92, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 65, 2, 29.48, 38);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 18, 9, 8.24, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 3, 7, 11.3, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 65, 8, 38.94, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 28, 2, 20.98, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 33, 7, 13.21, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 63, 1, 4.51, 8);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 50, 6, 5.59, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (139, 47, 8, 29.2, 23);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 68, 5, 35.38, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 45, 6, 24.35, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 59, 6, 24.86, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 71, 9, 15.25, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 10, 10, 32.1, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 16, 8, 24.37, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 75, 3, 18.92, 36);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 8, 4, 32.8, 24);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 32, 7, 16.79, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (140, 21, 10, 23.55, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 48, 4, 10.99, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 17, 5, 26.43, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 32, 10, 4.17, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 51, 5, 14.83, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 52, 10, 17.31, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 33, 4, 13.18, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 63, 7, 5.66, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 40, 3, 26.53, 49);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 52, 10, 22.53, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (141, 51, 6, 17.5, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 34, 5, 23.77, 9);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 50, 1, 25.16, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 72, 1, 32.67, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 19, 7, 35.29, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 52, 2, 14.58, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 72, 3, 18.89, 39);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 53, 7, 35.15, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 22, 9, 15.53, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 29, 9, 7.91, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (142, 38, 3, 10.69, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 4, 7, 23.85, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 70, 7, 9.42, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 65, 6, 35.55, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 8, 8, 36.42, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 12, 4, 34.1, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 18, 2, 11.06, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 57, 7, 7.08, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 44, 1, 17.92, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 23, 9, 39.19, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (143, 1, 8, 10.95, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 69, 9, 12.64, 6);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 12, 1, 12.03, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 31, 6, 31.52, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 50, 3, 35.95, 15);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 64, 1, 31.26, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 12, 3, 25.23, 44);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 32, 1, 8.85, 50);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 61, 3, 36.75, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 23, 5, 6.9, 18);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (144, 13, 9, 27.15, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 42, 10, 22.4, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 6, 9, 31.97, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 49, 1, 22.7, 12);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 38, 1, 22.54, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 63, 5, 7.7, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 55, 3, 22.33, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 68, 3, 17.92, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 48, 5, 15.94, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 24, 7, 37.08, 25);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (145, 18, 10, 12.18, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 68, 1, 25.63, 35);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 37, 6, 27.26, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 6, 10, 15.54, 4);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 25, 3, 27.05, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 35, 4, 34.88, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 69, 2, 18.71, 3);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 68, 3, 32.22, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 28, 9, 33.78, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 55, 8, 35.7, 34);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (146, 40, 3, 19.71, 42);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 20, 6, 18.42, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 54, 4, 27.01, 30);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 24, 4, 21.81, 14);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 23, 9, 37.93, 45);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 37, 10, 18.19, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 59, 1, 6.45, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 23, 9, 37.04, 33);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 73, 8, 4.17, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 28, 10, 4.59, 31);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (147, 50, 3, 12.23, 20);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 14, 5, 38.34, 2);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 24, 4, 28.55, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 9, 2, 21.66, 32);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 7, 4, 15.09, 16);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 34, 9, 19.3, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 39, 4, 22.65, 22);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 57, 4, 39.26, 29);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 53, 10, 22.69, 1);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 55, 2, 39.02, 46);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (148, 27, 7, 33.07, 10);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 18, 5, 14.56, 21);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 46, 3, 18.19, 17);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 53, 2, 14.41, 40);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 31, 10, 7.2, 11);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 14, 8, 4.14, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 58, 8, 15.14, 13);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 13, 2, 31.88, 0);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 37, 8, 6.41, 5);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 45, 4, 30.2, 26);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (149, 48, 6, 22.69, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 34, 8, 19.19, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 33, 7, 32.52, 48);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 29, 3, 21.88, 7);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 31, 1, 15.96, 41);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 69, 6, 33.95, 37);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 55, 8, 30.17, 27);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 41, 4, 5.17, 43);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 23, 6, 11.47, 28);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 44, 3, 10.06, 47);
insert into linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) values (150, 71, 4, 13.83, 7);

UPDATE linea_pedido SET precio_final = (ROUND((precio_unitario - precio_unitario * descuento / 100) * cantidad,2)
);

UPDATE pedidos p SET precio_total = (SELECT ROUND(SUM(precio_final),2)
									 FROM linea_pedido l
									 WHERE p.id = l.id_pedido
);

--ÍNDICE
CREATE INDEX ind_usuarios_dni ON usuarios (dni);
CREATE INDEX ind_usuarios_apellidos ON usuarios (apellidos);
CREATE INDEX ind_marcas_nombre ON marcas (nombre);
CREATE INDEX ind_variantes_nombre ON variantes (nombre);
CREATE INDEX ind_categorias_nombre ON categorias (nombre);
CREATE INDEX ind_productos_nombre ON productos (nombre);
CREATE INDEX ind_productos_talla ON productos (talla);
CREATE INDEX ind_productos_color ON productos (color);
CREATE INDEX ind_empleados_dni ON empleados (dni);
CREATE INDEX ind_empleados_apellidos ON empleados (apellidos);
CREATE INDEX ind_departamentos_nombre ON departamentos (nombre);
CREATE INDEX ind_pedidos_fecha ON pedidos (fecha_pedido);
CREATE INDEX ind_pedidos_preciototal ON pedidos (precio_total);
CREATE INDEX ind_linea_pedidos_preciofinal ON linea_pedido (precio_final);




