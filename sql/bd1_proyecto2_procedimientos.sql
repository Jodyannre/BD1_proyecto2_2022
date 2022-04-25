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
    INSERT INTO PERSONA (fecha_nacimiento,id_genero,id_municipio,id_estado_persona,
    id_estado_civil) 
    VALUES (fechaNacimiento,genero,municipioIN,estado_persona,estado_civil);
    
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------
    #RECUPERAR EL REGISTRO
    SET id_registro = (SELECT id_persona FROM PERSONA 
    ORDER BY id_persona DESC limit 1);
	#--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #REGISTRAR NOMBRES Y APELLIDOS
    IF primerNombreIN != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (primerNombreIN,id_registro);
    END IF;
 
	IF segundoNombreIN != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (segundoNombreIN,id_registro);
    END IF;
    
    IF tercerNombreIN != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (tercerNombreIN,id_registro);
    END IF;

    IF primerApellidoIN != '' THEN
		INSERT INTO APELLIDO (apellido,id_persona)
        VALUES (primerApellidoIN,id_registro);
    END IF;

    IF segundoApellidoIN != '' THEN
		INSERT INTO APELLIDO (apellido,id_persona)
        VALUES (segundoApellidoIN,id_registro);
    END IF;
    
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
    select cuiRegistro,cuiMunicipio,cuiDepartamento,cuiNuevo;
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
     
	#SET apellidoPadre = (SELECT primer_apellido FROM PERSONA WHERE id_persona = idPadreIN);
    #SET apellidoMadre = (SELECT primer_apellido FROM PERSONA WHERE id_persona = idMadreIN);
    
    SET apellidoPadre = (SELECT apellido FROM APELLIDO WHERE id_persona = idPadreIN 
		ORDER BY id_apellido ASC LIMIT 1);
	SET apellidoMadre = (SELECT apellido FROM APELLIDO WHERE id_persona = idMadreIN 
		ORDER BY id_apellido ASC LIMIT 1);
        
       
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
    INSERT INTO PERSONA (fecha_nacimiento,id_padre,id_madre,id_genero,id_municipio,
    id_estado_persona,id_estado_civil) 
    VALUES (fechaNacimiento,idPadreIN,idMadreIN,genero,municipioIN,id_estado_personaIN,
    id_estado_civilIN);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #RECUPERAR EL REGISTRO
    SET id_registro = (SELECT id_persona FROM PERSONA 
    ORDER BY id_persona DESC LIMIT 1);
	#--------------------------------------------------------------------------------------

    #--------------------------------------------------------------------------------------
    #REGISTRAR NOMBRES Y APELLIDOS
    IF primerNombreIN != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (primerNombreIN,id_registro);
    END IF;
 
	IF segundoNombre != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (segundoNombre,id_registro);
    END IF;
    
    IF tercerNombre != '' THEN
		INSERT INTO NOMBRE (nombre,id_persona)
        VALUES (tercerNombre,id_registro);
    END IF;

    IF apellidoPadre != '' THEN
		INSERT INTO APELLIDO (apellido,id_persona)
        VALUES (apellidoPadre,id_registro);
    END IF;

    IF apellidoMadre != '' THEN
		INSERT INTO APELLIDO (apellido,id_persona)
        VALUES (apellidoMadre,id_registro);
    END IF;
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
DROP PROCEDURE IF EXISTS addDivorcio
DELIMITER //
CREATE PROCEDURE addDivorcio(
	IN matrimonioIN INT,
    IN fechaDivorcioIN VARCHAR(20)
)
this_proc:BEGIN
	DECLARE fechaDivorcioConvertida DATE;
    DECLARE matrimonioExiste INT;
    DECLARE estadoMatrimonio INT;
    DECLARE idEsposoIN INT;
    DECLARE idEsposaIN INT;
    DECLARE fechaMatrimonio DATE;
    DECLARE fechaValida INT;
    DECLARE resultado VARCHAR(100);
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LA FECHA DEL DIVORCIO A DATE
    SET fechaDivorcioConvertida = str_to_date(fechaDivorcioIN, '%d-%m-%Y');
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA FECHA DE DIVORCIO SEA VALIDA Y QUE EL NO. DE ACTA SEA VALIDO
    SET fechaMatrimonio = (SELECT fecha_matrimonio FROM MATRIMONIO WHERE id_matrimonio = matrimonioIN);
    IF fechaMatrimonio IS NULL THEN
		SET resultado := 'Error, el No. de acta de matrimonio es inválido o no existe.';
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    
    SET fechaValida = (SELECT TIMESTAMPDIFF(DAY,fechaMatrimonio,fechaDivorcioConvertida));
    IF fechaValida < 0 THEN
		SET resultado := 'Error, la fecha del divorcio es incorrecta, debe ser después del matrimonio.';
        SELECT resultado;
		LEAVE this_proc;	
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE EL MATRIMONIO ESTA ACTIVO
    SET estadoMatrimonio = (SELECT id_estado_matrimonio FROM MATRIMONIO WHERE id_matrimonio = matrimonioIN);
    IF estadoMatrimonio = 2 THEN
		SET resultado := 'Error, ese matrimonio ya ha finalizado.';
        SELECT resultado;
		LEAVE this_proc;	    
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #GET LOS IDS DE LOS ESPOSOS
    SET idEsposoIN = (SELECT id_esposo FROM MATRIMONIO WHERE id_matrimonio = matrimonioIN);
    SET idEsposaIN = (SELECT id_esposa FROM MATRIMONIO WHERE id_matrimonio = matrimonioIN);
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #ACTUALIZAR EL ESTADO DEL ACTA DE MATRIMONIO
    UPDATE MATRIMONIO
    SET id_estado_matrimonio = 2
    WHERE id_matrimonio = matrimonioIN;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #ACTUALIZAR EL ESTADO CIVIL DE LAS 2 PERSONAS
    UPDATE PERSONA
    SET id_estado_civil = 3
    WHERE id_persona = idEsposoIN;
  
	UPDATE PERSONA
    SET id_estado_civil = 3
    WHERE id_persona = idEsposaIN;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CREAR EL ACTA DE DIVORCIO
    INSERT INTO DIVORCIO (fecha_divorcio,id_matrimonio)
    VALUES (fechaDivorcioConvertida,matrimonioIN);
    #--------------------------------------------------------------------------------------
    
    SET resultado = 'Divorcio registrado con éxito';
    SELECT resultado;
    
