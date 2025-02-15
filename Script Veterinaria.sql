CREATE DATABASE Veterinaria
USE Veterinaria

CREATE TABLE Mascota (
	MascotaID INT Primary Key,
	Nombre NVARCHAR(50),
	Especie NVARCHAR(50), -- lo mismo que tipoAnimal
	Raza NVARCHAR(50),
	Edad INT
);

CREATE TABLE Cita (
	CitaID INT PRIMARY KEY,
	MascotaID INT,
	Fecha DATE,
	Hora TIME,
	Descripcion NVARCHAR(100),
	FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID)
);

CREATE TABLE ConsultaVeterinaria(
	ConsultaID INT PRIMARY KEY,
	FechaConsulta DATE,
	Diagnostico NVARCHAR (255),
	CostoConsulta DECIMAL (10, 2),
	MascotaID INT,
	FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID)
);

-- Crear procedimiento de mascota
GO
CREATE PROCEDURE InsertarMascota
	@MascotaID INT,
	@Nombre NVARCHAR (50),
	@Especie NVARCHAR (50),
	@Raza NVARCHAR (50),
	@Edad INT
AS
BEGIN
	INSERT INTO Mascota (MascotaID, Nombre, Especie, Raza, Edad)
	VALUES (@MascotaID, @Nombre, @Especie, @Raza, @Edad);
END;

exec InsertarMascota 1, 'Fulanito', 'Shitzu', 'Shitzu', 5;

--Crear procedimiento de cita
GO
CREATE PROCEDURE InsertarCita
	@CitaID INT,
	@MascotaID INT,
	@Fecha DATE,
	@Descripcion NVARCHAR (100)
AS
BEGIN
	INSERT INTO Cita (CitaID, MascotaID, Fecha, Descripcion)
	VALUES (@CitaID, @MascotaID, @Fecha, @Descripcion);
END;
EXEC InsertarCita 1,1,'2025-02-04','Buen Perrito';

-- Actualizar cita
UPDATE Cita
SET Fecha= '2025-02-11', Hora='11:00'
WHERE CitaID = 1

-- Trigger
GO
CREATE TRIGGER ActualizarCitaLog
ON Cita
AFTER UPDATE
AS
BEGIN
	DECLARE @CitaID INT, @FechaAnterior DATE, @HoraAnterior TIME, @FechaNueva DATE, @HoraNueva TIME;
	
	--OBTENER LOS VALORES ANTES Y DESPUES DE LA ACTUALIZACION
	SELECT @CitaID = CitaID,
		   @FechaAnterior = Fecha, @HoraAnterior = Hora
	FROM deleted;

	SELECT @FechaNueva = Fecha, @HoraAnterior = Hora
	FROM inserted;

	--verificamos si la fecha o la hora de la cita cambiaron
	IF @FechaAnterior != @FechaNueva OR @HoraAnterior != @HoraNueva
	BEGIN
		PRINT 'La cita con ID: ' + CAST(@CitaID AS NVARCHAR) + ' HA SIDO ACTUALIZADA.';
		PRINT 'Fecha Anterior: ' + CAST(@FechaAnterior AS NVARCHAR) + ', Hora anterior: ' + cast(@HoraAnterior AS NVARCHAR);
		PRINT 'Fecha Nueva: ' + CAST(@FechaNueva AS NVARCHAR) + ', Hora Nueva: ' + cast(@HoraNueva AS NVARCHAR);
	END;
END;

SELECT * FROM Mascota
SELECT * FROM Cita
SELECT * FROM ConsultaVeterinaria

-- Creacion del trigger
CREATE TRIGGER CalcularEdadMascota
ON ConsultaVeterinaria
AFTER INSERT
AS
BEGIN
	UPDATE m
	SET Edad = Edad + 1
	FROM Mascota m
	INNER JOIN inserted i ON m.MascotaID = i.MascotaID
END;

-- Insertar datos de ejemplo
INSERT INTO Mascota (MascotaID, Nombre, Edad, Especie, Raza)
VALUES (5, 'Negro', 10, 'Perro', 'labrador'),
	   (6, 'Kuku', 8, 'Perro', 'Shitzu'),
	   (7, 'Chula', 10, 'Perro', 'Criollo'),
	   (8, 'Canchita', 5, 'Perro', 'Shitzu');

SELECT * FROM Mascota

INSERT INTO ConsultaVeterinaria (ConsultaID, FechaConsulta, Diagnostico, CostoConsulta, MascotaID)
VALUES (1, '2024-03-07', 'Vacunacion', 50.00, 1),
	   (2, '2024-03-08', 'Control de Salud', 35.00, 5),
	   (5, '2024-03-18', 'Vacunacion', 55.00, 6),
	   (6, '2024-03-18', 'Control de Salud', 45.00, 7);

SELECT * FROM ConsultaVeterinaria

CREATE INDEX IX_Mascota_Nombre ON Mascota (Nombre);
GO

CREATE VIEW VistaPromedioEdadPorTipoAnimal AS
SELECT Especie, AVG(Edad) AS PromedioEdad
FROM Mascota
GROUP BY Especie;
GO

SELECT * FROM VistaPromedioEdadPorTipoAnimal;
SELECT * FROM ConsultaVeterinaria;