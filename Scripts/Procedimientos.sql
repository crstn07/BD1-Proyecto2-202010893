DROP PROCEDURE IF EXISTS crearCarrera;
DELIMITER $$
CREATE PROCEDURE crearCarrera(IN nombre VARCHAR(30))
proc_crearCarrera:BEGIN
	IF NOT soloLetras(nombre) THEN
		CALL Mensaje(CONCAT("No se pudo crear la carrera, el nombre no contiene solo letras: ", nombre), 0);
		LEAVE proc_crearCarrera;
    END IF;
    INSERT INTO carreras(Nombre) VALUES (nombre);
    CALL Mensaje(CONCAT("Se creó la carrera: ", nombre), 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Mensaje;
DELIMITER $$
CREATE PROCEDURE Mensaje(IN msg TEXT, IN tipo BOOLEAN)
BEGIN
	-- 1 -> Exito, 0 -> Error
	IF tipo THEN
		SELECT msg as Éxito;
	ELSE
		SELECT msg as Error;
    END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS registrarEstudiante;
DELIMITER $$
CREATE PROCEDURE registrarEstudiante(
IN carne VARCHAR(15),
IN nombre VARCHAR(50),
IN apellido VARCHAR(50),
IN fecha_nac VARCHAR(10),
IN email VARCHAR(50),
IN tel VARCHAR(15),
IN dir VARCHAR(100) ,
IN num_dpi VARCHAR(15),
IN carrera_id VARCHAR(10)
)
proc_registrarEstudiante:BEGIN
	IF email IS NULL THEN
    	CALL Mensaje("No se pudo registrar el estudiante, no ingresó correo", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF NOT validarEmail(email) THEN
		CALL Mensaje(CONCAT("No se pudo registrar el estudiante, email no válido: ", email), 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF carne IS NULL THEN 
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó carnet", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF (SELECT Carnet FROM estudiantes WHERE Carnet = carne) THEN
		CALL Mensaje(CONCAT("No se pudo registrar el estudiante: ", carne, " - ", nombre, " ", apellido, ", ya existe"), 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF nombre IS NULL THEN 
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó nombres", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF apellido IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó apellido", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF fecha_nac IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó fecha de nacimiento", 0);
		LEAVE proc_registrarEstudiante;  
	ELSEIF tel IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó telefono", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF dir IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó dirección", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF num_dpi IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó DPI", 0);
		LEAVE proc_registrarEstudiante;
	ELSEIF carrera_id IS NULL THEN
		CALL Mensaje("No se pudo registrar el estudiante, no ingresó ID de carrera", 0);
		LEAVE proc_registrarEstudiante;
    END IF;
    
    INSERT INTO estudiantes(Carnet,DPI,Nombres,Apellidos,Fecha_Nacimiento,Correo,Telefono,Direccion,Creditos,Fecha_Creacion,Carrera_ID)
	VALUES(carne,num_dpi,nombre,apellido,STR_TO_DATE(fecha_nac, '%d-%m-%Y'),email,tel,dir,0,CURDATE(),carrera_id);
    CALL Mensaje(CONCAT("Se registró el estudiante: ", nombre, " ", apellido), 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS registrarDocente;
DELIMITER $$
CREATE PROCEDURE registrarDocente(
IN nombre VARCHAR(50),
IN apellido VARCHAR(50),
IN fecha_nac VARCHAR(10),
IN email VARCHAR(50),
IN tel VARCHAR(15),
IN dir VARCHAR(100) ,
IN num_dpi VARCHAR(15),
IN reg_siif VARCHAR(15)
)
proc_registrarDocente:BEGIN
	IF email IS NULL THEN
    	CALL Mensaje("No se pudo registrar el docente, no ingresó correo", 0);
		LEAVE proc_registrarDocente;
	ELSEIF NOT validarEmail(email) THEN
		CALL Mensaje(CONCAT("No se pudo registrar el docente, email no válido: ", email), 0);
		LEAVE proc_registrarDocente;
	ELSEIF reg_siif IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó el SIIF", 0);
		LEAVE proc_registrarDocente;
	ELSEIF (SELECT SIIF FROM docentes WHERE SIIF = reg_siif) THEN
		CALL Mensaje(CONCAT("No se pudo registrar el docente: ", reg_siif, " - ", nombre, " ", apellido, ", ya existe"), 0);
		LEAVE proc_registrarDocente;
	ELSEIF nombre IS NULL THEN 
		CALL Mensaje("No se pudo registrar el docente, no ingresó nombres", 0);
		LEAVE proc_registrarDocente;
	ELSEIF apellido IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó apellido", 0);
		LEAVE proc_registrarDocente;
	ELSEIF fecha_nac IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó fecha de nacimiento", 0);
		LEAVE proc_registrarDocente;  
	ELSEIF tel IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó telefono", 0);
		LEAVE proc_registrarDocente;
	ELSEIF dir IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó dirección", 0);
		LEAVE proc_registrarDocente;
	ELSEIF num_dpi IS NULL THEN
		CALL Mensaje("No se pudo registrar el docente, no ingresó DPI", 0);
		LEAVE proc_registrarDocente;
    END IF;
    
    INSERT INTO docentes(SIIF,DPI,Nombres,Apellidos,Fecha_Nacimiento,Correo,Telefono,Direccion,Fecha_Creacion)
	VALUES(reg_siif,num_dpi,nombre,apellido,STR_TO_DATE(fecha_nac, '%d-%m-%Y'),email,tel,dir,CURDATE());
    CALL Mensaje(CONCAT("Se registró el docente: ", nombre, " ", apellido), 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS crearCurso;
DELIMITER $$
CREATE PROCEDURE crearCurso(
IN codigo VARCHAR(50),
IN nombre VARCHAR(50),
IN creditosN VARCHAR(10),
IN creditosO VARCHAR(50),
IN carrera VARCHAR(15),
IN obligatorio CHAR(1)
)
proc_crearCurso:BEGIN
	IF codigo IS NULL THEN
    	CALL Mensaje("No se pudo crear el curso, no ingresó código", 0);
		LEAVE proc_crearCurso;
	ELSEIF existeCurso(codigo) THEN
		CALL Mensaje(CONCAT("No se pudo crear el curso: ", codigo, " - ", nombre, ", ya existe"), 0);
		LEAVE proc_crearCurso;
	ELSEIF nombre IS NULL THEN 
		CALL Mensaje("No se pudo crear el curso, no ingresó nombre", 0);
		LEAVE proc_crearCurso;
	ELSEIF creditosN IS NULL THEN
		CALL Mensaje("No se pudo crear el curso, no ingresó créditos que necesita", 0);
		LEAVE proc_crearCurso;
	ELSEIF NOT soloEnteros(creditosN) THEN
		CALL Mensaje("No se pudo crear el curso, 'Créditos necesarios' no es entero positivo o 0", 0);
		LEAVE proc_crearCurso;
	ELSEIF creditosO IS NULL THEN
		CALL Mensaje("No se pudo crear el curso, no ingresó créditos que otorga", 0);
		LEAVE proc_crearCurso;  
	ELSEIF NOT soloEnterosPos(creditosO) THEN
		CALL Mensaje("No se pudo crear el curso, 'Créditos que otorga' no es entero positivo", 0);
		LEAVE proc_crearCurso;
	ELSEIF carrera IS NULL THEN
		CALL Mensaje("No se pudo crear el curso, no ingresó ID de carrera", 0);
		LEAVE proc_crearCurso;
	ELSEIF obligatorio IS NULL THEN
		CALL Mensaje("No se pudo crear el curso, no ingresó si es obligatorio", 0);
		LEAVE proc_crearCurso;
    END IF;
    
    -- Comprueba si el curso ya existe
    IF (SELECT Curso_Codigo FROM cursos_pensums WHERE Curso_Codigo = codigo) THEN
        INSERT INTO cursos_pensums(Obligatorio, Creditos_Necesarios, Carrera_ID, Curso_Codigo)
		VALUES(obligatorio,creditosN,carrera,codigo);
    ELSE 
		INSERT INTO cursos(Codigo, Nombre, Creditos_Otorgados) VALUES(codigo,nombre,creditosO);
        INSERT INTO cursos_pensums(Obligatorio, Creditos_Necesarios, Carrera_ID, Curso_Codigo)
		VALUES(obligatorio,creditosN,carrera,codigo);
    END IF;
    CALL Mensaje(CONCAT("Se creó el curso: ", codigo, " - " , nombre), 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS habilitarCurso;
DELIMITER $$
CREATE PROCEDURE habilitarCurso(
IN cod VARCHAR(50),
IN cicle CHAR(2),
IN docente VARCHAR(10),
IN cupo_max VARCHAR(50),
IN secc CHAR(1)
)
proc_habilitarCurso:BEGIN
	IF secc IS NULL THEN
		CALL Mensaje("No se pudo habilitar el curso, no ingresó sección", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF cod IS NULL THEN
    	CALL Mensaje("No se pudo habilitar el curso, no ingresó código", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF NOT existeCurso(cod) THEN
		CALL Mensaje(CONCAT("No se pudo habilitar el curso: ", cod, ", no existe"), 0);
		LEAVE proc_habilitarCurso;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No se pudo habilitar el curso, no ingresó ciclo", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("No se pudo habilitar el curso, ciclo no válido", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF docente IS NULL THEN
		CALL Mensaje("No se pudo habilitar el curso, no ingresó docente", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF NOT existeDocente(docente) THEN
		CALL Mensaje("No se pudo habilitar el curso, no existe el docente", 0);
		LEAVE proc_habilitarCurso;
	ELSEIF cupo_max IS NULL THEN
		CALL Mensaje("No se pudo habilitar el curso, no ingresó el cupo máximo", 0);
		LEAVE proc_habilitarCurso;  
	ELSEIF NOT soloEnterosPos(cupo_max) THEN
		CALL Mensaje("No se pudo habilitar el curso, 'Cupo máximo' no es entero positivo", 0);
		LEAVE proc_habilitarCurso;
    END IF;
    
    SET secc = UPPER(secc);
    -- Verifica que no se repita la seccion de un curso en el mismo ciclo y año
    IF (SELECT Curso_Codigo FROM cursos_habilitados WHERE Curso_Codigo = cod AND Seccion = secc AND Ciclo = cicle AND Año = YEAR(CURDATE())) THEN
		CALL Mensaje(CONCAT("No se pudo habilitar el curso: ", cod, ", la sección ya existe para el ciclo y año actual"), 0);
        LEAVE proc_habilitarCurso;
    END IF;
    INSERT INTO cursos_habilitados(Ciclo, Cupo, Asignados, Seccion, Año, Curso_Codigo, Docente_SIIF)
	VALUES (cicle,cupo_max,0,secc,YEAR(CURDATE()),cod,docente);
	CALL Mensaje(CONCAT("Se habilitó el curso: ", cod), 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS agregarHorario;
DELIMITER $$
CREATE PROCEDURE agregarHorario(
IN id_curso VARCHAR(10),
IN dia CHAR(2),
IN hora VARCHAR(12)
)
proc_agregarHorario:BEGIN
	IF id_curso IS NULL THEN
    	CALL Mensaje("No se pudo agregar el horario, no ingresó id de curso habilitado", 0);
		LEAVE proc_agregarHorario;
	ELSEIF NOT existeCursoH(id_curso) THEN
		CALL Mensaje(CONCAT("No se pudo agregar el horario no existe el id ", id_curso), 0);
		LEAVE proc_agregarHorario;
	ELSEIF dia IS NULL THEN
		CALL Mensaje("No se pudo agregar el horario, no ingresó día", 0);
		LEAVE proc_agregarHorario;
	ELSEIF NOT (dia = 1 OR dia = 2 OR dia = 3 OR dia = 4 OR dia = 5 OR dia = 6 OR dia = 7) THEN
		CALL Mensaje("No se pudo agregar el horario, el día debe ser entre 1 a 7 ", 0);
		LEAVE proc_agregarHorario;
	ELSEIF hora IS NULL THEN
		CALL Mensaje("No se pudo agregar el horario, no ingresó el horario", 0);
		LEAVE proc_agregarHorario;  
    END IF;

    INSERT INTO horarios(Dia, Horario, Curso_Habilitado_ID)
	VALUES (dia,hora,id_curso);
	CALL Mensaje("Se agregó el horario" , 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS asignarCurso;
DELIMITER $$
CREATE PROCEDURE asignarCurso(
IN cod_curso VARCHAR(10),
IN cicle CHAR(2),
IN secc CHAR(1),
IN carne VARCHAR(15)
)
proc_asignarCurso:BEGIN
	DECLARE id_habilitado INT;
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No se pudo asignar al curso, no ingresó código del curso", 0);
		LEAVE proc_asignarCurso;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", no existe"), 0);
		LEAVE proc_asignarCurso;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No se pudo asignar al curso, no ingresó ciclo", 0);
		LEAVE proc_asignarCurso;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("No se pudo asignar al curso, ciclo no válido", 0);
		LEAVE proc_asignarCurso;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No se pudo asignar al curso, no ingresó sección", 0);
		LEAVE proc_asignarCurso;
	ELSEIF carne IS NULL THEN
		CALL Mensaje("No se pudo asignar al curso, no ingresó carnet", 0);
		LEAVE proc_asignarCurso;
	ELSEIF NOT existeCarnet(carne) THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", no existe el estudiante"), 0);
        LEAVE proc_asignarCurso;
    END IF;
    
	SET secc = UPPER(secc);
	
	-- Validaciones
	SELECT ID INTO id_habilitado FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = YEAR(CURDATE());
	IF id_habilitado IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", no existe el curso habilitado"), 0);
		LEAVE proc_asignarCurso;
	ELSEIF NOT esDeMiCarrera(carne, cod_curso) THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", no pertenece a la carrera"), 0);
		LEAVE proc_asignarCurso;
	ELSEIF (SELECT Cupo FROM cursos_habilitados WHERE ID = id_habilitado) = obtenerAsignados(id_habilitado) THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", no hay cupo disponible"), 0);
		LEAVE proc_asignarCurso;
	ELSEIF (SELECT CH.ID FROM asignaciones A
			INNER JOIN cursos_habilitados CH
			ON A.Curso_Habilitado_ID = CH.ID
			WHERE A.Estudiante_Carnet = carne AND CH.Ciclo = cicle AND CH.AÑO = YEAR(CURDATE()) AND CH.Curso_Codigo = cod_curso)
		THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", el estudiante ya se asignó a una sección"), 0);
		LEAVE proc_asignarCurso;
	ELSEIF (select ((SELECT Creditos_Necesarios FROM cursos_pensums WHERE Curso_Codigo = cod_curso) > (SELECT Creditos FROM estudiantes WHERE Carnet = carne))) THEN
		CALL Mensaje(CONCAT("No se pudo asignar al curso: ", cod_curso, ", el estudiante no tiene los créditos necesarios"), 0);
		LEAVE proc_asignarCurso;
	END IF;
    
	INSERT INTO asignaciones(Estudiante_Carnet, Curso_Habilitado_ID)
	VALUES (carne,id_habilitado);
	UPDATE cursos_habilitados SET Asignados = Asignados + 1 WHERE ID = id_habilitado;
	CALL Mensaje("Se asignó el curso", 1);
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS desasignarCurso;
DELIMITER $$
CREATE PROCEDURE desasignarCurso(
IN cod_curso VARCHAR(10),
IN cicle CHAR(2),
IN secc CHAR(1),
IN carne VARCHAR(15)
)
proc_desasignarCurso:BEGIN
	DECLARE id_habilitado INT;
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No se pudo desasignar del curso, no ingresó código del curso", 0);
		LEAVE proc_desasignarCurso;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje(CONCAT("No se pudo desasignar del curso: ", cod_curso, ", no existe"), 0);
		LEAVE proc_desasignarCurso;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No se pudo desasignar del curso, no ingresó ciclo", 0);
		LEAVE proc_desasignarCurso;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("No se pudo desasignar del curso, ciclo no válido", 0);
		LEAVE proc_desasignarCurso;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No se pudo desasignar del curso, no ingresó sección", 0);
		LEAVE proc_desasignarCurso;
	ELSEIF carne IS NULL THEN
		CALL Mensaje("No se pudo desasignar del curso, no ingresó carnet", 0);
		LEAVE proc_desasignarCurso;
	ELSEIF NOT existeCarnet(carne) THEN
		CALL Mensaje(CONCAT("No se pudo desasignar del curso: ", cod_curso, ", no existe el estudiante"), 0);
        LEAVE proc_desasignarCurso;
    END IF;
    
	SET secc = UPPER(secc);
	
	-- Validaciones
	SELECT ID INTO id_habilitado FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = YEAR(CURDATE());
	IF id_habilitado IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo desasignar del curso: ", cod_curso, ", no existe el curso habilitado"), 0);
		LEAVE proc_desasignarCurso;
	ELSEIF (SELECT Estudiante_Carnet FROM asignaciones WHERE Estudiante_Carnet = carne AND Curso_Habilitado_ID = id_habilitado) IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo desasignar del curso: ", cod_curso, ", el estudiante no se asignó a este curso habilitado"), 0);
		LEAVE proc_desasignarCurso;
	ELSE
		INSERT INTO desasignaciones(Estudiante_Carnet, Curso_Habilitado_ID)
		VALUES (carne,id_habilitado);
		UPDATE cursos_habilitados SET Asignados = Asignados - 1 WHERE ID = id_habilitado;
		CALL Mensaje("Se desasignó el curso", 1);
	END IF;
    
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ingresarNota;
DELIMITER $$
CREATE PROCEDURE ingresarNota(
IN cod_curso VARCHAR(10),
IN cicle CHAR(2),
IN secc CHAR(1),
IN carne VARCHAR(15),
IN nota VARCHAR(10)
)
proc_ingresarNota:BEGIN
	DECLARE id_habilitado INT;
	DECLARE creds TINYINT;
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No se pudo ingresar la nota, no ingresó código del curso", 0);
		LEAVE proc_ingresarNota;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No se pudo ingresar la nota, no ingresó ciclo", 0);
		LEAVE proc_ingresarNota;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("No se pudo ingresar la nota, ciclo no válido", 0);
		LEAVE proc_ingresarNota;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No se pudo ingresar la nota, no ingresó sección", 0);
		LEAVE proc_ingresarNota;
	ELSEIF carne IS NULL THEN
		CALL Mensaje("No se pudo ingresar la nota, no ingresó carnet", 0);
		LEAVE proc_ingresarNota;
	ELSEIF NOT existeCarnet(carne) THEN
		CALL Mensaje(CONCAT("No se pudo ingresar la nota, no existe el estudiante"), 0);
        LEAVE proc_ingresarNota;
	ELSEIF nota IS NULL THEN
		CALL Mensaje("No se pudo ingresar la nota, no ingresó carnet", 0);
		LEAVE proc_ingresarNota;
	ELSEIF NOT soloNumerosPos(nota) THEN
		CALL Mensaje(CONCAT("No se pudo ingresar la nota, la nota debe ser un número positivo"), 0);
        LEAVE proc_ingresarNota;
    END IF;
    
	SET secc = UPPER(secc);
	
	-- Validaciones
	SELECT ID INTO id_habilitado FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = YEAR(CURDATE());
	IF id_habilitado IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo ingresar la nota , no existe el curso habilitado"), 0);
		LEAVE proc_ingresarNota;
	ELSEIF (SELECT Estudiante_Carnet FROM asignaciones WHERE Estudiante_Carnet = carne AND Curso_Habilitado_ID = id_habilitado) IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo ingresar la nota, el estudiante no se asignó a este curso"), 0);
		LEAVE proc_ingresarNota;
	ELSEIF (SELECT Estudiante_Carnet FROM desasignaciones WHERE Estudiante_Carnet = carne AND Curso_Habilitado_ID = id_habilitado) THEN
		CALL Mensaje(CONCAT("No se pudo ingresar la nota, el estudiante se desasignó de este curso"), 0);
		LEAVE proc_ingresarNota;
	ELSE
		INSERT INTO notas(Estudiante_Carnet, Curso_Habilitado_ID, Nota)
		VALUES (carne,id_habilitado,ROUND(nota, 0));
		IF ROUND(nota, 0) >= 61 THEN
			SELECT Creditos_Otorgados INTO creds FROM cursos WHERE Codigo = cod_curso;
			UPDATE estudiantes SET Creditos = Creditos + creds WHERE Carnet = carne;
		END IF;
		CALL Mensaje("Se ingresó la nota", 1);
	END IF;
    
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS generarActa;
DELIMITER $$
CREATE PROCEDURE generarActa(
IN cod_curso VARCHAR(10),
IN cicle CHAR(2),
IN secc CHAR(1)
)
proc_generarActa:BEGIN
	DECLARE id_habilitado INT;
	DECLARE creds TINYINT;
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No se pudo generar el acta, no ingresó código del curso", 0);
		LEAVE proc_generarActa;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No se pudo generar el acta, no ingresó ciclo", 0);
		LEAVE proc_generarActa;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("No se pudo generar el acta, ciclo no válido", 0);
		LEAVE proc_generarActa;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No se pudo generar el acta, no ingresó sección", 0);
		LEAVE proc_generarActa;
    END IF;
    
	SET secc = UPPER(secc);
	
	-- Validaciones
	SELECT ID INTO id_habilitado FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = YEAR(CURDATE());
	IF id_habilitado IS NULL THEN
		CALL Mensaje(CONCAT("No se pudo generar el acta, no existe el curso habilitado"), 0);
		LEAVE proc_generarActa;
	ELSEIF (SELECT COUNT(Estudiante_Carnet) FROM notas WHERE Curso_Habilitado_ID = id_habilitado) < obtenerAsignados(id_habilitado) THEN
		CALL Mensaje(CONCAT("No se pudo generar el acta, no hay nota de todos los estudiantes asignados"), 0);
		LEAVE proc_generarActa;
    ELSE
		INSERT INTO actas(Curso_Habilitado_ID, Fecha, Hora) VALUES (id_habilitado, CURDATE(), CURTIME());
		CALL Mensaje("Se generó el acta", 1);
	END IF;
    
