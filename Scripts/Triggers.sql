DROP TRIGGER IF EXISTS insert_estudiante;
DELIMITER $$
CREATE TRIGGER insert_estudiante
AFTER INSERT ON estudiantes
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "estudiantes"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS update_estudiante;
DELIMITER $$
CREATE TRIGGER update_estudiante
AFTER UPDATE ON estudiantes
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "estudiantes"', "UPDATE");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_docente;
DELIMITER $$
CREATE TRIGGER insert_docente
AFTER INSERT ON docentes
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "docentes"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_carrera;
DELIMITER $$
CREATE TRIGGER insert_carrera
AFTER INSERT ON carreras
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "carreras"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS update_carrera;
DELIMITER $$
CREATE TRIGGER update_carrera
AFTER UPDATE ON carreras
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "carreras"', "UPDATE");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_acta;
DELIMITER $$
CREATE TRIGGER insert_acta
AFTER INSERT ON actas
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "actas"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_asignacion;
DELIMITER $$
CREATE TRIGGER insert_asignacion
AFTER INSERT ON asignaciones
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "asignaciones"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_curso;
DELIMITER $$
CREATE TRIGGER insert_curso
AFTER INSERT ON cursos
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "cursos"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cursosH;
DELIMITER $$
CREATE TRIGGER insert_cursosH
AFTER INSERT ON cursos_habilitados
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "cursos_habilitados"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS update_cursosH;
DELIMITER $$
CREATE TRIGGER update_cursosH
AFTER UPDATE ON cursos_habilitados
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "cursos_habilitados"', "UPDATE");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cursosP;
DELIMITER $$
CREATE TRIGGER insert_cursosP
AFTER INSERT ON cursos_pensums
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "cursos_pensums"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_desasignacion;
DELIMITER $$
CREATE TRIGGER insert_desasignacion
AFTER INSERT ON desasignaciones
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "desasignaciones"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_horario;
DELIMITER $$
CREATE TRIGGER insert_horario
AFTER INSERT ON horarios
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "horarios"', "INSERT");
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_nota;
DELIMITER $$
CREATE TRIGGER insert_nota
AFTER INSERT ON notas
FOR EACH ROW BEGIN
	INSERT INTO transacciones
	(Fecha,Descripcion,Tipo) VALUES
	(SYSDATE(), 'Se ha realizado una acción en la tabla "notas"', "INSERT");
END;
$$
DELIMITER ;