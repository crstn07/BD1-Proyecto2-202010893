USE bd1_proyecto2;

-- Valida que contenga solo letras
DROP FUNCTION IF EXISTS soloLetras;
DELIMITER $$
CREATE FUNCTION soloLetras (str TEXT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (str REGEXP '^[a-zA-ZÁÉÍÓÚáéíóú ]*$',true,false);
END$$
DELIMITER ;

-- Valida que contenga solo numeros enteros positivos
DROP FUNCTION IF EXISTS soloEnterosPos;
DELIMITER $$
CREATE FUNCTION soloEnterosPos(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^0*[1-9]+[0-9]*$',true,false);
END $$
DELIMITER ;

-- Valida que contenga solo numeros enteros positivos y 0
DROP FUNCTION IF EXISTS soloEnteros;
DELIMITER $$
CREATE FUNCTION soloEnteros(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^[0-9]*$',true,false);
END $$
DELIMITER ;

-- Valida que contenga solo numeros (enteros o decimales) positivos
DROP FUNCTION IF EXISTS soloNumerosPos;
DELIMITER $$
CREATE FUNCTION soloNumerosPos(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^0*[1-9]+[0-9]*\.?([0-9])*$',true,false);
END $$
DELIMITER ;

-- Valida que el formato del correo sea correcto
DROP FUNCTION IF EXISTS validarEmail;
DELIMITER $$
CREATE FUNCTION validarEmail(email VARCHAR(60))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF 
(email REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$',true,false);
END $$
DELIMITER ;

-- Valida que el ciclo sea correcto
DROP FUNCTION IF EXISTS validarCiclo;
DELIMITER $$
CREATE FUNCTION validarCiclo(ciclo VARCHAR(2))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF 

( CAST(ciclo AS BINARY) = '1S'
OR  CAST(ciclo AS BINARY) = '2S'
OR  CAST(ciclo AS BINARY) = 'VD'
OR  CAST(ciclo AS BINARY) = 'VJ', TRUE, FALSE);
END $$
DELIMITER ;

-- Valida que el curso exista
DROP FUNCTION IF EXISTS existeCurso;
DELIMITER $$
CREATE FUNCTION existeCurso(codi VARCHAR(10))
RETURNS BIGINT DETERMINISTIC
BEGIN
	DECLARE cod BIGINT;
    SELECT Codigo INTO cod FROM cursos WHERE Codigo = codi;
    RETURN IF (cod, true, false);
END $$
DELIMITER ;

-- Valida que el estudiante exista
DROP FUNCTION IF EXISTS existeCarnet;
DELIMITER $$
CREATE FUNCTION existeCarnet(id VARCHAR(10))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	DECLARE carne BIGINT;
    SELECT Carnet INTO carne FROM estudiantes WHERE id = Carnet;
    RETURN IF (carne, true, false);
END $$
DELIMITER ;

-- Valida que el docente exista
DROP FUNCTION IF EXISTS existeDocente;
DELIMITER $$
CREATE FUNCTION existeDocente(id VARCHAR(10))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	DECLARE iden BIGINT;
    SELECT SIIF INTO iden FROM docentes WHERE id = SIIF;
    RETURN IF (iden, true, false);
END $$
DELIMITER ;


-- Valida que el exista el curso habilitado
DROP FUNCTION IF EXISTS existeCursoH;
DELIMITER $$
CREATE FUNCTION existeCursoH(iden VARCHAR(10))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	DECLARE id_curso INT;
    SELECT ID INTO id_curso FROM cursos_habilitados WHERE ID = iden;
    RETURN IF (id_curso, true, false);
END $$
DELIMITER ;

-- Obtiene la cantidad de asignados del curso habilitado
DROP FUNCTION IF EXISTS obtenerAsignados;
DELIMITER $$
CREATE FUNCTION obtenerAsignados(iden VARCHAR(10))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE asig INT;
    SELECT Asignados INTO asig FROM cursos_habilitados WHERE ID = iden;
    RETURN asig;
END $$
DELIMITER ;

-- Indica si el curso es de la carrera de un estudiante
DROP FUNCTION IF EXISTS esDeMiCarrera;
DELIMITER $$
CREATE FUNCTION esDeMiCarrera(carne VARCHAR(15), curso VARCHAR(10))
RETURNS BOOL DETERMINISTIC
BEGIN
	DECLARE res BIGINT;
	SELECT E.Carnet INTO res FROM estudiantes E
	INNER JOIN carreras CA
	ON E.Carrera_ID = CA.ID
	INNER JOIN cursos_pensums CP
	ON CA.ID = CP.Carrera_ID OR CP.Carrera_ID = 0
	WHERE E.Carnet = carne AND Curso_Codigo = curso;
    RETURN IF(res, true, false);
END $$
DELIMITER ;