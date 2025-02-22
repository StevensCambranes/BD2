CREATE DATABASE Museo;
USE Museo;

-- creacion de tabals

CREATE TABLE Guia (
	idGuia INT PRIMARY KEY,
	nombre NVARCHAR (30) NOT NULL,
	apellido NVARCHAR (50) NOT NULL,
	edad INT NOT NULL,
	sexo CHAR (1) NOT NULL, -- F o M
	añosExperiencia INT NOT NULL,
	idiomaNatal NVARCHAR (20),
	idiomaAprendido NVARCHAR (20)
);

CREATE TABLE Grupo (
	idGrupo INT PRIMARY KEY,
	maxPersonas INT NOT NULL,
	cantidadAdultos INT NULL,
	cantidadNiños INT NULL,
	cantidadExtranjeros INT NULL,
	cantidadPersonas INT NULL
);

CREATE TABLE Exhibicion (
	idExhibicion INT PRIMARY KEY,
	fechaInicio DATE NOT NULL,
	fechaFin DATE NOT NULL,
	horario TIME NOT NULL,
	ubiInicial NVARCHAR (20) NOT NULL,
	ubiFinal NVARCHAR (20) NOT NULL,
	fkGuia INT NOT NULL FOREIGN KEY REFERENCES Guia(idGuia),
	fkGrupo INT NOT NULL FOREIGN KEY REFERENCES Grupo(idGrupo)
);

CREATE TABLE Piezas_Arqueologicas (
	idPieArq INT PRIMARY KEY,
	nombre NVARCHAR (50) NOT NULL,
	material NVARCHAR (20) NOT NULL,
	descubridor NVARCHAR (100) NOT NULL,
	fechaDescubrimiento DATE NOT NULL,
	lugarDescubrimiento NVARCHAR (100) NOT NULL,
	estado INT NOT NULL, -- 1 Excelente, 2 Restaurados, 3 Dañadas, 4 Mantenimiento
	fkExhibicion INT NOT NULL FOREIGN KEY REFERENCES Exhibicion (idExhibicion)
);

CREATE TABLE Pinturas_Arqueologicas (
	idPinArq INT PRIMARY KEY,
	nombre NVARCHAR (50) NOT NULL,
	autor NVARCHAR (30) NOT NULL,
	tipoTecnica NVARCHAR (30) NOT NULL,
	fechaDescubrimiento DATE NOT NULL,
	lugarDescubrimiento NVARCHAR (100) NOT NULL,
	estado INT NOT NULL, -- 1 Excelente, 2 Restaurados, 3 Dañadas, 4 Mantenimiento
	fkExhibicion INT NOT NULL FOREIGN KEY REFERENCES Exhibicion (idExhibicion)
);

-- Procedimiento para ingresar datos a la tabla Grupo
GO
CREATE PROCEDURE InsertarGrupo
	@idGrupo int,
	@maxPersonas int,
	@canAdultos int,
	@canNiños int,
	@canExtranjeros int,
	@canPersonas int
AS
BEGIN
	INSERT INTO Grupo
	VALUES (@idGrupo, @maxPersonas, @canAdultos, @canNiños, @canExtranjeros, @canPersonas)
END;
exec InsertarGrupo 1, 30, 15, 5, 10, 20;
exec InsertarGrupo 2, 30, 15, null, 3, 15;
exec InsertarGrupo 3, 30, 1, 29, null, 30;
exec InsertarGrupo 4, 30, 20, 5, 5, 25;

-- Procedimiento para ver las tablas
GO
CREATE PROCEDURE VerEntidades
AS
BEGIN
    SELECT * FROM Grupo;
    SELECT * FROM Guia;
    SELECT * FROM Exhibicion;
    SELECT * FROM Piezas_Arqueologicas;
    SELECT * FROM Pinturas_Arqueologicas;
END;
exec VerEntidades

-- Trigger para saber cuando se agrego un nuevo guia
GO
CREATE TRIGGER NuevoGuia
ON Guia
after insert
as
begin
	PRINT 'Guia agregado';
end;

-- Insertar datos en la tabla Guia
INSERT INTO Guia (idGuia, nombre, apellido, edad, sexo, añosExperiencia, idiomaNatal,idiomaAprendido)
	   VALUES (1, 'Felipe', 'Tiul', 50, 'm', 10, 'Español', 'Ingles, Keqchi'),
			  (2, 'Mariana', 'Ramirez', 35, 'f', 2, 'Español', 'Ingles, Frances'),
			  (3, 'Paula', 'Xol', 60, 'f', 6, 'Kaqchikel', 'Español'),
			  (4, 'Diego', 'Godinez', 45, 'm', 3, 'Español', 'Ingles');

-- Alterar la tabla Exhibicion para agregarle horaInicio y horaFin
ALTER TABLE Exhibicion
DROP COLUMN horario; -- ELIMINAR la columna hora

