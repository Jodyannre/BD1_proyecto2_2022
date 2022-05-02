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

#-------------------------CREAR PERSONAS PADRES BASE
CALL crearPersonaSinPadres('Fernando','José','','Torres','Sanz','12-01-1965',101,'M');
CALL crearPersonaSinPadres('David','','','Villa','Sánchez','12-02-1995',102,'M');
CALL crearPersonaSinPadres('Andrés','Israel','','Iniesta','Luján','12-03-1995',103,'M');
CALL crearPersonaSinPadres('Xavier','Carlos','','Hernández','Creus','12-04-1995',104,'M');
CALL crearPersonaSinPadres('Lionel','Andrés','','Messi','Cuccittini','12-05-1995',105,'M');
CALL crearPersonaSinPadres('Cristiano','Ronaldo','','Santos','Aveiro','12-06-1995',106,'M');
CALL crearPersonaSinPadres('Iker','Antonio','','Casillas','Fernández','12-07-1995',107,'M');
CALL crearPersonaSinPadres('Gerard','Bryn','','Piqué','Bernabéu','12-08-1995',108,'M');
CALL crearPersonaSinPadres('Daniel','Marcos','','Carvajal','Ramos','12-09-1995',109,'M');
CALL crearPersonaSinPadres('Sergio','Andres','','Ramos','García','12-10-1995',110,'M');
CALL crearPersonaSinPadres('Jordi','','','Alba','Cevallos','12-11-1995',111,'M');
CALL crearPersonaSinPadres('Josep','','','Pedrerol','Alonso','12-12-1995',112,'M');
CALL crearPersonaSinPadres('Joaquim','','','Doménech','Puigbó','12-01-1996',113,'M');
CALL crearPersonaSinPadres('Alfredo','','','Duro','Puig','12-02-1996',114,'M');
CALL crearPersonaSinPadres('Juan','Manuel','','Rodríguez','Cortés','12-03-1996',115,'M');
CALL crearPersonaSinPadres('Jordi','','','López','Felpeto','12-04-1996',116,'M');
CALL crearPersonaSinPadres('José','Luis','','Sánchez','Hernández','12-05-1996',117,'M');
CALL crearPersonaSinPadres('Karim','Esteban','','Benzema','Pogba','12-06-1996',201,'M');
CALL crearPersonaSinPadres('Luka','Manuel','','Modric','Valverde','12-07-1996',202,'M');
CALL crearPersonaSinPadres('Gareth','Frank','','Bale','Smith','12-08-1996',203,'M');
CALL crearPersonaSinPadres('Angelina','Fernanda','','Jolie','Voight','12-09-1966',204,'F');
CALL crearPersonaSinPadres('Emily','Jean','','Stone','Roberts','12-10-1996',205,'F');
CALL crearPersonaSinPadres('Emma','Charlotte','','Duerre','Lacaz','12-11-1996',206,'F');
CALL crearPersonaSinPadres('Jennifer','Amanda','','Shrader','Lawrence','12-12-1996',207,'F');
CALL crearPersonaSinPadres('Scarlett','Ingrid','','Johansson','Blitss','12-01-1997',208,'F');
CALL crearPersonaSinPadres('Natalie','Ana','','Portman','Millepied','12-02-1997',301,'F');
CALL crearPersonaSinPadres('Kristen','Jaymes','','Stewart','Cink','12-03-1997',302,'F');
CALL crearPersonaSinPadres('Anya','Josephine','','Taylor','Joy','12-04-1997',303,'F');
CALL crearPersonaSinPadres('Amanda','Alexa','','Peet','Phillips','12-05-1997',304,'F');
CALL crearPersonaSinPadres('Morgan','Lily','','Bendette','Salom','12-06-1997',305,'F');
CALL crearPersonaSinPadres('Thandiwe','Adjewa','','Newton','Johnson','12-07-1997',306,'F');
CALL crearPersonaSinPadres('Diane','Hall','','Keaton','Pizjuan','12-08-1997',307,'F');
CALL crearPersonaSinPadres('Ashley','Tyler','','Ciminella','Judd','12-09-1997',308,'F');
CALL crearPersonaSinPadres('Rachel','Rae','','Rye','Kepler','12-10-1997',309,'F');
CALL crearPersonaSinPadres('Emily','Olivia','Leah','Blunt','Roses','12-11-1997',310,'F');
CALL crearPersonaSinPadres('Mary','Louise','','Streep','Street','12-12-1997',311,'F');
CALL crearPersonaSinPadres('Nicole','Marry','','Kidman','Gibson','12-01-1998',312,'F');
CALL crearPersonaSinPadres('Kate','Elizabeth','','Winslet','Donovan','12-02-1998',313,'F');
CALL crearPersonaSinPadres('Emmy','Glenn','','Close','Open','12-03-1998',314,'F');
CALL crearPersonaSinPadres('Maghala','','','Jaberi','Parker','12-04-1998',315,'F');
#MENOR DE EDADA
CALL crearPersonaSinPadres('Juan','Fernando','','Orozco','Miyares','12-01-2017',101,'M');
#PERSONA PARA DEFUNCION CORRECTA
CALL crearPersonaSinPadres('Elizabeth','','','Alvarez','Mendieta','12-04-1997',315,'F');
CALL crearPersonaSinPadres('Clarisa','','','Vega','Paz','02-02-1993',315,'F');

