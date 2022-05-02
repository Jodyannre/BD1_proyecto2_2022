#**********************************REGISTRAR NACIMIENTO****************************************
#Regisro valido
CALL registrarNacimiento(1000000010101,1000020020402,'Joan','Adalberto','Romeo','22-06-1988',612,'M');

#Nombre obligatorio
CALL registrarNacimiento(1000000010101,1000020020402,'','Adalberto','Romeo','22-06-2022',612,'M');

#Nombres opcionaloes
CALL registrarNacimiento(1000000010101,1000020020402,'Carlos','','','22-03-2022',612,'M');

#Nombres con letras
CALL registrarNacimiento(1000000010101,1000020020402,'Joan2','','','22-06-2022',612,'M');

#No menores de edad
CALL registrarNacimiento(1000040010101,1000020020402,'Joan','Adalberto','Romeo','22-06-2022',612,'M');

SELECT * FROM persona;
SELECT * FROM nombre;
SELECT * FROM apellido;
#**********************************************************************************************




#**********************************REGISTRAR DEFUNCION*****************************************
#DEFUNCION VALIDA
CALL addDefuncion(1000041031503,'14-11-2021','Se electrocuto con la plancha.');

#QUE EL CUI EXISTA
CALL addDefuncion(2000041031503,'14-11-2021','Se electrocuto con la plancha.');

#VALIDACION DE FECHA
CALL addDefuncion(1000042031503,'14-11-1992','Se electrocuto con la plancha.');

#**********************************************************************************************


#**********************************REGISTRAR MATRIMONIO****************************************
#REGISTRO VALIDO
CALL addMatrimonio(1000043031203,1000045030803,'01-05-2020');

#MAYORES DE EDAD Y TENER DPI
CALL addMatrimonio(1000040010101,1000046031503,'12-05-2020');

#NO CASARSE MAS DE UNA VEZ
CALL addMatrimonio(1000044030903,1000045030803,'01-05-2020');
#**********************************************************************************************




#**********************************REGISTRAR DIVORCIO******************************************
#FECHA CORRECTA
CALL addDivorcio(16,'01-04-2020');

#REGISTRO VALIDO
CALL addDivorcio(16,'02-06-2020');

#MATRIMONIO ACTIVO
CALL addDivorcio(16,'02-06-2020');
#**********************************************************************************************


#**********************************REGISTRAR LICENCIA******************************************
#REGISTRO VALIDO
CALL addLicencia(1000044030903,'07-04-2016','C');
CALL addLicencia(1000045030803,'07-04-2016','C');

#LICENCIA VALIDA EN PRIMER REGISTRO
CALL addLicencia(1000044030903,'07-04-2020','B');

#LICENCIA EXTRA TIPO E
CALL addLicencia(1000044030903,'07-04-2020','E');
#**********************************************************************************************



#**********************************RENOVACION LICENCIA*****************************************
SELECT * FROM LICENCIA;
CALL actualizarEstadoLicencias();
#RENOVACION VALIDA
CALL renewLicencia(13,'11-06-2017','C',3);
CALL renewLicencia(12,'11-06-2018','C',3);
#LICENCIA C -> B
CALL renewLicencia(13,'11-06-2021','B',1);
#LICENCIA B -> A
CALL renewLicencia(12,'11-06-2020','A',3);
#**********************************************************************************************


#**********************************ANULAR LICENCIA*********************************************
CALL anularLicencia(14,'30-06-20','Exceso de velocidad.');
CALL renewLicencia(14,'12-11-2021','B',1);
#**********************************************************************************************



#**********************************GENERAR DPI*************************************************
#NACIO EN 1993 Y EL OTRO EN 1988
SELECT * FROM DPI WHERE id_persona = 1000047;
#VALIDACION DE FECHA
CALL generarDpi(1000047031503,'30-08-2000',610);
CALL generarDpi(1000048061206,'30-08-1987',610);
#CORRECTA
CALL generarDpi(1000047031503,'30-08-2017',610);
CALL generarDpi(1000048061206,'30-08-2008',610);
#ESTADO SOLTERO
SELECT * FROM PERSONA WHERE cui = '1000047031503';
SELECT * FROM PERSONA WHERE cui = '1000048061206';
#**********************************************************************************************


#*************************************REPORTES*************************************************
CALL getNacimiento(1000048061206);
CALL getDpi(1000048061206);
CALL getLicencias(1000044030903);
CALL getDivorcio(16);
CALL getDefuncion(1000041031503);
CALL getMatrimonio(16);
#**********************************************************************************************