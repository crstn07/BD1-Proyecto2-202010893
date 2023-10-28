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