CREATE TABLE alumno(
	dni				varchar(9),
	nombre			varchar(100),
	CONSTRAINT pk_alumno PRIMARY KEY (dni)
);

CREATE TABLE asignatura(
	cod_asignatura	serial,
	nombre			varchar(100),
	CONSTRAINT pk_asignatura PRIMARY KEY (cod_asignatura)
);

CREATE TABLE matricula(
	dni				varchar(9),
	cod_asignatura	integer,
	anio			integer,
	CONSTRAINT pk_matricula PRIMARY KEY (dni, cod_asignatura, anio),
	CONSTRAINT fk_matricula_alumno FOREIGN KEY (dni) REFERENCES alumno,
	CONSTRAINT fk_matricula_asignatura FOREIGN KEY (cod_asignatura) REFERENCES asignatura
);

CREATE TABLE notas(
	dni				varchar(9),
	evaluacion		varchar(2),
	cod_asignatura	integer,
	anio			integer,
	nota			smallint,
	CONSTRAINT pk_notas PRIMARY KEY (dni, cod_asignatura, anio , nota, evaluacion),
	CONSTRAINT fk_notas_matricula FOREIGN KEY (dni, cod_asignatura, anio) REFERENCES matricula (dni, cod_asignatura, anio)
);

-- Después de REFERENCES si tenemos una clave externa compuesta tendremos que poner entre paréntesis a que 
-- columna hace referencia en el orden dado en el paréntesis de FOREIGN KEY.