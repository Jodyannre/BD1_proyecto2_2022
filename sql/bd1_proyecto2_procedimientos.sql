/******************PROCEDIMIENTOS ALMACENADOS*********************************/

#SELECT REGEXP_INSTR('', '[^a-zA-ZÁÉÍÓÚáéíóú]');
#SELECT STR_TO_DATE('21,5,2013','%d,%m,%Y');
#SELECT date_format(str_to_date('15/4/2022', '%d/%m/%Y'), '%d/%m/%Y');
#SELECT TIMESTAMPDIFF(YEAR, "2017-06-15", "2035-06-15") AS difference;


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS crearPersonaSinPadres;
DELIMITER //
CREATE PROCEDURE crearPersonaSinPadres(
    IN primerNombreIN VARCHAR(50),
    IN segundoNombreIN VARCHAR(50),
    IN tercerNombreIN VARCHAR(50),
    IN primerApellidoIN VARCHAR(50),
    IN segundoApellidoIN VARCHAR(50),
    IN fechaNacimientoIN VARCHAR(50),
    IN municipioIN INT,
    IN generoIN VARCHAR(1)
    )
this_proc:BEGIN
	DECLARE estado_civil INT;
	DECLARE estado_persona INT;
	DECLARE cuiNuevo VARCHAR(13);
	DECLARE id_registro INT;
    DECLARE id_departamentoIN INT;
	DECLARE fechaNacimiento DATE;
	DECLARE caracteresNoPermitidos INT;
    DECLARE cuiDepartamento VARCHAR(2);
    DECLARE cuiMunicipio VARCHAR(4);
    DECLARE cuiRegistro VARCHAR(7);
    DECLARE genero INT;
    DECLARE segundoNombre VARCHAR(50);
    DECLARE tercerNombre VARCHAR(50);
    DECLARE resultado VARCHAR(100);
	#--------------------------------------------------------------------------------------
	#VERIFICAR NOMBRES Y APELLIDOS OBLIGATORIOS
    IF primerNombreIN = '' THEN
		SET resultado := 'Error, el primer nombre es obligatorio.';
        SELECT resultado;
		LEAVE this_proc;
    END IF;
    
    IF primerApellidoIN = '' THEN
		SET resultado := 'Error, el primer apellido es obligatorio.';
        SELECT resultado;
		LEAVE this_proc;
    END IF;
    
    IF segundoAPellidoIN = '' THEN
		SET resultado := 'Error, el segundo apellido es obligatorio.';
        SELECT resultado;
		LEAVE this_proc;
    END IF;
	#--------------------------------------------------------------------------------------
	#--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #Verificar error en primer nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(primerNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el primer nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Verificar error en segundo nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(segundoNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el segundo nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Verificar error en tercer nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(tercerNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el tercer nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Verificar error en primer apellido
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(primerApellidoIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el primer apellido';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Verificar error en segundo apellido
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(segundoApellidoIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el segundo apellido';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Conseguir genero
	IF generoIN = 'M' THEN
		SET genero := 1;
	ELSEIF generoIN = 'F' THEN
		SET genero := 2;
	ELSE 
		SET resultado := 'Error, género de persona inválido.';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #Otras variables
	SET fechaNacimiento := str_to_date(fechaNacimientoIN, '%d-%m-%Y');
	SET estado_persona := 1;
	SET estado_civil := 1;
    SET segundoNombre := segundoNombreIN;
    SET tercerNombre := tercerNombreIN;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #REGISTRAR LA NUEVA PERSONA CON EL CUI PENDIENTE
    INSERT INTO PERSONA (primer_nombre,segundo_nombre,tercer_nombre,primer_apellido,
    segundo_apellido,fecha_nacimiento,id_genero,id_municipio,id_estado_persona,
    id_estado_civil) 
    VALUES (primerNombreIN,segundoNombre,tercerNombre,primerApellidoIN,segundoApellidoIN,
    fechaNacimiento,genero,municipioIN,estado_persona,estado_civil);
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #RECUPERAR EL REGISTRO
    SET id_registro = (SELECT id_persona FROM PERSONA 
    WHERE primer_nombre = primerNombreIN AND 
    segundo_nombre = segundoNombreIN AND
    tercer_nombre = tercerNombreIN AND
    primer_apellido = primerApellidoIN AND
    segundo_apellido = segundoApellidoIN AND 
    fecha_nacimiento = fechaNacimiento AND
    id_municipio = municipioIN);
    
	#--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #RECUPERAR EL ID DEL DEPARTAMENTO
    SET id_departamentoIN = (SELECT id_departamento FROM MUNICIPIO WHERE id_municipio = municipioIN);
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #CONSTRUIR EL CUI
    SET cuiRegistro := CAST(id_registro AS CHAR(7));
    SET cuiMunicipio := CAST(municipioIN AS CHAR(4));
    SET cuiMunicipio := (SELECT LPAD(cuiMunicipio, 4, 0));
    SET cuiDepartamento := CAST(id_departamentoIN AS CHAR(2));
    SET cuiDepartamento := (SELECT LPAD(cuiDepartamento, 2, 0));
    SET cuiNuevo := CONCAT(cuiRegistro,cuiMunicipio,cuiDepartamento);

    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #AGREGAR CUI AL REGISTRO
    UPDATE persona
    SET cui = cuiNuevo
    WHERE id_persona = id_registro;
    SET resultado := 'Persona creada con éxito';
    SELECT resultado;
END //
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS generarDpi;
DELIMITER //
CREATE PROCEDURE generarDpi(
	IN cuiIN BIGINT,
	IN fechaEmisionIN VARCHAR(10),
    IN municipioIN INT
)
this_proc:BEGIN
	DECLARE fechaEmisionConvertida DATE;
    DECLARE fechaNacimientoIN DATE;
	DECLARE id_personaIN INT;
    DECLARE fechaErronea INT;
    DECLARE edadActual INT;
    DECLARE municipioInvalido INT;
    DECLARE id_dpiIN INT;
    DECLARE dpiExiste INT;
    DECLARE cuiINCHAR VARCHAR(13);
    DECLARE resultado VARCHAR(100);
    /***************************CONVERTIR CUI A CHAR*************************/
    SET cuiINCHAR = CAST(cuiIN as CHAR(13));
    /************************************************************************/

    /**********************CONVERTIR FECHA EMISION A DATE********************/
    SET fechaEmisionConvertida = str_to_date(fechaEmisionIN, '%d-%m-%Y');
    /************************************************************************/
    
    /*********************GET ID DE PERSONA DESDE CUI************************/
    SET id_personaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiINCHAR);
	IF id_personaIN IS NULL THEN
		SET resultado := 'Error, cui inválido o no existe.';
        SELECT resultado;
		LEAVE this_proc; 
    END IF;
    /************************************************************************/
    
    /*************GET FECHA NACIMIENTO DE LA PERSONA*************************/
    SET fechaNacimientoIN = (SELECT fecha_nacimiento FROM PERSONA WHERE id_persona = id_personaIN);
    /************************************************************************/
	
    /*********************GET EDAD ACTUAL DEL SOLICITANTE********************/
    SET edadActual = (SELECT TIMESTAMPDIFF(YEAR, fechaNacimientoIN, curdate()));
    IF edadActual < 18 THEN
		SET resultado := 'Error, la persona aun no ha cumplido 18 años.';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    /************************************************************************/
    
    /***********VERIFICAR QUE LA FECHA NO SEA INCORRECTA*********************/
    SET fechaErronea = (SELECT TIMESTAMPDIFF(DAY,fechaNacimientoIN,fechaEmisionConvertida));
	IF fechaErronea < 0 THEN
   		SET resultado := 'Error, la fecha de emisión es incorrecta.';
        SELECT resultado;
		LEAVE this_proc; 
    END IF;
    /************************************************************************/
	
    /*****************VERIFICAR QUE EL MUNICIPIO SEA VALIDO******************/
    SET municipioInvalido = (SELECT id_municipio FROM MUNICIPIO WHERE id_municipio = municipioIN);
    IF municipioInvalido IS NULL THEN
		SET resultado := 'Error, el municipio no existe.';
        SELECT resultado;
		LEAVE this_proc;    
    END IF;
    /************************************************************************/
    
    /********VERIFICAR QUE LA PERSONA NO TENGA DPI***************************/
    SET dpiExiste = (SELECT id_dpi FROM DPI WHERE id_persona = id_personaIN);
    IF dpiExiste IS NOT NULL THEN
		SET resultado := CONCAT('Error, el cui: ',cuiIN, ' ya es un dpi.');
        SELECT resultado;
		LEAVE this_proc;  		
    END IF;
    /************************************************************************/
    
    /*******************************CREAR EL DPI*****************************/
    INSERT INTO DPI (fecha_emision_dpi,id_municipio,id_persona)
    VALUES (fechaEmisionConvertida,municipioIN,id_personaIN);
    /************************************************************************/
    
    SELECT * FROM DPI WHERE id_persona = id_personaIN;
    SET resultado := 'DPI creado con éxito';
    
END //
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS registrarNacimiento;
DELIMITER //
CREATE PROCEDURE registrarNacimiento(
	dpiPadreIN BIGINT,
    dpiMadreIN BIGINT,
    primerNombreIN VARCHAR(50),
	segundoNombreIN VARCHAR(50),
    tercerNombreIN VARCHAR(50),
    fechaNacimientoIN VARCHAR(50),
    municipioIN INT,
    generoIN VARCHAR(2)
)
this_proc:BEGIN
	DECLARE padreVivo INT;
    DECLARE madreViva INT;
    DECLARE padreMayor INT;
    DECLARE madreMayor INT;
	DECLARE idMadreIN INT;
	DECLARE idPadreIN INT;
    DECLARE dpiMadreChar VARCHAR(13);
    DECLARE dpiPadreChar VARCHAR(13);
	DECLARE apellidoPadre VARCHAR(50);
	DECLARE apellidoMadre VARCHAR(50);
	DECLARE id_generoIN INT;
	DECLARE municipioInvalido INT;
    DECLARE id_departamentoIN INT;
	DECLARE id_estado_personaIN INT;
	DECLARE id_estado_civilIN INT;
	DECLARE caracteresNoPermitidos INT;
	DECLARE segundoNombre VARCHAR(50);
    DECLARE tercerNombre VARCHAR(50);
    DECLARE id_registro INT;
    DECLARE cuiNuevo VARCHAR(13);
	DECLARE cuiDepartamento VARCHAR(2);
    DECLARE cuiMunicipio VARCHAR(4);
    DECLARE cuiRegistro VARCHAR(7);
    DECLARE resultado VARCHAR(100);
    DECLARE genero INT;
	DECLARE fechaNacimiento DATE;

	#--------------------------------------------------------------------------------------
	#VERIFICAR NOMBRES Y APELLIDOS OBLIGATORIOS
    IF primerNombreIN = '' THEN
		SET resultado := 'Error, el primer nombre es obligatorio.';
        SELECT resultado;
		LEAVE this_proc;
    END IF;
	#--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #Verificar error en primer nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(primerNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el primer nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #Verificar error en segundo nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(segundoNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el segundo nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #Verificar error en tercer nombre
	SET caracteresNoPermitidos = (SELECT REGEXP_INSTR(tercerNombreIN, '[^a-zA-ZÁÉÍÓÚáéíóú]'));
	IF caracteresNoPermitidos > 0 THEN
		SET resultado := 'Error, caracteres inválidos en el tercer nombre';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #Conseguir genero
	IF generoIN = 'M' THEN
		SET genero := 1;
	ELSEIF generoIN = 'F' THEN
		SET genero := 2;
	ELSE 
		SET resultado := 'Error, género de persona inválido.';
        SELECT resultado;
		LEAVE this_proc;
	END IF;
    #--------------------------------------------------------------------------------------
    
	#--------------------------------------------------------------------------------------
	#Conseguir apellidos
    SET dpiPadreChar = CAST(dpiPadreIN AS CHAR(13));
    SET dpiMadreCHar = CAST(dpiMadreIN AS CHAR(13));
    
    SET idPadreIN = (SELECT id_persona FROM PERSONA WHERE cui = dpiPadreChar);
    IF idPadreIN IS NULL THEN
		SET resultado := 'Error, el dpi del padre es inválido.';
        SELECT resultado;
		LEAVE this_proc;    
    END IF;
    
    SET idMadreIN = (SELECT id_persona FROM PERSONA WHERE cui = dpiMadreChar);
	IF idMadreIN IS NULL THEN
		SET resultado := 'Error, el dpi de la madre es inválido.';
        SELECT resultado;
		LEAVE this_proc;    
    END IF;
     
	SET apellidoPadre = (SELECT primer_apellido FROM PERSONA WHERE id_persona = idPadreIN);
    SET apellidoMadre = (SELECT primer_apellido FROM PERSONA WHERE id_persona = idMadreIN);
	#--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LOS PADRES ESTEN VIVOS Y SEAN MAYORES DE EDAD
    SET padreMayor = (SELECT id_dpi FROM DPI WHERE id_persona = idPadreIN);
    IF padreMayor IS NULL THEN
		SET resultado := 'Error, el padre es menor de edad o aun no tiene dpi.';
        SELECT resultado;
		LEAVE this_proc;      
    END IF;
    SET madreMayor = (SELECT id_dpi FROM DPI WHERE id_persona = idMadreIN);
    IF madreMayor IS NULL THEN
		SET resultado := 'Error, la madre es menor de edad o aun no tiene dpi.';
        SELECT resultado;
		LEAVE this_proc;     
    END IF;
    SET padreVivo = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idPadreIN);
    IF padreVivo = 2 THEN
		SET resultado := 'Error, una persona fallecida no puede tener hijos (padre).';
        SELECT resultado;
		LEAVE this_proc;   
    END IF;
    SET madreViva = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idMadreIN);
    IF madreViva = 2 THEN
		SET resultado := 'Error, una persona fallecida no puede tener hijos (madre).';
        SELECT resultado;
		LEAVE this_proc;   
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #Otras variables
	SET fechaNacimiento := str_to_date(fechaNacimientoIN, '%d-%m-%Y');
	SET id_estado_personaIN := 1;
	SET id_estado_civilIN := 1;
    SET segundoNombre := segundoNombreIN;
    SET tercerNombre := tercerNombreIN;
	 #--------------------------------------------------------------------------------------

	#--------------------------------------------------------------------------------------
    #REGISTRAR LA NUEVA PERSONA CON EL CUI PENDIENTE
    INSERT INTO PERSONA (primer_nombre,segundo_nombre,tercer_nombre,primer_apellido,
    segundo_apellido,fecha_nacimiento,id_padre,id_madre,id_genero,id_municipio,id_estado_persona,
    id_estado_civil) 
    VALUES (primerNombreIN,segundoNombre,tercerNombre,apellidoPadre,apellidoMadre,
    fechaNacimiento,idPadreIN,idMadreIN,genero,municipioIN,id_estado_personaIN,id_estado_civilIN);
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #RECUPERAR EL REGISTRO
    SET id_registro = (SELECT id_persona FROM PERSONA 
    WHERE primer_nombre = primerNombreIN AND 
    segundo_nombre = segundoNombreIN AND
    tercer_nombre = tercerNombreIN AND
    primer_apellido = apellidoPadre AND
    segundo_apellido = apellidoMadre AND 
    fecha_nacimiento = fechaNacimiento AND
    id_municipio = municipioIN);
	#--------------------------------------------------------------------------------------

    #--------------------------------------------------------------------------------------
    #RECUPERAR EL ID DEL DEPARTAMENTO
    SET id_departamentoIN = (SELECT id_departamento FROM MUNICIPIO WHERE id_municipio = municipioIN);
    #--------------------------------------------------------------------------------------

    #--------------------------------------------------------------------------------------
    #CONSTRUIR EL CUI
    SET cuiRegistro := CAST(id_registro AS CHAR(7));
    SET cuiMunicipio := CAST(municipioIN AS CHAR(4));
    SET cuiMunicipio := (SELECT LPAD(cuiMunicipio, 4, 0));
    SET cuiDepartamento := CAST(id_departamentoIN AS CHAR(2));
    SET cuiDepartamento := (SELECT LPAD(cuiDepartamento, 2, 0));
    SET cuiNuevo := CONCAT(cuiRegistro,cuiMunicipio,cuiDepartamento);
    #--------------------------------------------------------------------------------------
        #AGREGAR CUI AL REGISTRO
    UPDATE persona
    SET cui = cuiNuevo
    WHERE id_persona = id_registro;
    SET resultado := 'Persona creada con éxito';
    SELECT resultado;
