CREATE SCHEMA bd1_proyecto2 DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci;

USE bd1_proyecto2;

CREATE TABLE Transacciones
    (
     ID INTEGER NOT NULL AUTO_INCREMENT ,
     Fecha DATETIME NOT NULL , 
     Descripcion TEXT NOT NULL ,
     Tipo VARCHAR (6) NOT  NULL ,
     PRIMARY KEY (ID)
    )
;

CREATE TABLE Actas 
    (
     Fecha DATE NOT NULL , 
     Hora TIME NOT NULL , 
     Curso_Habilitado_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Actas ADD CONSTRAINT Acta_PK PRIMARY KEY (Curso_Habilitado_ID)
;

CREATE TABLE Asignaciones 
    (
     Estudiante_Carnet BIGINT NOT NULL , 
     Curso_Habilitado_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Asignaciones ADD CONSTRAINT Asignacion_PK PRIMARY KEY (Estudiante_Carnet, 
    Curso_Habilitado_ID)
;

CREATE TABLE Carreras 
    (
     ID INTEGER NOT NULL AUTO_INCREMENT , 
     Nombre VARCHAR (30) NOT NULL, 
	 PRIMARY KEY (ID)
    )
;

CREATE TABLE Cursos 
    (
     Codigo SMALLINT NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     Creditos_Otorgados SMALLINT NOT NULL 
    )
;

ALTER TABLE Cursos ADD CONSTRAINT Curso_PK PRIMARY KEY (Codigo)
;

CREATE TABLE Cursos_Habilitados 
    (
     ID INTEGER NOT NULL AUTO_INCREMENT , 
     Ciclo VARCHAR (2) NOT NULL , 
     Cupo INTEGER NOT NULL , 
     Asignados INTEGER NOT NULL , 
     Seccion CHAR (1) NOT NULL , 
     Año SMALLINT NOT NULL , 
     Curso_Codigo SMALLINT , 
     Docente_SIIF BIGINT NOT NULL ,
     PRIMARY KEY (ID)
    )
;

CREATE TABLE Cursos_Pensums 
    (
     Obligatorio CHAR (1) NOT NULL , 
     Creditos_Necesarios SMALLINT NOT NULL , 
     Carrera_ID INTEGER NOT NULL , 
     Curso_Codigo SMALLINT NOT NULL 
    )
;

ALTER TABLE Cursos_Pensums ADD CONSTRAINT Curso_Pensum_PK PRIMARY KEY (Carrera_ID, 
    Curso_Codigo)
;

CREATE TABLE Desasignaciones 
    (
     Estudiante_Carnet BIGINT NOT NULL , 
     Curso_Habilitado_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Desasignaciones ADD CONSTRAINT Desasignacion_PK PRIMARY KEY (Estudiante_Carnet, 
    Curso_Habilitado_ID)
;

CREATE TABLE Docentes 
    (
     SIIF BIGINT NOT NULL , 
     DPI BIGINT NOT NULL , 
     Nombres VARCHAR (50) NOT NULL , 
     Apellidos VARCHAR (50) NOT NULL , 
     Fecha_Nacimiento DATE NOT NULL , 
     Correo VARCHAR (50) NOT NULL , 
     Telefono INTEGER NOT NULL , 
     Direccion VARCHAR (100) NOT NULL , 
     Fecha_Creacion DATE NOT NULL 
    )
;

ALTER TABLE Docentes ADD CONSTRAINT Docente_PK PRIMARY KEY (SIIF)
;

ALTER TABLE Docentes ADD CONSTRAINT Docente_DPI_UN UNIQUE (DPI)
;

CREATE TABLE Estudiantes 
    (
     Carnet BIGINT NOT NULL , 
     DPI BIGINT NOT NULL , 
     Nombres VARCHAR (50) NOT NULL , 
     Apellidos VARCHAR (50) NOT NULL , 
     Fecha_Nacimiento DATE NOT NULL , 
     Correo VARCHAR (50) NOT NULL , 
     Telefono INTEGER NOT NULL , 
     Direccion VARCHAR (100) NOT NULL , 
     Creditos SMALLINT NOT NULL , 
     Fecha_Creacion DATE NOT NULL , 
     Carrera_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Estudiantes ADD CONSTRAINT Estudiante_PK PRIMARY KEY (Carnet)
;

ALTER TABLE Estudiantes ADD CONSTRAINT Estudiante_DPI_UN UNIQUE (DPI)
;

CREATE TABLE Horarios 
    (
     Dia TINYINT NOT NULL , 
     Horario VARCHAR (11) NOT NULL , 
     Curso_Habilitado_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Horarios ADD CONSTRAINT Horarios_PK PRIMARY KEY (Curso_Habilitado_ID, 
    Horario, 
    Dia)
;

CREATE TABLE Notas 
    (
     Nota SMALLINT NOT NULL , 
     Estudiante_Carnet BIGINT NOT NULL , 
     Curso_Habilitado_ID INTEGER NOT NULL 
    )
;

ALTER TABLE Notas ADD CONSTRAINT Nota_PK PRIMARY KEY (Estudiante_Carnet, 
    Curso_Habilitado_ID)
;

ALTER TABLE Actas 
    ADD CONSTRAINT Acta_Curso_Habilitado_FK FOREIGN KEY
    ( 
     Curso_Habilitado_ID
    ) 
    REFERENCES Cursos_Habilitados 
    ( 
     ID
    )
;

ALTER TABLE Asignaciones 
    ADD CONSTRAINT Asignacion_Curso_Habilitado_FK FOREIGN KEY
    ( 
     Curso_Habilitado_ID
    ) 
    REFERENCES Cursos_Habilitados 
    ( 
     ID
    )
;

ALTER TABLE Asignaciones 
    ADD CONSTRAINT Asignacion_Estudiante_FK FOREIGN KEY
    ( 
     Estudiante_Carnet
    ) 
    REFERENCES Estudiantes 
    ( 
     Carnet
    )
;

ALTER TABLE Cursos_Habilitados 
    ADD CONSTRAINT Curso_Habilitado_Curso_FK FOREIGN KEY
    ( 
     Curso_Codigo
    ) 
    REFERENCES Cursos 
    ( 
     Codigo
    )
;

ALTER TABLE Cursos_Habilitados 
    ADD CONSTRAINT Curso_Habilitado_Docente_FK FOREIGN KEY
    ( 
     Docente_SIIF
    ) 
    REFERENCES Docentes 
    ( 
     SIIF
    )
;

ALTER TABLE Cursos_Pensums 
    ADD CONSTRAINT Curso_Pensum_Carrera_FK FOREIGN KEY
    ( 
     Carrera_ID
    ) 
    REFERENCES Carreras 
    ( 
     ID
    )
;

ALTER TABLE Cursos_Pensums 
    ADD CONSTRAINT Curso_Pensum_Curso_FK FOREIGN KEY
    ( 
     Curso_Codigo
    ) 
    REFERENCES Cursos 
    ( 
     Codigo
    )
;

ALTER TABLE Desasignaciones 
    ADD CONSTRAINT Desasignacion_Curso_Habilitado_FK FOREIGN KEY
    ( 
     Curso_Habilitado_ID
    ) 
    REFERENCES Cursos_Habilitados 
    ( 
     ID
    )
;

ALTER TABLE Desasignaciones 
    ADD CONSTRAINT Desasignacion_Estudiante_FK FOREIGN KEY
    ( 
     Estudiante_Carnet
    ) 
    REFERENCES Estudiantes 
    ( 
     Carnet
    )
;

ALTER TABLE Estudiantes 
    ADD CONSTRAINT Estudiante_Carrera_FK FOREIGN KEY
    ( 
     Carrera_ID
    ) 
    REFERENCES Carreras 
    ( 
     ID
    )
;

ALTER TABLE Horarios 
    ADD CONSTRAINT Horarios_Curso_Habilitado_FK FOREIGN KEY
    ( 
     Curso_Habilitado_ID
    ) 
    REFERENCES Cursos_Habilitados 
    ( 
     ID
    )
;

ALTER TABLE Notas 
    ADD CONSTRAINT Nota_Curso_Habilitado_FK FOREIGN KEY
    ( 
     Curso_Habilitado_ID
    ) 
    REFERENCES Cursos_Habilitados 
    ( 
     ID
    )
;

ALTER TABLE Notas 
    ADD CONSTRAINT Nota_Estudiante_FK FOREIGN KEY
    ( 
     Estudiante_Carnet
    ) 
    REFERENCES Estudiantes 
    ( 
     Carnet
    )
;