#PERSONAS PARA CASAMIENTO CORRECTO E INCORRECTO
CALL crearPersonaSinPadres('Carlos','','','Quiñonez','Sales','12-04-1997',312,'M');
CALL crearPersonaSinPadres('Juan','Roman','','Riquelme','Mandorin','02-02-1993',309,'M');

CALL crearPersonaSinPadres('Cecilia','','','Leght','Khan','12-04-1997',308,'F');
CALL crearPersonaSinPadres('Ruby','','','Fury','Holyfield','02-02-1993',315,'F');

#PERSONA PARA GENERAR DPI
CALL crearPersonaSinPadres('Rudy','','','Rosales','Alvarez','02-02-1993',315,'M');

#GENERAR LOS DPI DE LAS PERSONAS


#HOMBRES
CALL generarDpi(1000000010101,'21-01-1987',401);
CALL generarDpi(1000001010201,'22-02-2017',402);
CALL generarDpi(1000002010301,'23-03-2017',403);
CALL generarDpi(1000003010401,'24-04-2017',404);
CALL generarDpi(1000004010501,'25-05-2017',405);
CALL generarDpi(1000005010601,'26-06-2017',406);
CALL generarDpi(1000006010701,'27-07-2017',407);
CALL generarDpi(1000007010801,'28-08-2017',408);
CALL generarDpi(1000008010901,'29-09-2017',409);
CALL generarDpi(1000009011001,'30-10-2017',410);
CALL generarDpi(1000010011101,'01-11-2017',411);
CALL generarDpi(1000011011201,'02-12-2017',412);
CALL generarDpi(1000012011301,'03-01-2018',413);
CALL generarDpi(1000013011401,'04-02-2018',414);
CALL generarDpi(1000014011501,'05-03-2018',415);
CALL generarDpi(1000015011601,'06-04-2018',416);
CALL generarDpi(1000016011701,'07-05-2018',501);
CALL generarDpi(1000017020102,'08-06-2018',502);
CALL generarDpi(1000018020202,'09-07-2018',503);
CALL generarDpi(1000019020302,'10-08-2018',504);