END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS addDefuncion
DELIMITER //
CREATE PROCEDURE addDefuncion(
	IN cuiIN BIGINT,
    IN fechaFallecidoIN VARCHAR(20),
    IN motivoIN VARCHAR(100)
)
this_proc:BEGIN
	DECLARE idPersonaIN INT;
    DECLARE estadoActualPersona INT;
    DECLARE cuiIN_char VARCHAR(13);
    DECLARE fechaFallecidoConvertida DATE;
    DECLARE personaViva INT;
    DECLARE fechaNacimientoIN DATE;
    DECLARE fechaValida INT;
    DECLARE resultado VARCHAR(100);
    #--------------------------------------------------------------------------------------
    #CONVERTIR CUI NUMERICO A CUI CHAR
    SET cuiIN_char = CAST(cuiIN AS CHAR(13));
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET EL ID DE LA PERSONA Y VERIFICAR SI EXISTE
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiIN_char);
    IF idPersonaIN IS NULL THEN
		SET resultado := 'Error, el cui es inválido.';
        SELECT resultado;
		LEAVE this_proc;		
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA PERSONA ESTE VIVA
    SET personaViva = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idPersonaIN);
    IF personaViva = 2 THEN
 		SET resultado := 'Error, esa persona ya ha fallecido.';
        SELECT resultado;
		LEAVE this_proc;	   
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA FECHA SEA VALIDA
    SET fechaFallecidoConvertida = str_to_date(fechaFallecidoIN, '%d-%m-%Y');
    SET fechaNacimientoIN = (SELECT fecha_nacimiento FROM PERSONA WHERE id_persona = idPersonaIN);
    SET fechaValida = (SELECT TIMESTAMPDIFF(DAY,fechaNacimientoIN,fechaFallecidoConvertida));
    IF fechaValida < 0 THEN
 		SET resultado := 'Error, fecha incorrecta. La persona no puede fallecer antes de nacer';
        SELECT resultado;
		LEAVE this_proc;	      
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #ACTUALIZAR EL ESTADO DE LA PERSONA
    UPDATE PERSONA 
    SET id_estado_persona = 2
    WHERE id_persona = idPersonaIN;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #CREAR EL ACTA DE DEFUNCION
    INSERT INTO DEFUNCION (fecha_defuncion,motivo_defuncion,id_persona)
    VALUES (fechaFallecidoConvertida,motivoIN,idPersonaIN);
    #--------------------------------------------------------------------------------------
    SET resultado = 'Defunción registrada con éxito.';
    SELECT resultado;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS addMatrimonio
