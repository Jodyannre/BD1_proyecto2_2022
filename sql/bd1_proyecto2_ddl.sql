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

CREATE TABLE ANULACION_LICENCIA (
	id_anulacion_licencia INT AUTO_INCREMENT PRIMARY KEY,
    fecha_anulacion DATE NOT NULL,
    motivo_anulacion VARCHAR(100) NOT NULL
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

CREATE TABLE LICENCIA(
	id_licencia INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    id_tipo_licencia INT NOT NULL,
    CONSTRAINT FK_tipo_licencia FOREIGN KEY (id_tipo_licencia)
    REFERENCES tipo_licencia(id_tipo_licencia)
);

CREATE TABLE DPI (
	id_dpi INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision_dpi DATE NOT NULL,
    id_municipio INT NOT NULL,
    CONSTRAINT FK_municipio FOREIGN KEY (id_municipio)
    REFERENCES municipio(id_municipio)
);

CREATE TABLE CATALOGO_ANULACION (
	id_catalogo_anulacion INT AUTO_INCREMENT PRIMARY KEY,
    id_licencia INT NOT NULL,
    id_estado_anulacion INT NOT NULL,
    id_anulacion_licencia INT NOT NULL,
    CONSTRAINT FK_licencia_catalogo_anulacion FOREIGN KEY (id_licencia)
    REFERENCES licencia(id_licencia),
    CONSTRAINT FK_estado_anulacion FOREIGN KEY (id_estado_anulacion)
    REFERENCES estado_anulacion(id_estado_anulacion),
    CONSTRAINT FK_anulacion_licencia_catalogo FOREIGN KEY (id_anulacion_licencia)
    REFERENCES anulacion_licencia(id_anulacion_licencia)
);

CREATE TABLE PERSONA (
	id_persona INT AUTO_INCREMENT PRIMARY KEY,
    cui VARCHAR(20) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50) NOT NULL,
    tercer_nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    id_padre INT NOT NULL,
    id_madre INT NOT NULL,
    id_genero INT NOT NULL,
    id_municipio INT NOT NULL,
    id_estado_persona INT NOT NULL,
    id_estado_civil INT NOT NULL,
	id_dpi INT, 
    CONSTRAINT FK_padre_persona FOREIGN KEY (id_padre)
    REFERENCES persona(id_persona),
	CONSTRAINT FK_madre_persona FOREIGN KEY (id_madre)
    REFERENCES persona(id_persona),
	CONSTRAINT FK_genero_persona FOREIGN KEY (id_genero)
    REFERENCES genero(id_genero),
	CONSTRAINT FK_estado_persona FOREIGN KEY (id_estado_persona)
    REFERENCES estado_persona(id_estado_persona),
    CONSTRAINT FK_estado_civil_persona FOREIGN KEY (id_estado_civil)
    REFERENCES estado_civil(id_estado_civil),
    CONSTRAINT FK_dpi_persona FOREIGN KEY (id_dpi)
    REFERENCES dpi(id_dpi)
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

CREATE TABLE CATALOGO_LICENCIA (
	id_catalogo_licencia INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_licencia INT NOT NULL,
    id_estado_licencia INT NOT NULL,
    CONSTRAINT FK_persona_catalogo_licencia FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona),
    CONSTRAINT FK_licencia_catalogo_licencia FOREIGN KEY (id_licencia)
    REFERENCES licencia(id_licencia),
    CONSTRAINT FK_estado_licencia_catalogo_licencia FOREIGN KEY (id_estado_licencia)
    REFERENCES estado_licencia(id_estado_licencia)
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
DROP TABLE PERSONA;
DROP TABLE CATALOGO_ANULACION;
DROP TABLE DPI;
DROP TABLE LICENCIA;
DROP TABLE MUNICIPIO;
DROP TABLE ESTADO_ANULACION;
DROP TABLE ANULACION_LICENCIA;
DROP TABLE TIPO_LICENCIA;
DROP TABLE ESTADO_LICENCIA;
DROP TABLE DEPARTAMENTO;
DROP TABLE GENERO;
DROP TABLE ESTADO_PERSONA;
DROP TABLE ESTADO_CIVIL;
DROP TABLE ESTADO_MATRIMONIO;





















