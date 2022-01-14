CREATE TABLE empresa(
	cif				varchar(10) NOT NULL,
	nombre			varchar(100) NOT NULL,
	direccion		varchar(200),
	telefono		varchar(20),
	CONSTRAINT pk_empresa PRIMARY KEY (cif)
);

CREATE TABLE alumnos(
	dni				varchar(10) NOT NULL,
	nombre			varchar(100) NOT NULL,
	direccion		varchar(200),
	telefono		varchar(20),
	edad			smallint,
	empresa			varchar(10),
	CONSTRAINT pk_alumno PRIMARY KEY (dni)
);

ALTER TABLE alumnos ADD CONSTRAINT fk_alumno_empresa FOREIGN KEY (empresa) REFERENCES empresa;

CREATE TABLE profesores(
	dni				varchar(10) NOT NULL,
	nombre			varchar(100) NOT NULL,
	apellidos		varchar(200) NOT NULL,
	telefono		varchar(20) NOT NULL,
	direccion		varchar(100) NOT NULL,
	CONSTRAINT pk_profesores PRIMARY KEY (dni)
);

CREATE TABLE tipo_curso(
	cod_curso		smallint NOT NULL,
	duracion		smallint,
	programa		varchar(100),
	titulo			varchar(150),
	CONSTRAINT pk_tipo_curso PRIMARY KEY (cod_curso)
);

CREATE TABLE cursos(
	n_concreto		smallint NOT NULL,
	fecha_inicio	date,
	fecha_fin		date,
	dni_profesor	varchar(10),
	tipo_curso		smallint,
	CONSTRAINT pk_cursos PRIMARY KEY (n_concreto)
);

CREATE TABLE alumnos_asisten(
	dni				varchar(10),
	n_concreto		smallint,
	CONSTRAINT pk_alumnos_asisten PRIMARY KEY (dni)
);

ALTER TABLE cursos ADD CONSTRAINT fk_cursos_profesor FOREIGN KEY (dni_profesor) REFERENCES profesores;
ALTER TABLE cursos ADD CONSTRAINT fk_cursos_tipo_curso FOREIGN KEY (tipo_curso) REFERENCES tipo_curso;
ALTER TABLE alumnos_asisten ADD CONSTRAINT fk_alumnos_asisten_alumnos FOREIGN KEY (dni) REFERENCES alumnos;
ALTER TABLE alumnos_asisten ADD CONSTRAINT fk_alumnos_asisten_cursos FOREIGN KEY (n_concreto) REFERENCES cursos;