DELIMITER //
CREATE PROCEDURE addMatrimonio(
	IN dpiHombreIN BIGINT,
    IN dpiMujerIN BIGINT,
    IN fechaMatrimonioIN VARCHAR(20)
)
this_proc:BEGIN
	DECLARE cuiHombreChar VARCHAR(13);
    DECLARE cuiMujerChar VARCHAR(13);
    DECLARE idHombreIN INT;
    DECLARE idMujerIN INT;
    DECLARE esHombre INT;
    DECLARE esMujer INT;
    DECLARE hombreEsMayor INT;
    DECLARE mujerEsMayor INT;
    DECLARE hombreCasado INT;
    DECLARE mujerCasada INT;
    DECLARE hombreVivo INT;
    DECLARE mujerViva INT;
    DECLARE fechaMatrimonioConvertida DATE;
    DECLARE resultado VARCHAR(100);
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LOS CUI NUMERICOS A CHAR
    SET cuiHombreChar = CAST(dpiHombreIN AS CHAR(13));
    SET cuiMujerChar = CAST(dpiMujerIN AS CHAR(13));
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET IDS DE LAS 2 PERSONAS
    SET idHombreIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiHombreChar);
    IF idHombreIN IS NULL THEN
		SET resultado := CONCAT('Error, el cui: ', cuiHombreChar ,' es inválido.');
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    SET idMujerIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiMujerChar);
    IF idMujerIN IS NULL THEN
		SET resultado := CONCAT('Error, el cui: ', cuiMujerChar ,' es inválido.');
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LOS GENEROS SEAN CORRECTOS
    SET esHombre = (SELECT id_genero FROM PERSONA WHERE id_persona = idHombreIN);
    IF esHombre = 2 THEN
		SET resultado := CONCAT('Error, el cui: ', cuiHombreChar ,' pertenece a una mujer y se esperaba un hombre.');
        SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    SET esMujer = (SELECT id_genero FROM PERSONA WHERE id_persona = idMujerIN);
    IF esMujer = 1 THEN
		SET resultado := CONCAT('Error, el cui: ', cuiMujerChar ,' pertenece a un hombre y se esperaba una mujer.');
        SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    #--------------------------------------------------------------------------------------
   
   
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE SEAN MAYORES
    SET hombreEsMayor = (SELECT id_dpi FROM DPI WHERE id_persona = idHombreIN);
    IF hombreEsMayor IS NULL THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiHombreChar ,' es menor de edad o aún no posee dpi.');
        SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    SET mujerEsMayor = (SELECT id_dpi FROM DPI WHERE id_persona = idMujerIN);
    IF mujerEsMayor IS NULL THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiHombreChar ,' es menor de edad o aún no posee dpi.');
		SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE ESTEN VIVOS
    SET hombreVivo = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idHombreIN);
    IF hombreVivo = 2 THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiHombreChar ,' ya ha fallecido.');
        SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    SET mujerViva = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idMujerIN);
    IF mujerViva = 2 THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiMujerChar ,' ya ha fallecido.');
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    #--------------------------------------------------------------------------------------
    
    
	#--------------------------------------------------------------------------------------
    #VERIFICAR QUE NO ESTEN CASADOS
    SET hombreCasado = (SELECT id_estado_civil FROM PERSONA WHERE id_persona = idHombreIN);
    IF hombreCasado = 2 THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiHombreChar ,' tiene un matrimonio activo.');
        SELECT resultado;
		LEAVE this_proc;	 
    END IF;
    SET mujerCasada = (SELECT id_estado_civil FROM PERSONA WHERE id_persona = idMujerIN);
	IF mujerCasada = 2 THEN
		SET resultado := CONCAT('Error, la persona con el cui: ', cuiMujerChar ,' tiene un matrimonio activo.');
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    #--------------------------------------------------------------------------------------

    
    #--------------------------------------------------------------------------------------
    #ACTUALIZAR ESTADO CIVIL DE LOS CASADOS
    UPDATE PERSONA
    SET id_estado_civil = 2
    WHERE id_persona = idHombreIN;
    
    UPDATE PERSONA
    SET id_estado_civil = 2
    WHERE id_persona = idMujerIN;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CREAR EL ACTA DE MATRIMONIO
    SET fechaMatrimonioConvertida = str_to_date(fechaMatrimonioIN, '%d-%m-%Y');
    INSERT INTO MATRIMONIO (fecha_matrimonio,id_esposo,id_esposa,id_estado_matrimonio)
    VALUES (fechaMatrimonioConvertida,idHombreIN,idMujerIN,1);
    SET resultado = 'Matrimonio registrado con éxito.';
    SELECT resultado;
    #--------------------------------------------------------------------------------------