END //;
DELIMITER ;


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS addLicencia
DELIMITER //
CREATE PROCEDURE addLicencia(
	IN cuiIN BIGINT,
    IN fechaEmisionIN VARCHAR(20),
    IN tipoLicenciaIN VARCHAR(1)
)
this_proc:BEGIN
	DECLARE fechaEmisionConvertida DATE;
    DECLARE tipoLicenciaConvertido INT;
    DECLARE cuiConvertido VARCHAR(13);
    DECLARE idPersonaIN INT;
    DECLARE primeraLicencia INT;
    DECLARE licenciaE INT;
    DECLARE licenciaM INT;
    DECLARE licenciaC INT;
    DECLARE licenciaB INT;
    DECLARE licenciaA INT;
    DECLARE estadoA INT;
    DECLARE estadoB INT;
    DECLARE estadoC INT;
    DECLARE estadoM INT;
    DECLARE estadoE INT;
    DECLARE tiempoLicencia INT;
    DECLARE estadoLicencia INT;
    DECLARE edadPersona INT;
    DECLARE fechaNacimiento DATE;
    DECLARE licenciaAnulada INT;
    DECLARE fechaEmision DATE;
    DECLARE fechaVencimiento DATE;
    DECLARE resultado VARCHAR(200);
    DECLARE tiempoLicenciaCorrecto INT;
    DECLARE idLicenciaIN INT;
    DECLARE personaViva INT;
    
    #INCIAR TIEMPO DE LA LICENCIA
    SET tiempoLicenciaCorrecto = 0;
    
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LOS CUI NUMERICOS A CHAR
    SET cuiConvertido = CAST(cuiIN AS CHAR(13));
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LA FECHA A DATE
    SET fechaEmisionConvertida = str_to_date(fechaEmisionIN, '%d-%m-%Y');
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR EL TIPO DE LICENCIA
    IF tipoLicenciaIN = 'A' THEN
		SET tipoLicenciaConvertido = 1;
    ELSEIF tipoLicenciaIN = 'B' THEN
		SET tipoLicenciaConvertido = 2;
    ELSEIF tipoLicenciaIN = 'C' THEN
		SET tipoLicenciaConvertido = 3;
    ELSEIF tipoLicenciaIN = 'M' THEN
		SET tipoLicenciaConvertido = 4;
    ELSEIF tipoLicenciaIN = 'E' THEN
		SET tipoLicenciaConvertido = 5;
    ELSE
		SET resultado = 'Error, tipo de licencia inválido.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET ID DE LA PERSONA Y VERIFICAR QUE LA PERSONA ESTE VIVA
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiConvertido);
    IF idPersonaIN IS NULL THEN
		SET resultado = 'Error, el cui ingresado es inválido.';
        SELECT resultado;
        LEAVE this_proc;    
    END IF;
    SET personaViva = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idPersonaIN);
    IF personaViva = 2 THEN
		SET resultado = 'Error, esa persona ya ha fallecido.';
        SELECT resultado;
        LEAVE this_proc;      
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #GET EDAD DE LA PERSONA
    SET fechaNacimiento = (SELECT fecha_nacimiento FROM PERSONA WHERE id_persona = idPersonaIN);
    SET edadPersona = (SELECT TIMESTAMPDIFF(YEAR,fechaNacimiento,fechaEmisionConvertida));
    IF edadPersona < 16 THEN
		SET resultado = 'Error, se necesita tener más de 16 para solicitar una licencia.';
        SELECT resultado;
        LEAVE this_proc;    		
    END IF;
    #--------------------------------------------------------------------------------------

    
    #--------------------------------------------------------------------------------------
    #VERIFICAR SI ES SU PRIMERA LICENCIA Y SI HAY ACTIVAS
    IF tipoLicenciaConvertido = 1 OR tipoLicenciaConvertido = 2 THEN
		SET resultado = 'Error, la primer licencia solo puede ser de tipo C/M/E';
		SELECT resultado;
		LEAVE this_proc; 
    END IF;
    
    SET primeraLicencia = (
    SELECT COUNT(id_persona) FROM LICENCIA 
    WHERE id_persona = idPersonaIN
    );
    
    IF primeraLicencia > 0 THEN
    #--------------------------------------------------------------------------------------
	#BUSCAR SI YA TIENE UNA TIPO E
		SET licenciaA = (
			SELECT a.id_licencia FROM CATALOGO_LICENCIA AS a
			INNER JOIN LICENCIA AS b
			ON a.id_licencia = b.id_licencia
			WHERE b.id_persona = idPersonaIN
			AND a.id_tipo_licencia = 1
		);
		SET licenciaB = (
			SELECT a.id_licencia FROM CATALOGO_LICENCIA AS a
			INNER JOIN LICENCIA AS b
			ON a.id_licencia = b.id_licencia
			WHERE b.id_persona = idPersonaIN
			AND a.id_tipo_licencia = 2
		);
        SET licenciaC = (
			SELECT a.id_licencia FROM CATALOGO_LICENCIA AS a
			INNER JOIN LICENCIA AS b
			ON a.id_licencia = b.id_licencia
			WHERE b.id_persona = idPersonaIN
			AND a.id_tipo_licencia = 3
		);
        SET licenciaM = (
			SELECT a.id_licencia FROM CATALOGO_LICENCIA AS a
			INNER JOIN LICENCIA AS b
			ON a.id_licencia = b.id_licencia
			WHERE b.id_persona = idPersonaIN
			AND a.id_tipo_licencia = 4
		);
        SET licenciaE = (
			SELECT a.id_licencia FROM CATALOGO_LICENCIA AS a
			INNER JOIN LICENCIA AS b
			ON a.id_licencia = b.id_licencia
			WHERE b.id_persona = idPersonaIN
			AND a.id_tipo_licencia = 5
		);
	#--------------------------------------------------------------------------------------
    END IF;
    #--------------------------------------------------------------------------------------

    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE NO TENGA YA UNA LICENCIA Y NO SE PUEDA CREAR OTRA
    IF tipoLicenciaConvertido < 5 THEN
		IF licenciaA IS NOT NULL THEN
			SET resultado = 'Error, la persona ya tiene una licencia tipo A.';
			SELECT resultado;
			LEAVE this_proc; 
		END IF;
		IF licenciaB IS NOT NULL THEN
			SET resultado = 'Error, la persona ya tiene una licencia tipo B.';
			SELECT resultado;
			LEAVE this_proc; 
		END IF;
		IF licenciaC IS NOT NULL THEN
			SET resultado = 'Error, la persona ya tiene una licencia tipo C.';
			SELECT resultado;
			LEAVE this_proc; 
		END IF;		
		IF licenciaM IS NOT NULL THEN
			SET resultado = 'Error, la persona ya tiene una licencia tipo M.';
			SELECT resultado;
			LEAVE this_proc; 
		END IF;
    END IF;
    IF tipoLicenciaConvertido = 5 THEN
		IF licenciaE IS NOT NULL THEN
			SET resultado = 'Error, la persona ya tiene una licencia tipo E.';
			SELECT resultado;
			LEAVE this_proc; 
		END IF;
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CASO DE QUE SE QUIERA PEDIR UNA LICENCIA TIPO C
    
    IF tipoLicenciaConvertido = 3 THEN
        
	#--------------------------------------------------------------------------------------
    #CREAR LA LICENCIA
		SET fechaVencimiento = DATE_ADD(fechaEmisionConvertida, INTERVAL 1 YEAR);
		INSERT INTO LICENCIA (id_persona,fecha_emision,fecha_vencimiento,id_tipo_licencia,id_estado_licencia)
		VALUES (idPersonaIN, fechaEmisionConvertida,fechaVencimiento,3,1);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #ASIGNAR LICENCIA A LA PERSONA
		SET idLicenciaIN = (SELECT id_licencia FROM LICENCIA ORDER BY id_licencia DESC LIMIT 1);
		INSERT INTO CATALOGO_LICENCIA (id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
		VALUES (idLicenciaIN,fechaEmisionConvertida,fechaVencimiento,3);
    #--------------------------------------------------------------------------------------
		SET resultado = 'Licencia tipo C creada con éxito';
        SELECT resultado;
    #--------------------------------------------------------------------------------------
        
    #//////////////////////////////////////////////////////////////////////////////////////
    
    ELSEIF tipoLicenciaConvertido = 4 THEN      
    
	#--------------------------------------------------------------------------------------
    #CREAR LA LICENCIA
		SET fechaVencimiento = DATE_ADD(fechaEmisionConvertida, INTERVAL 1 YEAR);
		INSERT INTO LICENCIA (id_persona,fecha_emision,fecha_vencimiento,id_tipo_licencia,id_estado_licencia)
		VALUES (idPersonaIN, fechaEmisionConvertida,fechaVencimiento,4,1);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #ASIGNAR LICENCIA A LA PERSONA
		SET idLicenciaIN = (SELECT id_licencia FROM LICENCIA ORDER BY id_licencia DESC LIMIT 1);
		INSERT INTO CATALOGO_LICENCIA (id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
		VALUES (idLicenciaIN,fechaEmisionConvertida,fechaVencimiento,4);
    #--------------------------------------------------------------------------------------
		SET resultado = 'Licencia tipo M creada con éxito';
        SELECT resultado;
    #--------------------------------------------------------------------------------------
    
        
    #//////////////////////////////////////////////////////////////////////////////////////
    ELSEIF tipoLicenciaConvertido = 5 THEN 

	#--------------------------------------------------------------------------------------
    #CREAR LA LICENCIA
		SET fechaVencimiento = DATE_ADD(fechaEmisionConvertida, INTERVAL 1 YEAR);
		INSERT INTO LICENCIA (id_persona,fecha_emision,fecha_vencimiento,id_tipo_licencia,id_estado_licencia)
		VALUES (idPersonaIN, fechaEmisionConvertida,fechaVencimiento,5,1);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #ASIGNAR LICENCIA A LA PERSONA
		SET idLicenciaIN = (SELECT id_licencia FROM LICENCIA ORDER BY id_licencia DESC LIMIT 1);
		INSERT INTO CATALOGO_LICENCIA (id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
		VALUES (idLicenciaIN,fechaEmisionConvertida,fechaVencimiento,5);
	#--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
		SET resultado = 'Licencia tipo E creada con éxito';
        SELECT resultado;
    #--------------------------------------------------------------------------------------
    END IF;
END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS actualizarEstadoLicencias
DELIMITER //
CREATE PROCEDURE actualizarEstadoLicencias()
this_proc:BEGIN
	DECLARE idLicencia INT;
    DECLARE fechaEmision DATE;
    DECLARE fechaVencimiento DATE;
    DECLARE tipoLicencia INT;
    DECLARE estadoFecha INT;
	DECLARE var_final INTEGER DEFAULT 0;
    DECLARE resultado VARCHAR(100);
    DECLARE estadoLicencia INT;
    DECLARE cursorLicencias CURSOR FOR SELECT id_licencia,fecha_emision,
    fecha_vencimiento,id_tipo_licencia,id_estado_licencia FROM LICENCIA;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursorLicencias;
    
    bucle:LOOP
		FETCH cursorLicencias INTO idLicencia,fechaEmision,fechaVencimiento,tipoLicencia,estadoLicencia;
        
        #--------------------------------------------------------------------------------------
        #VERIFICAR QUE LA LICENCIA NO SE HAYA VENCIDO
        SET estadoFecha = (SELECT TIMESTAMPDIFF(DAY,fechaVencimiento,curdate()));
        IF estadoFecha > 0 AND estadoLicencia != 3 THEN
			UPDATE LICENCIA
            SET id_estado_licencia = 2 
            WHERE id_licencia = idLicencia;
        END IF;
        #--------------------------------------------------------------------------------------
        
        IF var_final = 1 THEN
			LEAVE bucle;
        END IF;
        
	END LOOP bucle;
	CLOSE cursorLicencias;
    
    SET resultado = 'Proceso finalizado con éxito.';
    SELECT resultado;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS actualizarEstadoAnulacion
DELIMITER //
CREATE PROCEDURE actualizarEstadoAnulacion()
this_proc:BEGIN
	DECLARE idLicencia INT;
    DECLARE idAnulacion INT;
    DECLARE fechaFinAnulacion DATE;
    DECLARE estadoAnulacion INT;
	DECLARE var_final INTEGER DEFAULT 0;
    DECLARE estadoFecha INT;
    DECLARE resultado VARCHAR(100);
    DECLARE cursorAnulacion CURSOR FOR SELECT id_anulacion_licencia,id_licencia,
    fecha_fin_anulacion,id_estado_anulacion FROM ANULACION_LICENCIA;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursorAnulacion;
    
    bucle:LOOP
		FETCH cursorAnulacion INTO idAnulacion, idLicencia,fechaFinAnulacion,estadoAnulacion;
        
        #--------------------------------------------------------------------------------------
        #VERIFICAR QUE LA LICENCIA NO SE HAYA VENCIDO
        SET estadoFecha = (SELECT TIMESTAMPDIFF(DAY,fechaFinAnulacion,curdate()));
        IF estadoFecha > 0 AND estadoAnulacion = 1 THEN
			UPDATE ANULACION_LICENCIA
            SET id_estado_anulacion = 2 
            WHERE id_anulacion_licencia = idAnulacion;
            UPDATE LICENCIA
            SET id_estado_licencia = 1
            WHERE id_licencia = idLicencia;
        END IF;
        #--------------------------------------------------------------------------------------
        
        IF var_final = 1 THEN
			LEAVE bucle;
        END IF;
        
	END LOOP bucle;
	CLOSE cursorAnulacion;
    
    SET resultado = 'Proceso finalizado con éxito.';
    SELECT resultado;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS anularLicencia
DELIMITER //
CREATE PROCEDURE anularLicencia(
	IN idLicenciaIN INT,
    IN fechaAnulacion VARCHAR(20),
    IN motivoAnulacion VARCHAR(100)
)
this_proc:BEGIN
	DECLARE fechaAnulacionConvertida DATE;
    DECLARE fechaFinAnulacion DATE;
    DECLARE fechaEmision DATE;
    DECLARE licenciaValida INT;
    DECLARE estaAnulada INT;
    DECLARE estadoAnulacion INT;
    DECLARE fechaCoherente INT;
    DECLARE idAnulacionIN INT;
    DECLARE resultado VARCHAR(100);
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA LICENCIA EXISTE
    SET licenciaValida = (SELECT id_licencia FROM LICENCIA WHERE id_licencia = idLicenciaIN);
    IF licenciaValida IS NULL THEN
		SET resultado = 'Error, el número de licencia es inválido.';
        SELECT resultado;
        LEAVE this_proc;    
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LA FECHA DE ANULACION
    SET fechaAnulacionConvertida = str_to_date(fechaAnulacion, '%d-%m-%Y');
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET LA FECHA DE EMISION PARA VALIDAR COHERENCIA
    SET fechaEmision = (SELECT fecha_emision FROM LICENCIA WHERE id_licencia = idLicenciaIN);
    SET fechaCoherente = (SELECT TIMESTAMPDIFF(YEAR,fechaEmision,fechaAnulacionConvertida));
    IF fechaCoherente < 0 THEN
		SET resultado = 'Error, la fecha de anulación no es coherente con la fecha de emisión de la licencia.';
        SELECT resultado;
        LEAVE this_proc;       
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR SI YA ESTA ANULADA Y SI ESTA ANULADA ENTONCES CAMBIAR EL ESTADO A 2
    SET estaAnulada = (SELECT id_anulacion_licencia FROM ANULACION_LICENCIA
    WHERE id_licencia = idLicenciaIN
    AND id_estado_anulacion = 1);    
    IF estaAnulada IS NOT NULL THEN
        UPDATE ANULACION_LICENCIA
        SET id_estado_anulacion = 2
        WHERE id_anulacion_licencia = estaAnulada;
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GENERAR LA FECHA DEL FIN DE LA ANULACION
    SET fechaFinAnulacion = DATE_ADD(fechaAnulacionConvertida, INTERVAL 2 YEAR);
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CREAR LA NUEVA ANULACION
    INSERT INTO ANULACION_LICENCIA (id_licencia,fecha_anulacion,fecha_fin_anulacion,motivo_anulacion,
    id_estado_anulacion)
    VALUES (idLicenciaIN,fechaAnulacionConvertida,fechaFinAnulacion,motivoAnulacion,1);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #ACTUALIZAR ESTADO DE LICENCIA
    UPDATE LICENCIA
    SET id_estado_licencia = 3
    WHERE id_licencia = idLicenciaIN;
    #--------------------------------------------------------------------------------------
    
    SET resultado = 'Licencia anulada con éxito';
    SELECT resultado;
    
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS renewLicencia
DELIMITER //
CREATE PROCEDURE renewLicencia(
	IN idLicenciaIN INT,
    IN fechaRenovacionIN VARCHAR(20),
    IN tipoLicenciaIN VARCHAR(1),
    IN tiempoRenovacionIN INT
)
this_proc:BEGIN
	DECLARE fechaRenovacionConvertida DATE;
    DECLARE tipoLicenciaConvertida INT;
    DECLARE existeLicencia INT;
    DECLARE idPersonaIN INT;
    DECLARE licenciaE INT;
    DECLARE licenciaM INT;
    DECLARE licenciaC INT;
    DECLARE licenciaB INT;
    DECLARE licenciaA INT;
    DECLARE estadoA INT;
    DECLARE estadoB INT;
    DECLARE estadoC INT;
    DECLARE estadoM INT;
    DECLARE estadoE INT;
    DECLARE tiempoLicencia INT;
    DECLARE estadoLicencia INT;
    DECLARE edadPersona INT;
    DECLARE fechaNacimiento DATE;
    DECLARE fechaEmision DATE;
    DECLARE fechaVencimiento DATE;
    DECLARE fechaNuevaVencimiento DATE;
    DECLARE resultado VARCHAR(200);
    DECLARE tiempoLicenciaCorrecto INT;
    DECLARE tipoLicenciaActual INT;
    DECLARE personaViva INT;
    DECLARE fechaEmisionPasada DATE;
    DECLARE fechaVencimientoPasada DATE;
    
    #INCIAR TIEMPO DE LA LICENCIA
    SET tiempoLicenciaCorrecto = 0;

    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA LICENCIA EXISTE
    SET existeLicencia = (SELECT id_licencia FROM LICENCIA WHERE id_licencia = idLicenciaIN);

    IF existeLicencia IS NULL THEN
		SET resultado = 'Error, el número de licencia es inválido.';
        SELECT resultado;
        LEAVE this_proc;      
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR EL TIEMPO DE RENOVACION
    IF tiempoRenovacionIN > 5 THEN
		SET resultado = 'Error, una licencia solo puede ser renovada por 5 años como máximo.';
        SELECT resultado;
        LEAVE this_proc;          
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR LA FECHA A DATE
    SET fechaRenovacionConvertida = str_to_date(fechaRenovacionIN, '%d-%m-%Y');
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #CONVERTIR EL TIPO DE LICENCIA
    IF tipoLicenciaIN = 'A' THEN
		SET tipoLicenciaConvertida = 1;
    ELSEIF tipoLicenciaIN = 'B' THEN
		SET tipoLicenciaConvertida = 2;
    ELSEIF tipoLicenciaIN = 'C' THEN
		SET tipoLicenciaConvertida = 3;
    ELSEIF tipoLicenciaIN = 'M' THEN
		SET tipoLicenciaConvertida = 4;
    ELSEIF tipoLicenciaIN = 'E' THEN
		SET tipoLicenciaConvertida = 5;
    ELSE
		SET resultado = 'Error, tipo de licencia inválido.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET ID DE LA PERSONA Y VERIFICAR QUE LA PERSONA ESTE VIVA
    SET idPersonaIN = (SELECT id_persona FROM LICENCIA WHERE id_licencia = idLicenciaIN);
    SET personaViva = (SELECT id_estado_persona FROM PERSONA WHERE id_persona = idPersonaIN);
    IF personaViva = 2 THEN
		SET resultado = 'Error, esa persona ya ha fallecido.';
        SELECT resultado;
        LEAVE this_proc;      
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #GET EDAD DE LA PERSONA
    SET fechaNacimiento = (SELECT fecha_nacimiento FROM PERSONA WHERE id_persona = idPersonaIN);
    SET edadPersona = (SELECT TIMESTAMPDIFF(YEAR,fechaNacimiento,fechaRenovacionConvertida));
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LA LICENCIA NO ESTE ANULADA Y GET EL TIPO DE LA LICENCIA
    SET estadoLicencia = (SELECT id_estado_licencia FROM LICENCIA WHERE id_licencia = idLicenciaIN);
    IF estadoLicencia = 3 THEN
		SET resultado = 'Error, esa licencia esta anulada, aun no se puede renovar.';
        SELECT resultado;
        LEAVE this_proc;         
    END IF;
    SET tipoLicenciaActual = (SELECT id_tipo_licencia FROM LICENCIA WHERE id_licencia = idLicenciaIN);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET TODAS LAS POSIBLES LICENCIAS DE LA PERSONA
    SET licenciaA = (SELECT id_licencia FROM CATALOGO_LICENCIA
    WHERE id_licencia = idLicenciaIN AND id_tipo_licencia = 1);
    SET licenciaB = (SELECT id_licencia FROM CATALOGO_LICENCIA
    WHERE id_licencia = idLicenciaIN AND id_tipo_licencia = 2);
    SET licenciaC = (SELECT id_licencia FROM CATALOGO_LICENCIA
    WHERE id_licencia = idLicenciaIN AND id_tipo_licencia = 3);
    SET licenciaM = (SELECT id_licencia FROM CATALOGO_LICENCIA
    WHERE id_licencia = idLicenciaIN AND id_tipo_licencia = 4);
    SET licenciaE = (SELECT id_licencia FROM CATALOGO_LICENCIA
    WHERE id_licencia = idLicenciaIN AND id_tipo_licencia = 5);
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR CASOS PARA LICENCIA TIPO A
    IF tipoLicenciaConvertida = 1 THEN
	#--------------------------------------------------------------------------------------
    #VERIFICAR QUE YA TENGA UNA LICENCIA A
		IF licenciaA IS NOT NULL THEN
			IF tipoLicenciaActual = 1 THEN
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 1;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
					UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 1;
				END IF;
			ELSE
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 1
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 1;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 1,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 1;
				END IF;
			END IF;
		ELSE
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE HAYA TENIDO UNA LICENCIA C/B POR MAS DE 3 AÑOS
			SET tiempoLicenciaCorrecto = 0;
			IF licenciaB IS NULL AND licenciaC IS NULL THEN
				SET resultado = 'Error, para solicitar una licencia tipo A necesita haber tenido una tipo C/B por 3 años.';
				SELECT resultado;
				LEAVE this_proc;   
			END IF;
			IF licenciaB IS NOT NULL THEN
					SET fechaEmisionPasada = (SELECT fecha_emision FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaB AND id_tipo_licencia = 2);
					SET fechaVencimientoPasada = (SELECT fecha_vencimiento FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaB AND id_tipo_licencia = 2);
					SET tiempoLicencia = (SELECT TIMESTAMPDIFF(YEAR,fechaEmisionPasada,fechaVencimientoPasada));
					IF tiempoLicencia >= 3 THEN
						SET tiempoLicenciaCorrecto = 1;
					END IF;
			END IF;
			IF tiempoLicenciaCorrecto != 1 THEN
				IF licenciaC IS NOT NULL THEN
					SET fechaEmisionPasada = (SELECT fecha_emision FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaC AND id_tipo_licencia = 3);
					SET fechaVencimientoPasada = (SELECT fecha_vencimiento FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaC AND id_tipo_licencia = 3);
					SET tiempoLicencia = (SELECT TIMESTAMPDIFF(YEAR,fechaEmisionPasada,fechaVencimientoPasada));
					IF tiempoLicencia < 3 THEN
						SET resultado = 'Error, para solicitar una licencia tipo A necesita haber tenido una tipo C/B por 3 años.';
						SELECT resultado;
						LEAVE this_proc;  
					END IF;
					SET tiempoLicenciaCorrecto = 1;
				ELSE
					SET resultado = 'Error, para solicitar una licencia tipo A necesita haber tenido una tipo C/B por 3 años.';
					SELECT resultado;
					LEAVE this_proc;                          
				END IF;
			END IF;
			IF edadPersona < 25 THEN
					SET resultado = 'Error, para solicitar una licencia tipo A tiene que ser mayor a 25 años.';
					SELECT resultado;
					LEAVE this_proc;        
			END IF;
			IF estadoLicencia = 1 THEN
				SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
				WHERE id_licencia = idLicenciaIN);
				SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 1
					WHERE id_licencia = idLicenciaIN;
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,1);
			ELSE 
				SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 1,
					id_estado_licencia = 1
					WHERE id_licencia = idLicenciaIN;  
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,1);
			END IF;
        END IF;
    ELSEIF tipoLicenciaConvertida = 2 THEN
		IF licenciaB IS NOT NULL THEN
			IF tipoLicenciaActual = 2 THEN
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 2;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
					UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 2;
				END IF;
			ELSE
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 2
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 2;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 2,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 2;
				END IF;
			END IF;
        ELSE
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE HAYA TENIDO UNA LICENCIA C/B POR MAS DE 3 AÑOS
			IF licenciaC IS NULL THEN
				SET resultado = 'Error, para solicitar una licencia tipo B necesita haber tenido una tipo C por 2 años.';
				SELECT resultado;
				LEAVE this_proc;   
			END IF;
			IF licenciaC IS NOT NULL THEN
					SET fechaEmisionPasada = (SELECT fecha_emision FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaC AND id_tipo_licencia = 3);
					SET fechaVencimientoPasada = (SELECT fecha_vencimiento FROM CATALOGO_LICENCIA
						WHERE id_licencia = licenciaC AND id_tipo_licencia = 3);
					SET tiempoLicencia = (SELECT TIMESTAMPDIFF(YEAR,fechaEmisionPasada,fechaVencimientoPasada));
					IF tiempoLicencia < 2 THEN
						SET resultado = 'Error, para solicitar una licencia tipo B necesita haber tenido una tipo C por 2 años.';
						SELECT resultado;
						LEAVE this_proc;  
					END IF;
					SET tiempoLicenciaCorrecto = 1;
			END IF;
			IF edadPersona < 23 THEN
					SET resultado = 'Error, para solicitar una licencia tipo B tiene que ser mayor a 23 años.';
					SELECT resultado;
					LEAVE this_proc;        
			END IF;
			IF estadoLicencia = 1 THEN
				SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
				WHERE id_licencia = idLicenciaIN);
				SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 2
					WHERE id_licencia = idLicenciaIN;
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,2);
			ELSE 
				SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 2,
					id_estado_licencia = 1
					WHERE id_licencia = idLicenciaIN;  
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,2);
			END IF;
        END IF;
    ELSEIF tipoLicenciaConvertida = 3 THEN
		IF licenciaC IS NOT NULL THEN
			IF tipoLicenciaActual = 3 THEN
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 3;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
					UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 3;
				END IF;
			ELSE
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 3
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 3;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 3,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 3;
				END IF;
			END IF;
        ELSE
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE HAYA TENIDO UNA LICENCIA C/B POR MAS DE 3 AÑOS
			IF licenciaM IS NULL THEN
				SET resultado = 'Error, para solicitar una licencia tipo C tien que haber solicitado al menos una licencia tipo M.';
				SELECT resultado;
				LEAVE this_proc;   
			END IF;
			IF edadPersona < 16 THEN
					SET resultado = 'Error, para solicitar una licencia tipo C tiene que ser mayor a 16 años.';
					SELECT resultado;
					LEAVE this_proc;        
			END IF;
			IF estadoLicencia = 1 THEN
				SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
				WHERE id_licencia = idLicenciaIN);
				SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 3
					WHERE id_licencia = idLicenciaIN;
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,3);
			ELSE 
				SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 3,
					id_estado_licencia = 1
					WHERE id_licencia = idLicenciaIN;  
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,3);
			END IF;
        END IF;		
    ELSEIF tipoLicenciaConvertida = 4 THEN
		IF licenciaM IS NOT NULL THEN
			IF tipoLicenciaActual = 4 THEN
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 4;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
					UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 4;
				END IF;
			ELSE
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 4
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 4;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 4,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 4;
				END IF;
			END IF;
        ELSE
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE HAYA TENIDO UNA LICENCIA C/B POR MAS DE 3 AÑOS
			IF licenciaC IS NULL THEN
				SET resultado = 'Error, para solicitar una licencia tipo M tiene que haber solicitado al menos una licencia tipo C.';
				SELECT resultado;
				LEAVE this_proc;   
			END IF;
			IF edadPersona < 16 THEN
					SET resultado = 'Error, para solicitar una licencia tipo M tiene que ser mayor a 16 años.';
					SELECT resultado;
					LEAVE this_proc;        
			END IF;
			IF estadoLicencia = 1 THEN
				SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
				WHERE id_licencia = idLicenciaIN);
				SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 4
					WHERE id_licencia = idLicenciaIN;
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,4);
			ELSE 
				SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
				UPDATE LICENCIA
					SET fecha_vencimiento = fechaNuevaVencimiento,
					id_tipo_licencia = 4,
					id_estado_licencia = 1
					WHERE id_licencia = idLicenciaIN;  
				INSERT INTO CATALOGO_LICENCIA
					(id_licencia,fecha_emision,fecha_vencimiento,id_tipo_licencia)
					VALUES (idLicenciaIN,fechaRenovacionConvertida,fechaNuevaVencimiento,4);
			END IF;
        END IF;		
    ELSEIF tipoLicenciaConvertida = 5 THEN
		IF licenciaE IS NOT NULL THEN
			IF tipoLicenciaActual = 5 THEN
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 5;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
					UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 5;
				END IF;
			ELSE
				IF estadoLicencia = 1 THEN
					SET fechaVencimiento = (SELECT fecha_vencimiento FROM LICENCIA
					WHERE id_licencia = idLicenciaIN);
					SET fechaNuevaVencimiento = DATE_ADD(fechaVencimiento, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 5
						WHERE id_licencia = idLicenciaIN;
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 5;
				ELSE 
					SET fechaNuevaVencimiento = DATE_ADD(fechaRenovacionConvertida, INTERVAL tiempoRenovacionIN YEAR);
					UPDATE LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento,
                        id_tipo_licencia = 5,
                        id_estado_licencia = 1
						WHERE id_licencia = idLicenciaIN;  
                    UPDATE CATALOGO_LICENCIA
						SET fecha_vencimiento = fechaNuevaVencimiento
						WHERE id_licencia = idLicenciaIN AND
						id_tipo_licencia = 5;
				END IF;
			END IF;
        ELSE
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE HAYA TENIDO UNA LICENCIA C/B POR MAS DE 3 AÑOS
			IF licenciaE IS NULL THEN
				SET resultado = 'Error, la licencia no existe.';
				SELECT resultado;
				LEAVE this_proc;   
			END IF;
        END IF;	
    END IF;
    #--------------------------------------------------------------------------------------
    SET resultado = 'Licencia renovada con éxito';
    SELECT resultado;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getNacimiento
DELIMITER //
CREATE PROCEDURE getNacimiento(
	IN cuiIN BIGINT
)
this_proc:BEGIN
	DECLARE resultado VARCHAR(700);
    DECLARE noActa BIGINT;
    DECLARE noActaConvertido VARCHAR(10);
    DECLARE cuiConvertido VARCHAR(13);
    DECLARE idPersonaIN BIGINT;
    DECLARE apellido1 VARCHAR(50);
    DECLARE apellido2 VARCHAR(50);
    DECLARE nombre1 VARCHAR(50);
    DECLARE nombre2 VARCHAR(50);
    DECLARE nombre3 VARCHAR(50);
    DECLARE fechaNacimiento DATE;
    DECLARE idDepartamento INT;
    DECLARE idMunicipio INT;
    DECLARE idGenero INT;
    DECLARE departamento VARCHAR(50);
    DECLARE municipio VARCHAR(50);
    DECLARE genero VARCHAR(50);
    DECLARE nombrePadre1 VARCHAR(50);
    DECLARE nombrePadre2 VARCHAR(50);
    DECLARE nombrePadre3 VARCHAR(50);
    DECLARE apellidoPadre1 VARCHAR(50);
    DECLARE apellidoPadre2 VARCHAR(50);
    DECLARE nombreMadre1 VARCHAR(50);
    DECLARE nombreMadre2 VARCHAR(50);
    DECLARE nombreMadre3 VARCHAR(50);
    DECLARE apellidoMadre1 VARCHAR(50);
    DECLARE apellidoMadre2 VARCHAR(50);
    DECLARE idPadre BIGINT;
    DECLARE idMadre BIGINT;
    DECLARE dpiPadre VARCHAR(13);
    DECLARE dpiMadre VARCHAR(13);
    DECLARE nombresPadre VARCHAR(150);
    DECLARE apellidosPadre VARCHAR(100);
    DECLARE nombresMadre VARCHAR(150);
    DECLARE apellidosMadre VARCHAR(100);
    DECLARE nombres VARCHAR(150);
    DECLARE apellidos VARCHAR(100);
    DECLARE nombresPadreContador INT;
    DECLARE nombresMadreContador INT;
    DECLARE nombresPersonaContador INT;
    
    #--------------------------------------------------------------------------------------
    #GET CUI EN CHAR
    SET cuiConvertido = CAST(cuiIN AS CHAR(13));
		
	#VERIFICAR QUE LA PERSONA EXISETE Y GET ID
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiConvertido);
    IF idPersonaIN IS NULL THEN
		SET resultado = 'Error, el número de cui no es válido o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------

	#--------------------------------------------------------------------------------------
    #GET TODOS LOS DATOS DE LA PERSONA
    SELECT id_persona, fecha_nacimiento,id_padre,id_madre,id_genero,id_municipio
    INTO noActa,fechaNacimiento,idPadre,idMadre,idGenero,idMunicipio
    FROM PERSONA
    WHERE id_persona = idPersonaIN;
    #--------------------------------------------------------------------------------------
    
	
    #--------------------------------------------------------------------------------------
    #GET DEPARTAMENTO, GENERO Y MUNICIPIO
    SET idDepartamento = (SELECT id_departamento 
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);

	SET departamento = (SELECT nombre_departamento 
		FROM DEPARTAMENTO WHERE id_departamento = idDepartamento);
    
    SET municipio = (SELECT nombre_municipio
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);
        
	SET genero = (SELECT nombre_genero
		FROM GENERO WHERE id_genero = idGenero);
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #GET NOMBRES Y APELLIDOS DE LOS PADRES
    SELECT cui
		INTO dpiPadre
		FROM PERSONA WHERE id_persona = idPadre;
    
    SELECT cui
		INTO dpiMadre
		FROM PERSONA WHERE id_persona = idMadre;
	#--------------------------------------------------------------------------------------
        
    #--------------------------------------------------------------------------------------
    #VERIFICAR TODOS LOS NOMBRES Y LOS APELLIDOS
    SET nombresPersonaContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = noActa);
    SET nombresPadreContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = idPadre);
    SET nombresMadreContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = idMadre);
    
    #APELLIDOS, SIEMPRE SON 2 PARA CADA UNO
    SET apellidoPadre1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPadre 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoPadre2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPadre 
		ORDER BY id_apellido ASC LIMIT 1,1);
    SET apellidoMadre1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idMadre 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoMadre2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idMadre 
		ORDER BY id_apellido ASC LIMIT 1,1);
    SET apellido1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellido2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidos = CONCAT(apellido1, ' ',apellido2);
    SET apellidosPadre = CONCAT(apellidoPadre1,' ',apellidoPadre2);
    SET apellidosMadre = CONCAT(apellidoMadre1,' ',apellidoMadre2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombre1 = '';
    SET nombre2 = '';
    SET nombre3 = '';
    SET nombrePadre1 = '';
    SET nombrePadre2 = '';
    SET nombrePadre3 = '';
    SET nombreMadre1 = '';
    SET nombreMadre2 = '';
    SET nombreMadre3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresPersonaContador >= 1 THEN
		SET nombre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresPersonaContador >= 2 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresPersonaContador >= 3 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    
    IF nombresPadreContador >= 1 THEN
		SET nombrePadre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPadre 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresPadreContador >= 2 THEN
  		SET nombrePadre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPadre 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresPadreContador >= 3 THEN
  		SET nombrePadre3 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPadre 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    IF nombresMadreContador >= 1 THEN
		SET nombreMadre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idMadre 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresMadreContador >= 2 THEN
  		SET nombreMadre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idMadre 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresMadreContador >= 3 THEN
  		SET nombreMadre3 = (SELECT nombre FROM NOMBRE WHERE id_persona = idMadre 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    
    SET nombres = CONCAT(nombre1, ' ',nombre2, ' ', nombre3);
    SET nombresPadre = CONCAT(nombrePadre1,' ',nombrePadre2,' ',nombrePadre3);
    SET nombresMadre = CONCAT(nombreMadre1,' ',nombreMadre2,' ',nombreMadre3);
    #--------------------------------------------------------------------------------------
    SELECT noActa AS Noacta, cuiConvertido as CUI, apellidos as Apellidos, nombres as Nombres,
    dpiPadre as Dpipadre, nombresPadre as NombrePadre, apellidosPadre as ApellidoPadre,
    dpiMadre as DpiMadre, nombresMadre as NombreMadre, apellidosMadre as ApellidoMadre,
    fechaNacimiento as FechaNacimiento, departamento as Departamento, municipio as Municipio,
    genero as Genero;

END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getDpi
DELIMITER //
CREATE PROCEDURE getDpi(
	IN cuiIN BIGINT
)
this_proc:BEGIN
	DECLARE resultado VARCHAR(700);
    DECLARE idPersonaIN BIGINT;
    DECLARE noActa BIGINT;
    DECLARE cuiConvertido VARCHAR(13);
    DECLARE apellido1 VARCHAR(50);
    DECLARE apellido2 VARCHAR(50);
    DECLARE nombre1 VARCHAR(50);
    DECLARE nombre2 VARCHAR(50);
    DECLARE nombre3 VARCHAR(50);
    DECLARE fechaNacimiento DATE;
    DECLARE idDepartamento INT;
    DECLARE idMunicipio INT;
    DECLARE idGenero INT;
    DECLARE departamento VARCHAR(50);
    DECLARE departamentoResidencia VARCHAR(50);
    DECLARE municipio VARCHAR(50);
    DECLARE municipioResidencia VARCHAR(50);
    DECLARE genero VARCHAR(50);
    DECLARE nombres VARCHAR(150);
    DECLARE apellidos VARCHAR(100);
    DECLARE nombresPersonaContador INT;
    DECLARE idDpi INT;
	
    #--------------------------------------------------------------------------------------
    #GET CUI EN CHAR
    SET cuiConvertido = CAST(cuiIN AS CHAR(13));
		
	#VERIFICAR QUE LA PERSONA EXISETE Y GET ID
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiConvertido);
    IF idPersonaIN IS NULL THEN
		SET resultado = 'Error, el número de cui no es válido o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE TENGA DPI LA PERSONA
    SET idDpi = (SELECT id_dpi FROM DPI WHERE id_persona = idPersonaIN);
    IF idDpi IS NULL THEN
		SET resultado = 'Error, esa persona es menor de edad o todavía no tiene DPI.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    
	#--------------------------------------------------------------------------------------
    #GET TODOS LOS DATOS DE LA PERSONA
    SELECT id_persona,fecha_nacimiento,id_genero,id_municipio
    INTO noActa,fechaNacimiento,idGenero,idMunicipio
    FROM PERSONA
    WHERE id_persona = idPersonaIN;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #GET DEPARTAMENTO, GENERO Y MUNICIPIO
    SET idDepartamento = (SELECT id_departamento 
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);

	SET departamento = (SELECT nombre_departamento 
		FROM DEPARTAMENTO WHERE id_departamento = idDepartamento);
    
    SET municipio = (SELECT nombre_municipio
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);
        
	SET genero = (SELECT nombre_genero
		FROM GENERO WHERE id_genero = idGenero);
        
	SET idMunicipio = (SELECT id_municipio 
		FROM DPI WHERE id_persona = idPersonaIN);
        
    SET idDepartamento = (SELECT id_departamento 
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);
    
    SET departamentoResidencia = (SELECT nombre_departamento 
		FROM DEPARTAMENTO WHERE id_departamento = idDepartamento);
        
	SET municipioResidencia = (SELECT nombre_municipio
		FROM MUNICIPIO WHERE id_municipio = idMunicipio);
    #--------------------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------------------
    #GET NOMBRES DE LA PERSONA
    SET nombresPersonaContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = noActa);

    SET apellido1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellido2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidos = CONCAT(apellido1, ' ',apellido2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombre1 = '';
    SET nombre2 = '';
    SET nombre3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresPersonaContador >= 1 THEN
		SET nombre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresPersonaContador >= 2 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresPersonaContador >= 3 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    SET nombres = CONCAT(nombre1, ' ',nombre2, ' ', nombre3);
    #--------------------------------------------------------------------------------------

	SELECT 
		cuiConvertido as CUI,
		apellidos as Apellidos,
		nombres as Nombres,
		fechaNacimiento as FechaNacimiento,
		departamento as Departamento,
		municipio as Municipio,
		departamentoResidencia as DeptVecindad,
		municipioResidencia as MuniVecindad,
		genero as Genero;

END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////




#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getLicencias
DELIMITER //
CREATE PROCEDURE getLicencias(
	IN cuiIN BIGINT
)
this_proc:BEGIN
	DECLARE resultado VARCHAR(700);
    DECLARE idPersonaIN BIGINT;
    DECLARE cuiConvertido VARCHAR(13);
    DECLARE apellido1 VARCHAR(50);
    DECLARE apellido2 VARCHAR(50);
    DECLARE nombre1 VARCHAR(50);
    DECLARE nombre2 VARCHAR(50);
    DECLARE nombre3 VARCHAR(50);
    DECLARE fechaEmision DATE;
    DECLARE fechaVencimiento DATE;
    DECLARE nombres VARCHAR(150);
    DECLARE apellidos VARCHAR(100);
    DECLARE nombresPersonaContador INT;
    
    
    #--------------------------------------------------------------------------------------
    #GET CUI EN CHAR
    SET cuiConvertido = CAST(cuiIN AS CHAR(13));
		
	#VERIFICAR QUE LA PERSONA EXISETE Y GET ID
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiConvertido);
    IF idPersonaIN IS NULL THEN
		SET resultado = 'Error, el número de cui no es válido o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------    


    #--------------------------------------------------------------------------------------
    #GET NOMBRES DE LA PERSONA
    SET nombresPersonaContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = idPersonaIN);

    SET apellido1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellido2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidos = CONCAT(apellido1, ' ',apellido2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombre1 = '';
    SET nombre2 = '';
    SET nombre3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresPersonaContador >= 1 THEN
		SET nombre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresPersonaContador >= 2 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresPersonaContador >= 3 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    SET nombres = CONCAT(nombre1, ' ',nombre2, ' ', nombre3);
    #--------------------------------------------------------------------------------------

	SELECT a.id_licencia AS NoLicencia, nombres As nombres, apellidos AS apellidos,
    b.fecha_emision As FechaEmision, b.fecha_vencimiento AS FechaVencimiento, 
    c.nombre_tipo_licencia AS TipoLicencia FROM LICENCIA AS a
    INNER JOIN CATALOGO_LICENCIA AS b
    ON a.id_licencia = b.id_licencia
    INNER JOIN TIPO_LICENCIA AS c
    ON b.id_tipo_licencia = c.id_tipo_licencia
    WHERE a.id_persona = idPersonaIN;
END //;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getMatrimonio
DELIMITER //
CREATE PROCEDURE getMatrimonio(
	IN idMatrimonioIN INT
)
this_proc:BEGIN
	DECLARE dpiHombre INT;
    DECLARE dpiMujer INT;
    DECLARE nombreH1 VARCHAR(50);
    DECLARE nombreH2 VARCHAR(50);
    DECLARE nombreH3 VARCHAR(50);
    DECLARE nombreM1 VARCHAR(50);
    DECLARE nombreM2 VARCHAR(50);
    DECLARE nombreM3 VARCHAR(50);
    DECLARE apellidoH1 VARCHAR(50);
    DECLARE apellidoH2 VARCHAR(50);
    DECLARE apellidoM1 VARCHAR(50);
    DECLARE apellidoM2 VARCHAR(50);
    DECLARE nombresH  VARCHAR(50);
    DECLARE apellidosH  VARCHAR(50);
    DECLARE nombresM  VARCHAR(50);
    DECLARE apellidosM VARCHAR(50);
	DECLARE fechaMatrimonio DATE;
    DECLARE resultado VARCHAR(200);
	DECLARE nombresHombreContador INT;
    DECLARE nombresMujerContador INT;
	#--------------------------------------------------------------------------------------
    #VERIFICAR QUE EL MATRIMONIO EXISTE
    SELECT id_esposo,id_esposa,fecha_matrimonio INTO dpiHombre,dpiMujer,fechaMatrimonio
    FROM MATRIMONIO WHERE id_matrimonio = idMatrimonioIN 
    ORDER BY id_matrimonio DESC LIMIT 1;
    
    IF dpiHombre IS NULL THEN
		SET resultado = 'Error, el número de matrimonio es erróneo o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------


    #--------------------------------------------------------------------------------------
    #VERIFICAR TODOS LOS NOMBRES Y LOS APELLIDOS
    SET nombresHombreContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = dpiHombre);
    SET nombresMujerContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = dpiMujer);
    
    #APELLIDOS, SIEMPRE SON 2 PARA CADA UNO
    SET apellidoH1 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiHombre 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoH2 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiHombre 
		ORDER BY id_apellido ASC LIMIT 1,1);
    SET apellidoM1 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiMujer 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoM2 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiMujer 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidosH = CONCAT(apellidoH1,' ',apellidoH2);
    SET apellidosM = CONCAT(apellidoM1,' ',apellidoM2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombreH1 = '';
    SET nombreH2 = '';
    SET nombreH3 = '';
    SET nombreM1 = '';
    SET nombreM2 = '';
    SET nombreM3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresHombreContador >= 1 THEN
		SET nombreH1 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresHombreContador >= 2 THEN
  		SET nombreH2 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresHombreContador >= 3 THEN
  		SET nombreH3 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    IF nombresMujerContador >= 1 THEN
		SET nombreM1 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresMujerContador >= 2 THEN
  		SET nombreM2 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresMujerContador >= 3 THEN
  		SET nombreM3 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    
    SET nombresH = CONCAT(nombreH1,' ',nombreH2,' ',nombreH3);
    SET nombresM = CONCAT(nombreM1,' ',nombreM2,' ',nombreM3);
    #--------------------------------------------------------------------------------------
    
    SELECT idMatrimonioIN AS NoMatrimonio, dpiHombre AS DPIHombre, 
    CONCAT(nombresH, apellidosH) AS NombreHombre,
    dpiMujer AS DPIMujer, CONCAT(nombresM, apellidosM) AS NombreMujer,
    fechaMatrimonio AS Fecha;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getDivorcio
DELIMITER //
CREATE PROCEDURE getDivorcio(
	IN idMatrimonioIN INT
)
this_proc:BEGIN
	DECLARE matrimonioExiste INT;
    DECLARE divorcioExiste INT;
    DECLARE estadoMatrimonio INT;
    DECLARE idDivorcio INT;
	DECLARE dpiHombre INT;
    DECLARE dpiMujer INT;
    DECLARE nombreH1 VARCHAR(50);
    DECLARE nombreH2 VARCHAR(50);
    DECLARE nombreH3 VARCHAR(50);
    DECLARE nombreM1 VARCHAR(50);
    DECLARE nombreM2 VARCHAR(50);
    DECLARE nombreM3 VARCHAR(50);
    DECLARE apellidoH1 VARCHAR(50);
    DECLARE apellidoH2 VARCHAR(50);
    DECLARE apellidoM1 VARCHAR(50);
    DECLARE apellidoM2 VARCHAR(50);
    DECLARE nombresH  VARCHAR(50);
    DECLARE apellidosH  VARCHAR(50);
    DECLARE nombresM  VARCHAR(50);
    DECLARE apellidosM VARCHAR(50);
	DECLARE fechaMatrimonio DATE;
    DECLARE fechaDivorcio DATE;
    DECLARE resultado VARCHAR(200);
	DECLARE nombresHombreContador INT;
    DECLARE nombresMujerContador INT;
    

	#--------------------------------------------------------------------------------------
    #VERIFICAR QUE EL MATRIMONIO EXISTE
    SELECT id_esposo,id_esposa,fecha_matrimonio, id_estado_matrimonio 
    INTO dpiHombre,dpiMujer,fechaMatrimonio,estadoMatrimonio
    FROM MATRIMONIO WHERE id_matrimonio = idMatrimonioIN 
    ORDER BY id_matrimonio DESC LIMIT 1;
    
    IF dpiHombre IS NULL THEN
		SET resultado = 'Error, el número de matrimonio es erróneo o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    
    IF estadoMatrimonio = 1 THEN
		SET resultado = 'Error, el matrimonio aún sigue activo.';
        SELECT resultado;
        LEAVE this_proc;    
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR QUE LE DIVORCIO EXISTE
    SELECT id_divorcio,fecha_divorcio INTO idDivorcio,fechaDivorcio
    FROM DIVORCIO WHERE id_matrimonio = idMatrimonioIN
    ORDER BY id_divorcio DESC LIMIT 1;
    
    
    IF idDivorcio IS NULL THEN
		SET resultado = 'Error, el número de matrimonio es erróneo o no existe el divorcio.';
        SELECT resultado;
        LEAVE this_proc;    
    END IF;
    #--------------------------------------------------------------------------------------
    
    
#--------------------------------------------------------------------------------------
    #VERIFICAR TODOS LOS NOMBRES Y LOS APELLIDOS
    SET nombresHombreContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = dpiHombre);
    SET nombresMujerContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = dpiMujer);
    
    #APELLIDOS, SIEMPRE SON 2 PARA CADA UNO
    SET apellidoH1 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiHombre 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoH2 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiHombre 
		ORDER BY id_apellido ASC LIMIT 1,1);
    SET apellidoM1 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiMujer 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellidoM2 = (SELECT apellido FROM APELLIDO WHERE id_persona = dpiMujer 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidosH = CONCAT(apellidoH1,' ',apellidoH2);
    SET apellidosM = CONCAT(apellidoM1,' ',apellidoM2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombreH1 = '';
    SET nombreH2 = '';
    SET nombreH3 = '';
    SET nombreM1 = '';
    SET nombreM2 = '';
    SET nombreM3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresHombreContador >= 1 THEN
		SET nombreH1 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresHombreContador >= 2 THEN
  		SET nombreH2 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresHombreContador >= 3 THEN
  		SET nombreH3 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiHombre 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    IF nombresMujerContador >= 1 THEN
		SET nombreM1 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresMujerContador >= 2 THEN
  		SET nombreM2 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresMujerContador >= 3 THEN
  		SET nombreM3 = (SELECT nombre FROM NOMBRE WHERE id_persona = dpiMujer 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    SET nombresH = CONCAT(nombreH1,' ',nombreH2,' ',nombreH3);
    SET nombresM = CONCAT(nombreM1,' ',nombreM2,' ',nombreM3);
    #--------------------------------------------------------------------------------------
    
    SELECT idDivorcio AS NoDivorcio, dpiHombre AS DPIHombre, 
    CONCAT(nombresH, apellidosH) AS NombreHombre,
    dpiMujer AS DPIMujer, CONCAT(nombresM, apellidosM) AS NombreMujer,
    fechaDivorcio AS Fecha;
END // ;
DELIMITER ;

#//////////////////////////////////////////////////////////////////////////////////////



#//////////////////////////////////////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS getDefuncion
DELIMITER //
CREATE PROCEDURE getDefuncion(
	IN cuiIN BIGINT
)
this_proc:BEGIN
	DECLARE resultado VARCHAR(700);
    DECLARE fechaDefuncion DATE;
    DECLARE motivoDefuncion VARCHAR(200);
    DECLARE idDefuncion INT;
    DECLARE idPersonaIN BIGINT;
    DECLARE cuiConvertido VARCHAR(13);
    DECLARE apellido1 VARCHAR(50);
    DECLARE apellido2 VARCHAR(50);
    DECLARE nombre1 VARCHAR(50);
    DECLARE nombre2 VARCHAR(50);
    DECLARE nombre3 VARCHAR(50);
    DECLARE nombres VARCHAR(150);
    DECLARE apellidos VARCHAR(100);
    DECLARE nombresPersonaContador INT;
    DECLARE idMunicipio INT;
    DECLARE idDepartamento INT;
    DECLARE municipio VARCHAR(50);
    DECLARE departamento VARCHAR(50);
    

    #--------------------------------------------------------------------------------------
    #GET CUI EN CHAR
    SET cuiConvertido = CAST(cuiIN AS CHAR(13));
		
	#VERIFICAR QUE LA PERSONA EXISETE Y GET ID
    SET idPersonaIN = (SELECT id_persona FROM PERSONA WHERE cui = cuiConvertido);
    IF idPersonaIN IS NULL THEN
		SET resultado = 'Error, el número de cui no es válido o no existe.';
        SELECT resultado;
        LEAVE this_proc;
    END IF;
    #--------------------------------------------------------------------------------------
    
    
    #--------------------------------------------------------------------------------------
    #VERIFICAR ESTADO DE LA PESRONA
    SELECT id_defucion,fecha_defuncion,motivo_defuncion INTO idDefuncion,fechaDefuncion,
    motivoDefuncion FROM DEFUNCION WHERE id_persona = idPersonaIN;
    
    IF idDefuncion IS NULL THEN
		SET resultado = 'Error, la defunción de esa persona no ha sido registrada o no ha fallecido.';
        SELECT resultado;
        LEAVE this_proc;    
    END IF;
    #--------------------------------------------------------------------------------------
    

    #--------------------------------------------------------------------------------------
    #GET NOMBRES DE LA PERSONA
    SET nombresPersonaContador = (SELECT count(id_persona) FROM NOMBRE WHERE id_persona = idPersonaIN);

    SET apellido1 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1);
    SET apellido2 = (SELECT apellido FROM APELLIDO WHERE id_persona = idPersonaIN 
		ORDER BY id_apellido ASC LIMIT 1,1);
    
    #JUNTAR LOS VALORES PARA LA RESPUESTA DE LOS APELLIDOS
    SET apellidos = CONCAT(apellido1, ' ',apellido2);
    
    #NOMBRES, PUEDE SER DESDE 1 HASTA 3
    #SET VALORES POR DEFECTO
    SET nombre1 = '';
    SET nombre2 = '';
    SET nombre3 = '';
    
    #CONSEGUIR TODOS LOS NOMBRES
    IF nombresPersonaContador >= 1 THEN
		SET nombre1 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1);
	END IF;
    IF nombresPersonaContador >= 2 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 1,1);  
    END IF;
    IF nombresPersonaContador >= 3 THEN
  		SET nombre2 = (SELECT nombre FROM NOMBRE WHERE id_persona = idPersonaIN 
			ORDER BY id_nombre ASC LIMIT 2,1);      
    END IF;
    
    SET nombres = CONCAT(nombre1, ' ',nombre2, ' ', nombre3);
    #--------------------------------------------------------------------------------------

    
    #--------------------------------------------------------------------------------------
    #GET DEPARTAMENTO Y MUNICIPIO
    SELECT id_municipio INTO idMunicipio FROM PERSONA WHERE id_persona = idPersonaIN;
    SELECT id_departamento INTO idDepartamento FROM MUNICIPIO WHERE id_municipio = idMunicipio;
    
	SELECT nombre_municipio INTO municipio FROM MUNICIPIO WHERE id_municipio = idMunicipio;
    SELECT nombre_departamento INTO departamento FROM DEPARTAMENTO WHERE id_departamento = idDepartamento;
    #--------------------------------------------------------------------------------------
    
    SELECT idDefuncion AS NoActa, cuiConvertido AS CUI, apellidos AS Apellidos,
    nombres AS Nombres, fechaDefuncion AS FechaFallecimiento, departamento As Departamento,
    municipio AS Municipio, motivoDefuncion AS Motivo;
