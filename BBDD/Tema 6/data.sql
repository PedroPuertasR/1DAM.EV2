/*
 Examen de la unidad didáctica 6
 Bases de datos - 1º Desarrollo de Aplicaciones Multiplataforma
 */
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
    SYSDATE
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