END;
$$
DELIMITER ;
-- ------------------CONSULTAS------------------

DROP PROCEDURE IF EXISTS consultarPensum;
DELIMITER $$
CREATE PROCEDURE consultarPensum(IN carrera VARCHAR(15))
BEGIN
    SELECT C.Codigo, C.Nombre, IF(CP.Obligatorio, "Sí","No") AS Obligatorio, CP.Creditos_Necesarios AS `Créditos Necesarios`, C.Creditos_Otorgados AS `Créditos Otorgados`
	FROM cursos C
	INNER JOIN cursos_pensums CP
	ON C.Codigo = CP.Curso_Codigo
	INNER JOIN Carreras CA
	ON CP.Carrera_ID = CA.ID
	WHERE Carrera_ID = carrera OR Carrera_ID = 0;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarEstudiante;
DELIMITER $$
CREATE PROCEDURE consultarEstudiante(IN num_carnet VARCHAR(15))
proc_consultarEstudiante:BEGIN
	IF num_carnet IS NULL THEN
		CALL Mensaje("No ingresó carnet", 0);
		LEAVE proc_consultarEstudiante;
	ELSEIF NOT existeCarnet(num_carnet) THEN
		CALL Mensaje(CONCAT("No existe el estudiante"), 0);
        LEAVE proc_consultarEstudiante;
    END IF;
	SELECT E.Carnet, CONCAT(E.Nombres, " ", E.Apellidos) AS `Nombre Completo`, E.Fecha_Nacimiento AS `Fecha de Nacimiento`, E.Correo, E.Telefono, E.Direccion, E.DPI, C.Nombre AS Carrera, E.Creditos
	FROM estudiantes E
	INNER JOIN Carreras C
	ON E.Carrera_ID = C.ID
	WHERE E.Carnet = num_carnet;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarDocente;
