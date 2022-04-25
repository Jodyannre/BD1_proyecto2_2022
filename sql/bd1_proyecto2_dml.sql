#--------------------------INICIALIZAR EL AUTO INCREMENT DE PERSONA
ALTER TABLE PERSONA AUTO_INCREMENT = 1000000;

#--------------------------ESTADOS QUE TENDRAN LOS MATRIMONIOS
INSERT INTO ESTADO_MATRIMONIO (nombre_estado_matrimonio) VALUES ('Activo');
INSERT INTO ESTADO_MATRIMONIO (nombre_estado_matrimonio) VALUES ('Inactivo');


#-------------------------ESTADOS CIVILES DE LAS PERSONAS
INSERT INTO ESTADO_CIVIL (nombre_estado_civil) VALUES ('Soltero');
INSERT INTO ESTADO_CIVIL (nombre_estado_civil) VALUES ('Casado');
INSERT INTO ESTADO_CIVIL (nombre_estado_civil) VALUES ('Divorciado');
INSERT INTO ESTADO_CIVIL (nombre_estado_civil) VALUES ('Viodo');


#-------------------------ESTADOS POSIBLES DE LAS PERSONAS
INSERT INTO ESTADO_PERSONA (nombre_estado_persona) VALUES ('Vivo');
INSERT INTO ESTADO_PERSONA (nombre_estado_persona) VALUES ('Fallecido');

#-------------------------GENEROS DE LAS PERSONAS
INSERT INTO GENERO (nombre_genero) VALUES ('Masculino');
INSERT INTO GENERO (nombre_genero) VALUES ('Femenino');

#-------------------------DEPARTAMENTOS CON CARGA MASIVA
SELECT * FROM DEPARTAMENTO;

#-------------------------MUNICIPIOS CON CARGA MASIVA
SELECT * FROM MUNICIPIO;


#-------------------------ESTADOS DE LAS LICENCIAS
INSERT INTO ESTADO_LICENCIA (nombre_estado_licencia) VALUES ('Activa');
INSERT INTO ESTADO_LICENCIA (nombre_estado_licencia) VALUES ('Vencida');
INSERT INTO ESTADO_LICENCIA (nombre_estado_licencia) VALUES ('Anulada');

#-------------------------TIPOS DE LICENCIAS
INSERT INTO TIPO_LICENCIA (nombre_tipo_licencia) VALUES ('A');
INSERT INTO TIPO_LICENCIA (nombre_tipo_licencia) VALUES ('B');
INSERT INTO TIPO_LICENCIA (nombre_tipo_licencia) VALUES ('C');
INSERT INTO TIPO_LICENCIA (nombre_tipo_licencia) VALUES ('M');
INSERT INTO TIPO_LICENCIA (nombre_tipo_licencia) VALUES ('E');
#-------------------------ESTADOS DE ANULACION
INSERT INTO ESTADO_ANULACION (nombre_estado_anulacion) VALUES ('Activa');
INSERT INTO ESTADO_ANULACION (nombre_estado_anulacion) VALUES ('Finalizada');
#-------------------------
#-------------------------
#-------------------------