#MUJERES
CALL generarDpi(1000020020402,'11-09-1988',505);
CALL generarDpi(1000021020502,'12-10-2018',506);
CALL generarDpi(1000022020602,'13-11-2018',507);
CALL generarDpi(1000023020702,'14-12-2018',508);
CALL generarDpi(1000024020802,'15-01-2019',509);
CALL generarDpi(1000025030103,'16-02-2019',510);
CALL generarDpi(1000026030203,'17-03-2019',511);
CALL generarDpi(1000027030303,'18-04-2019',512);
CALL generarDpi(1000028030403,'19-05-2019',513);
CALL generarDpi(1000029030503,'20-06-2019',514);
CALL generarDpi(1000030030603,'21-07-2019',601);
CALL generarDpi(1000031030703,'22-08-2019',602);
CALL generarDpi(1000032030803,'23-09-2019',603);
CALL generarDpi(1000033030903,'24-10-2019',604);
CALL generarDpi(1000034031003,'25-11-2019',605);
CALL generarDpi(1000035031103,'26-12-2019',606);
CALL generarDpi(1000036031203,'27-01-2020',607);
CALL generarDpi(1000037031303,'28-02-2020',608);
CALL generarDpi(1000038031403,'29-03-2020',609);
CALL generarDpi(1000039031503,'30-04-2020',610);


#DPI PERSONA PARA DEFUNCION
CALL generarDpi(1000041031503,'30-08-2017',610);
CALL generarDpi(1000042031503,'30-08-2017',610);

#DPI PERSONA PARA CASAMIENTO
#HOMBRES
CALL generarDpi(1000043031203,'30-08-2017',610);
CALL generarDpi(1000044030903,'30-08-2017',610);
#MUJERES
CALL generarDpi(1000045030803,'30-08-2017',610);
CALL generarDpi(1000046031503,'30-08-2017',610);



#GENERAR MATRIMONIOS
CALL addMatrimonio(1000000010101,1000020020402,'01-05-2020');
CALL addMatrimonio(1000001010201,1000021020502,'02-05-2020');
CALL addMatrimonio(1000002010301,1000022020602,'03-05-2020');
CALL addMatrimonio(1000003010401,1000023020702,'04-05-2020');
CALL addMatrimonio(1000004010501,1000024020802,'05-05-2020');
CALL addMatrimonio(1000005010601,1000025030103,'06-05-2020');
CALL addMatrimonio(1000006010701,1000026030203,'07-05-2020');
CALL addMatrimonio(1000007010801,1000027030303,'08-05-2020');
CALL addMatrimonio(1000008010901,1000028030403,'09-05-2020');
CALL addMatrimonio(1000009011001,1000029030503,'10-05-2020');
CALL addMatrimonio(1000010011101,1000030030603,'11-05-2020');
CALL addMatrimonio(1000011011201,1000031030703,'12-05-2020');
CALL addMatrimonio(1000012011301,1000032030803,'13-05-2020');
CALL addMatrimonio(1000013011401,1000033030903,'14-05-2020');
CALL addMatrimonio(1000014011501,1000034031003,'15-05-2020');



#GENERAR DIVORCIOS
CALL addDivorcio(11,'11-05-2020');
CALL addDivorcio(12,'12-04-2021');
CALL addDivorcio(13,'13-04-2021');
CALL addDivorcio(14,'14-04-2021');
CALL addDivorcio(15,'15-04-2021');

#DEFUNCIONES
CALL addDefuncion(1000035031103,'15-04-2018','Se cayo de las gradas.');
CALL addDefuncion(1000036031203,'01-03-2019','Se cayo de la bañera');
CALL addDefuncion(1000037031303,'12-02-2020','Se cayo de la cama.');
CALL addDefuncion(1000039031503,'21-01-2021','Se cayo de la silla.');
CALL addDefuncion(1000038031403,'14-11-2022','Se cayo del sillón.');


#LICENCIAS
CALL addLicencia(1000000010101,'07-04-2019','M');
CALL addLicencia(1000000010101,'08-03-2019','E');
CALL addLicencia(1000001010201,'09-02-2019','C');
CALL addLicencia(1000002010301,'01-01-2020','C');
CALL addLicencia(1000003010401,'02-05-2020','M');
CALL addLicencia(1000004010501,'03-06-2020','C');
CALL addLicencia(1000020020402,'04-07-2018','C');
CALL addLicencia(1000021020502,'05-08-2018','M');
CALL addLicencia(1000022020602,'06-09-2018','M');
CALL addLicencia(1000023020702,'17-10-2021','M');
CALL addLicencia(1000024020802,'18-11-2021','C');