END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS addMatrimonio
DELIMITER //
CREATE PROCEDURE addDivorcio(

)
this_proc:BEGIN
END //;
DELIMITER ;


#//////////////////////////////////////////////////////////////////////////////////////





#//////////////////////////EJECUCION DE PROCEDIMIENTOS Y FUNCIONES/////////////////////////////


#**********************CREACION DE PERSONAS SIN PADRES*****************************************
CALL crearPersonaSinPadres('Marcos','Alonzo','','Pineda','Penedo','12-12-2000',101,'M');
select * from persona;
#**********************************************************************************************

#******************************GENERACION DE NUEVO DPI*****************************************
CALL generarDpi(1000006010201,'15-04-2022',101);
select * from dpi;
#**********************************************************************************************

#**********************************REGISTRAR NACIMIENTO****************************************
CALL registrarNacimiento(1000007010101,1000006010201,'Eduart','Joan','','22-04-2018',101,'M');
select * from persona;
#**********************************************************************************************

#**********************************REGISTRAR DEFUNCION*****************************************
CALL addDefuncion(1000004010201,'15-04-2023','Se cayo de la bañera.');
select * from persona;
select * from defuncion;
#**********************************************************************************************


#**********************************REGISTRAR MATRIMONIO****************************************
CALL addMatrimonio(1000000010101,1000006010201,'22-04-2022');
select * from persona;
#**********************************************************************************************





	