DELIMITER $$
CREATE PROCEDURE consultarDocente(IN num_siif VARCHAR(15))
proc_consultarDocente:BEGIN
	IF num_siif IS NULL THEN
		CALL Mensaje("No ingresó SIIF del docente", 0);
		LEAVE proc_consultarDocente;
	ELSEIF NOT existeDocente(num_siif) THEN
		CALL Mensaje("No existe el docente", 0);
		LEAVE proc_consultarDocente;
    END IF;
	SELECT D.SIIF, CONCAT(D.Nombres, " ", D.Apellidos) AS `Nombre Completo`, D.Fecha_Nacimiento AS `Fecha de Nacimiento`, D.Correo, D.Telefono, D.Direccion, D.DPI
	FROM docentes D
	WHERE D.SIIF = num_siif;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarAsignados;
DELIMITER $$
CREATE PROCEDURE consultarAsignados(
IN cod_curso VARCHAR(15), 
IN cicle CHAR(2), 
IN año VARCHAR(4), 
IN secc CHAR(1)
)
proc_consultarAsignados:BEGIN
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No ingresó código del curso", 0);
		LEAVE proc_consultarAsignados;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje("No existe el curso", 0);
		LEAVE proc_consultarAsignados;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No ingresó ciclo", 0);
		LEAVE proc_consultarAsignados;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("Ciclo no válido", 0);
		LEAVE proc_consultarAsignados;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No ingresó sección", 0);
		LEAVE proc_consultarAsignados;
	ELSEIF año IS NULL THEN
		CALL Mensaje("No ingresó año", 0);
		LEAVE proc_consultarAsignados;
    END IF;

	
	IF (SELECT ID FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = año) IS NULL THEN
		CALL Mensaje(CONCAT("No existe el curso habilitado"), 0);
		LEAVE proc_consultarAsignados;
	END IF;
    
	SELECT Carnet, CONCAT(Nombres, " ", Apellidos) AS `Nombre Completo`, Creditos 
	FROM estudiantes E
	INNER JOIN asignaciones A
	ON E.Carnet = A.Estudiante_Carnet
	INNER JOIN cursos_habilitados CH
	ON A.Curso_Habilitado_ID = CH.ID
	WHERE CH.Curso_Codigo = cod_curso AND CH.Ciclo = cicle AND CH.Año = año AND CH.Seccion = secc;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS consultarAprobacion;
DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
IN cod_curso VARCHAR(15), 
IN cicle CHAR(2), 
IN año VARCHAR(4), 
IN secc CHAR(1)
)
proc_consultarAprobacion:BEGIN
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No ingresó código del curso", 0);
		LEAVE proc_consultarAprobacion;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje("No existe el curso", 0);
		LEAVE proc_consultarAprobacion;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No ingresó ciclo", 0);
		LEAVE proc_consultarAprobacion;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("Ciclo no válido", 0);
		LEAVE proc_consultarAprobacion;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No ingresó sección", 0);
		LEAVE proc_consultarAprobacion;
	ELSEIF año IS NULL THEN
		CALL Mensaje("No ingresó año", 0);
		LEAVE proc_consultarAprobacion;
    END IF;

	IF (SELECT ID FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = año) IS NULL THEN
		CALL Mensaje(CONCAT("No existe el curso habilitado"), 0);
		LEAVE proc_consultarAprobacion;
	END IF;
    
	SELECT Curso_Codigo AS `Código Curso`, Carnet, CONCAT(Nombres, " ", Apellidos) AS `Nombre Completo`, IF(Nota >= 61, "Aprobado", "Reprobado") AS Aprobacion
	FROM estudiantes E
	INNER JOIN Notas N
	ON E.Carnet = N.Estudiante_Carnet
	INNER JOIN cursos_habilitados CH
	ON N.Curso_Habilitado_ID = CH.ID
	WHERE CH.Curso_Codigo = cod_curso AND CH.Ciclo = cicle AND CH.Año = año AND CH.Seccion = secc;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS consultarActas;
