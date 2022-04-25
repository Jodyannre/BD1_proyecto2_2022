CREATE TABLE ESTADO_MATRIMONIO (
    id_estado_matrimonio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado_matrimonio VARCHAR(50) NOT NULL
);

CREATE TABLE ESTADO_CIVIL (
	id_estado_civil INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado_civil VARCHAR(50) NOT NULL
);

CREATE TABLE ESTADO_PERSONA (
	id_estado_persona INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado_persona VARCHAR(50) NOT NULL
);

CREATE TABLE GENERO (
	id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(50) NOT NULL
);

CREATE TABLE DEPARTAMENTO (
	id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(50) NOT NULL
);

CREATE TABLE ESTADO_LICENCIA (
	id_estado_licencia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado_licencia VARCHAR(50) NOT NULL
);

CREATE TABLE TIPO_LICENCIA (
	id_tipo_licencia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_licencia VARCHAR(50) NOT NULL
);

CREATE TABLE ESTADO_ANULACION (
	id_estado_anulacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado_anulacion VARCHAR(50) NOT NULL
);

CREATE TABLE MUNICIPIO (
	id_municipio INT PRIMARY KEY,
    nombre_municipio VARCHAR(50) NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT FK_departamento FOREIGN KEY (id_departamento)
    REFERENCES departamento(id_departamento)
);

CREATE TABLE PERSONA (
	id_persona INT AUTO_INCREMENT PRIMARY KEY,
    cui VARCHAR(13),
    fecha_nacimiento DATE NOT NULL,
    id_padre INT,
    id_madre INT,
    id_genero INT NOT NULL,
    id_municipio INT NOT NULL,
    id_estado_persona INT NOT NULL,
    id_estado_civil INT NOT NULL,
	/*id_dpi INT,*/ 
    CONSTRAINT FK_padre_persona FOREIGN KEY (id_padre)
    REFERENCES persona(id_persona),
	CONSTRAINT FK_madre_persona FOREIGN KEY (id_madre)
    REFERENCES persona(id_persona),
	CONSTRAINT FK_genero_persona FOREIGN KEY (id_genero)
    REFERENCES genero(id_genero),
	CONSTRAINT FK_estado_persona FOREIGN KEY (id_estado_persona)
    REFERENCES estado_persona(id_estado_persona),
    CONSTRAINT FK_estado_civil_persona FOREIGN KEY (id_estado_civil)
    REFERENCES estado_civil(id_estado_civil)
    /*
    CONSTRAINT FK_dpi_persona FOREIGN KEY (id_dpi)
    REFERENCES dpi(id_dpi)
    */
);

CREATE TABLE NOMBRE (
	id_nombre INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
    id_persona INT,
    CONSTRAINT FK_nombre_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

CREATE TABLE APELLIDO (
	id_apellido INT AUTO_INCREMENT PRIMARY KEY,
	apellido VARCHAR(50),
    id_persona INT,
    CONSTRAINT FK_apellido_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);


CREATE TABLE LICENCIA(
	id_licencia INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    id_tipo_licencia INT NOT NULL,
    id_estado_licencia INT NOT NULL,
	CONSTRAINT FK_persona_licencia FOREIGN KEY (id_persona)
    REFERENCES PERSONA(id_persona),
    CONSTRAINT FK_tipo_licencia FOREIGN KEY (id_tipo_licencia)
    REFERENCES tipo_licencia(id_tipo_licencia),
    CONSTRAINT FK_estado_licencia FOREIGN KEY (id_estado_licencia)
    REFERENCES ESTADO_LICENCIA(id_estado_licencia)
);


CREATE TABLE ANULACION_LICENCIA (
	id_anulacion_licencia INT AUTO_INCREMENT PRIMARY KEY,
    id_licencia INT NOT NULL,
    fecha_anulacion DATE NOT NULL,
    fecha_fin_anulacion DATE NOT NULL,
    motivo_anulacion VARCHAR(100) NOT NULL,
    id_estado_anulacion INT NOT NULL,
    CONSTRAINT FK_licencia_catalogo_anulacion FOREIGN KEY (id_licencia)
    REFERENCES licencia(id_licencia),
    CONSTRAINT FK_estado_anulacion FOREIGN KEY (id_estado_anulacion)
    REFERENCES estado_anulacion(id_estado_anulacion)
);


CREATE TABLE CATALOGO_LICENCIA (
	id_catalogo_licencia INT AUTO_INCREMENT PRIMARY KEY,
    id_licencia INT NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    id_tipo_licencia INT NOT NULL,
    CONSTRAINT FK_licencia_catalogo_licencia FOREIGN KEY (id_licencia)
    REFERENCES licencia(id_licencia),
    CONSTRAINT FK_tipo_licencia_catalogo_licencia FOREIGN KEY (id_tipo_licencia)
    REFERENCES TIPO_LICENCIA(id_tipo_licencia)
);

CREATE TABLE DPI (
	id_dpi INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision_dpi DATE NOT NULL,
    id_municipio INT NOT NULL,
    id_persona INT NOT NULL,
    CONSTRAINT FK_municipio FOREIGN KEY (id_municipio)
    REFERENCES municipio(id_municipio),
    CONSTRAINT FK_persona_dpi FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

CREATE TABLE MATRIMONIO (
	id_matrimonio INT AUTO_INCREMENT PRIMARY KEY,
    fecha_matrimonio DATE NOT NULL,
    id_esposo INT NOT NULL,
    id_esposa INT NOT NULL,
    id_estado_matrimonio INT NOT NULL,    
    CONSTRAINT FK_esposo_matrimonio FOREIGN KEY (id_esposo)
    REFERENCES persona(id_persona),
	CONSTRAINT FK_esposa_matrimonio FOREIGN KEY (id_esposa)
    REFERENCES persona(id_persona),
    CONSTRAINT FK_estado_matrimonio FOREIGN KEY (id_estado_matrimonio)
    REFERENCES estado_matrimonio(id_estado_matrimonio)
);


CREATE TABLE DEFUNCION (
	id_defucion INT AUTO_INCREMENT PRIMARY KEY,
    fecha_defuncion DATE NOT NULL, 
    motivo_defuncion VARCHAR(100),
    id_persona INT NOT NULL,
	CONSTRAINT FK_persona_defuncion FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

CREATE TABLE DIVORCIO (
	id_divorcio INT AUTO_INCREMENT PRIMARY KEY,
    fecha_divorcio DATE NOT NULL,
    id_matrimonio INT NOT NULL,
	CONSTRAINT FK_matrimonio_divorcio FOREIGN KEY (id_matrimonio)
    REFERENCES matrimonio(id_matrimonio)
);

DROP TABLE DIVORCIO;
DROP TABLE DEFUNCION;
DROP TABLE CATALOGO_LICENCIA;
DROP TABLE MATRIMONIO;
DROP TABLE DPI;
DROP TABLE ANULACION_LICENCIA;
DROP TABLE LICENCIA;
DROP TABLE NOMBRE;
DROP TABLE APELLIDO;
DROP TABLE PERSONA;
DROP TABLE MUNICIPIO;
DROP TABLE ESTADO_ANULACION;
DROP TABLE TIPO_LICENCIA;
DROP TABLE ESTADO_LICENCIA;
DROP TABLE DEPARTAMENTO;
DROP TABLE GENERO;
DROP TABLE ESTADO_PERSONA;
DROP TABLE ESTADO_CIVIL;
DROP TABLE ESTADO_MATRIMONIO;





















