USE bd1_proyecto2;

-- Valida que contenga solo letras
DELIMITER $$
CREATE FUNCTION soloLetras (str TEXT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (str REGEXP '^[a-zA-ZÁÉÍÓÚáéíóú ]*$',true,false);
END$$
DELIMITER ;

-- Valida que contenga solo numeros enteros positivos
DELIMITER $$
CREATE FUNCTION soloEnterosPos(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^[1-9]*$',true,false);
END $$
DELIMITER ;

-- Valida que contenga solo numeros enteros positivos y 0
DELIMITER $$
CREATE FUNCTION soloEnteros(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^[0-9]*$',true,false);
END $$
DELIMITER ;

-- Valida que contenga solo numeros (enteros o decimales) positivos
DELIMITER $$
CREATE FUNCTION soloNumerosPos(num VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF (num REGEXP '^0*[1-9]+(\.[0-9])*$',true,false);
END $$
DELIMITER ;

-- Valida que el formato del correo sea correcto
DELIMITER $$
CREATE FUNCTION validarEmail(email VARCHAR(60))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF 
(email REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$',true,false);
END $$
DELIMITER ;

-- Valida que el ciclo sea correcto
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

-- Valida que el carnet exista
DELIMITER $$
CREATE FUNCTION existeCarnet(id VARCHAR(10))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	DECLARE carne BIGINT;
    SELECT Carnet INTO carne FROM estudiantes WHERE id = Carnet;
    RETURN IF (carne, true, false);
END $$
DELIMITER ;