DELIMITER $$
CREATE PROCEDURE consultarActas(IN cod_curso VARCHAR(15))
proc_consultarActas:BEGIN
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No ingresó código del curso", 0);
		LEAVE proc_consultarActas;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje("No existe el curso", 0);
		LEAVE proc_consultarActas;	
    END IF;
    
	SELECT Curso_Codigo AS `Código Curso`, Seccion, CASE
        							WHEN Ciclo = "1S" THEN 'Primer Semestre'
        							WHEN Ciclo = "2S" THEN 'Segundo Semestre'
									WHEN Ciclo = "VJ" THEN 'Vacaciones de Julio'
									WHEN Ciclo = "VD" THEN 'Vacaciones de Diciembre'
								  END AS Ciclo,
	Año, Asignados AS `Cantidad de estudiantes que llevaron el curso`, Fecha, Hora
	FROM Actas A
	INNER JOIN cursos_habilitados CH
	ON A.Curso_Habilitado_ID = CH.ID
	INNER JOIN cursos C
	ON CH.Curso_Codigo = C.Codigo
	WHERE CH.Curso_Codigo = cod_curso
	ORDER BY Fecha DESC, Hora DESC;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS consultarDesasignacion;
DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(
IN cod_curso VARCHAR(15), 
IN cicle CHAR(2), 
IN año VARCHAR(4), 
IN secc CHAR(1)
)
proc_consultarDesasignacion:BEGIN
	IF cod_curso IS NULL THEN
    	CALL Mensaje("No ingresó código del curso", 0);
		LEAVE proc_consultarDesasignacion;
	ELSEIF NOT existeCurso(cod_curso) THEN
		CALL Mensaje("No existe el curso", 0);
		LEAVE proc_consultarDesasignacion;
	ELSEIF cicle IS NULL THEN
		CALL Mensaje("No ingresó ciclo", 0);
		LEAVE proc_consultarDesasignacion;
	ELSEIF NOT validarCiclo(cicle) THEN
		CALL Mensaje("Ciclo no válido", 0);
		LEAVE proc_consultarDesasignacion;
	ELSEIF secc IS NULL THEN
		CALL Mensaje("No ingresó sección", 0);
		LEAVE proc_consultarDesasignacion;
	ELSEIF año IS NULL THEN
		CALL Mensaje("No ingresó año", 0);
		LEAVE proc_consultarDesasignacion;
    END IF;

	
	IF (SELECT ID FROM cursos_habilitados WHERE Curso_Codigo = cod_curso AND Ciclo = cicle AND Seccion = secc AND Año = año) IS NULL THEN
		CALL Mensaje(CONCAT("No existe el curso habilitado"), 0);
		LEAVE proc_consultarDesasignacion;
	END IF;
    
	SELECT  Curso_Codigo AS `Código Curso`, Seccion, CASE
        							WHEN Ciclo = "1S" THEN 'Primer Semestre'
        							WHEN Ciclo = "2S" THEN 'Segundo Semestre'
									WHEN Ciclo = "VJ" THEN 'Vacaciones de Julio'
									WHEN Ciclo = "VD" THEN 'Vacaciones de Diciembre'
								  END AS Ciclo,
	Año, Asignados AS `Cantidad de estudiantes que llevaron el curso`, 
	COUNT(Curso_Codigo) AS `Cantidad de estudiantes que se desasignaron`, 
	CONCAT(COUNT(Curso_Codigo)/(COUNT(Curso_Codigo) + Asignados)*100,"%")
	AS `Porcentaje de desasignación`
	FROM estudiantes E
	INNER JOIN desasignaciones D
	ON E.Carnet = D.Estudiante_Carnet
	INNER JOIN cursos_habilitados CH
	ON D.Curso_Habilitado_ID = CH.ID
	WHERE CH.Curso_Codigo = cod_curso AND CH.Ciclo = cicle AND CH.Año = año AND CH.Seccion = secc
	GROUP BY Curso_Codigo;
END;
$$
DELIMITER ;