ALTER TABLE Exhibicion
ADD horaInicio TIME, horaFin TIME;

-- Insertar datos en la tabla Exhibicion
INSERT INTO Exhibicion (idExhibicion, fechaInicio, fechaFin, horaInicio, horaFin, ubiInicial, ubiFinal, fkGuia, fkGrupo)
	   VALUES (100, '2025-02-15', '2025-02-16', '07:00', '08:00', 'Estacion A', 'Estacion D', 2, 4),
			  (101, '2025-02-16', '2025-02-20', '09:00', '10:00', 'Estacion B', 'Estacion C', 1, 3),
			  (102, '2025-02-15', '2025-02-18', '13:00', '14:00', 'Estacion C', 'Estacion B', 3, 2),
			  (103, '2025-02-18', '2025-02-27', '15:00', '16:00', 'Estacion D', 'Estacion A', 3, 1);

-- Trigger para saber cuando se elimino una Exhibicion
GO
CREATE TRIGGER ExhibicionCancelada
ON Exhibicion
after delete
as
BEGIN
	print 'SE CANCELO UNA EXHIBICION';
	SELECT * FROM Exhibicion;
END;

-- ELIMINAR la exhibicion con el ID 102
delete Exhibicion
where idExhibicion = 102;

-- Insertar datos en la tabla Piezas_Arqueo
exec VerEntidades
INSERT INTO Piezas_Arqueologicas (idPieArq, nombre, material, descubridor, fechaDescubrimiento, lugarDescubrimiento, estado, fkExhibicion)
	   VALUES (1, 'Collar de iximché', 'Oro', 'Juan Perez', '1950-02-15', 'Iximche, Chimaltenango', 1, 100),
			  (2, 'Ceramicos prehispanicos', 'Arcilla', 'Pablo Bosco', '1980-08-15', 'Iximche, Chimaltenango', 2, 103),
			  (3, 'Mascara Ceremonial', 'Piedra', 'Sebastian Cuc', '1960-05-17', 'Iximche, Chimaltenango', 1, 103),
			  (4, 'Herramientas', 'Obsidiana', 'Maria Tzoc', '1950-10-18', 'Iximche, Chimaltenango', 3, 101);
-- Insertar datos en la tabla Pinturas_Arqueo
INSERT INTO Pinturas_Arqueologicas (idPinArq, nombre, autor, tipoTecnica, fechaDescubrimiento, lugarDescubrimiento, estado, fkExhibicion)
	   VALUES (1, 'Maqueta del sitio arqueologico', 'mayas', 'maquetar', '1960-01-17', 'Iximche, Chimaltenango', 4, 103),
			  (2, 'Arte litico', 'mayas', 'Recursos Naturales', '1970-02-18', 'Iximche, Chimaltenango', 2, 103),
			  (3, 'Murales Policromos', 'mayas', 'Tallado Piedra', '1980-03-19', 'Iximche, Chimaltenango', 3, 100),
			  (4, 'Estelas Esculpidas', 'mayas', 'Tallado Piedra', '1990-05-20', 'Iximche, Chimaltenango', 1, 101);

-- Ver registros
exec VerEntidades

-- Para crear usuarios
CREATE LOGIN DevSenior WITH PASSWORD = '12345.'; -- login del DevSenior
CREATE USER DevSenior FOR LOGIN DevSenior; -- Crear DevSenior

CREATE LOGIN DevJunior WITH PASSWORD = '12345.'; -- login del DevJunior
CREATE USER DevJunior FOR LOGIN DevJunior; -- Crear DevJunior

-- DevSenior
ALTER ROLE db_datawriter ADD MEMBER DevSenior; -- pueden agregar, eliminar o cambiar datos en todas las tablas de usuario.
GRANT SELECT ON Exhibicion TO DevSenior; -- puede ver las consultas

INSERT INTO Exhibicion(idExhibicion, fechaInicio, fechaFin, horaInicio, horaFin, ubiInicial, ubiFinal, fkGuia, fkGrupo)
	   VALUES (104, '2025-02-15', '2025-02-18', '15:00', '16:00', 'Estacion C', 'Estacion B', 3, 2);
SELECT * FROM Exhibicion;

REVOKE SELECT ON Exhibicion TO DevSenior; -- YA NO puedo ver las consultas

-- DevJunior
alter role db_datawriter ADD MEMBER DevJunior; -- pueden agregar, eliminar o cambiar datos en todas las tablas de usuario.
deny delete on Exhibicion to DevJunior;

delete from Exhibicion; -- falta el where
select * from Exhibicion

-- Para cambiar de usario
EXECUTE AS USER = 'DevSenior'; -- Para cambiar al usuario DevSenior
EXECUTE AS USER = 'DevJunior'; -- Para cambiar al usuario DevJunior

SELECT SUSER_NAME(); -- Muestra el login actual
REVERT; -- Para regresar al usuario original