END // ;
DELIMITER ;
#//////////////////////////////////////////////////////////////////////////////////////


#//////////////////////////EJECUCION DE PROCEDIMIENTOS Y FUNCIONES/////////////////////////////


#**********************CREACION DE PERSONAS SIN PADRES*****************************************
CALL crearPersonaSinPadres('Adama','','','Traore','Valverde','12-12-1995',101,'M');
CALL crearPersonaSinPadres('Raquel','','','McAdams','Sinphony','12-12-1993',101,'F');
CALL crearPersonaSinPadres('Benjamin','','','Franklin','Sales','12-12-1993',101,'M');
select * from persona;
select * from nombre;
select * from apellido;
#**********************************************************************************************

#******************************GENERACION DE NUEVO DPI*****************************************
CALL generarDpi(1000003010101,'21-04-2022',101);
CALL generarDpi(1000004010101,'21-04-2022',101);

select * from dpi;
#**********************************************************************************************

#**********************************REGISTRAR NACIMIENTO****************************************
CALL registrarNacimiento(1000003010101,1000004010101,'Albert','Joan','','22-04-2018',101,'M');
select * from persona;
select * from nombre;
select * from apellido;
#**********************************************************************************************

#**********************************REGISTRAR DEFUNCION*****************************************
CALL addDefuncion(1000000010101,'15-04-2015','Se cayo de la bañera.');
select * from persona;
select * from defuncion;
#**********************************************************************************************


#**********************************REGISTRAR MATRIMONIO****************************************
CALL addMatrimonio(1000003010101,1000004010101,'24-04-2019');
select * from matrimonio;
#**********************************************************************************************

#**********************************REGISTRAR DIVORCIO******************************************
CALL addDivorcio(1,'23-04-2020');
select * from persona;
select * from divorcio;
#**********************************************************************************************


#**********************************REGISTRAR LICENCIA******************************************
#1000003010101
#1000004010101
CALL addLicencia(1000004010101,'17-04-2017','C');
select * from licencia;
select * from catalogo_licencia;
#**********************************************************************************************

#*****************ACTUALIZAR EL ESTADO DE LAS LICENCIAS****************************************
CALL actualizarEstadoAnulacion();
CALL actualizarEstadoLicencias();
select * from anulacion_licencia;
select * from catalogo_licencia;
select * from licencia;
#**********************************************************************************************


#**********************************ANULAR LICENCIA*********************************************
CALL anularLicencia(1,'30-06-2022','Exceso de velocidad.');
select * from anulacion_licencia;
select * from licencia;
#**********************************************************************************************


#**********************************RENOVAR LICENCIA********************************************
CALL renewLicencia(3,'24-04-2022','A',3);
select * from persona;
select * from licencia;
select * from catalogo_licencia;
#**********************************************************************************************


#************************************GET NACIMIENTO********************************************
CALL getNacimiento(1000006010101);
select * from persona;
#**********************************************************************************************


#************************************GET NACIMIENTO********************************************
CALL getDpi(1000004010101);
select * from persona;
#**********************************************************************************************



#************************************GET LICENCIAS*********************************************
CALL getLicencias(1000003010101);
select * from persona;
#**********************************************************************************************


#************************************GET DIVORCIO**********************************************
CALL getDivorcio(1);
select * from divorcio;
#**********************************************************************************************


#************************************GET DEFUNCION*********************************************
CALL getDefuncion(1000000010101);
select * from persona;
select * from nombre;
#**********************************************************************************************


#************************************GET MATRIMONIO********************************************
CALL getMatrimonio(1);
select * from matrimonio;
#**********************************************************************************************






	

