CREATE DATABASE BDMARINA;
USE BDMARINA;

CREATE TABLE Marino (
	idMarino INT NOT NULL PRIMARY KEY,
	UnidadAsignada INT NOT NULL,
	Contacto INT NOT NULL,
	Domicilio INT NOT NULL,
	DIM INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	Sexo INT NOT NULL -- 1 = M, 2 = F
);

CREATE TABLE carnéMarino (
	idDIM INT NOT NULL PRIMARY KEY,
	FKDIM INT NOT NULL foreign key references Marino(idMarino),
	HistorialMedico INT NOT NULL,
	Veterania INT NOT NULL,
	PagoMarino INT NOT NULL,
	EstadoCivil INT NOT NULL,-- 1 casado, 2 soltero, 3 divorciado
	CUI VARCHAR(50) NOT NULL,
	fechaNacimiento DATE NOT NULL,
	Nacionalidad VARCHAR(50) NOT NULL
);

CREATE TABLE unidadesOperativas (
	idUO INT NOT NULL PRIMARY KEY,
	FKRegionUnidad INT NOT NULL foreign key references Marino(idMarino),
	UnidadAsignada INT NOT NULL,
	TipoUnidad VARCHAR(50) NOT NULL,--Comando, Capitanía, Brigada, Astillero
	NombreUnidad VARCHAR(50) NOT NULL,
	Descripcion VARCHAR NOT NULL
);

CREATE TABLE Domicilio_Marino (
	idDomicilio INT NOT NULL PRIMARY KEY,
	FKDomicilio INT NOT NULL foreign key references Marino(idMarino),
	Direccion VARCHAR(50) NOT NULL,
	Zona VARCHAR(50) NOT NULL,
	Municipio VARCHAR(50) NOT NULL,
	Departamento INT NOT NULL,
	TelefonoResidencial VARCHAR(50) NOT NULL,
	Descripcion VARCHAR NOT NULL
);

CREATE TABLE Contacto_Marino (
	idContactoMarino INT NOT NULL PRIMARY KEY,
	FKContacto INT NOT NULL FOREIGN KEY REFERENCES Marino(idMarino),
	ConEmergencia INT NOT NULL,
	TelPersonal VARCHAR(50) NOT NULL,
	TelAlternativo VARCHAR(50) NOT NULL,
	Correo VARCHAR(50) NOT NULL
);

CREATE TABLE Contacto_Emergencia (
	idConEmergencia INT NOT NULL PRIMARY KEY,
	FKEmergencia INT NOT NULL FOREIGN KEY REFERENCES Contacto_Marino(idContactoMarino),
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	TelConEme VARCHAR(50) NOT NULL,
	TelAlterEme VARCHAR(50) NOT NULL
);

CREATE TABLE Regiones (
	idRegiones INT NOT NULL PRIMARY KEY,
	FKRegiones INT NOT NULL FOREIGN KEY REFERENCES unidadesOperativas(idUO),
	Region CHAR NOT NULL,
	BaseNaval INT NOT NULL,
	Descripcion VARCHAR
);

CREATE TABLE Puerto (
	idPuerto INT NOT NULL PRIMARY KEY,
	FKRegiones INT NOT NULL FOREIGN KEY REFERENCES Regiones(idRegiones),
	RegionBuque INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Region INT NOT NULL,
	TipoPuerto VARCHAR(50) NOT NULL,
	Capacidad INT NOT NULL
);

CREATE TABLE TipoBuque (
	idTipoBuque INT NOT NULL PRIMARY KEY,
	FKPuertoSalida INT NOT NULL FOREIGN KEY REFERENCES Puerto(idPuerto),
	Mision INT NOT NULL,
	PuertoSalida INT NOT NULL,
	TipoArmamento INT NOT NULL,
	Estado INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	UsoPrincipal VARCHAR(50) NOT NULL,
	CapacidadTripulacion INT NOT NULL,
	Descripcion VARCHAR
);

CREATE TABLE CapitanDeBuque (
	idCapiBuque INT NOT NULL PRIMARY KEY,
	FKEncargado INT NOT NULL FOREIGN KEY REFERENCES TipoBuque (idTipoBuque),
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Sexo INT NOT NULL,
	Edad INT NOT NULL,
	-- los mayas, los garífunas, los xincas y los ladinos o mestizos y extranjero
	Etnia NVARCHAR(50) NOT NULL,
	-- Teniente, Capitán de Fragata
	Rango VARCHAR(50) NOT NULL,
	FechaAsignacion DATE NOT NULL,
	Telefono VARCHAR(50) NOT NULL,
	-- Activo, Retirado
	Estado VARCHAR(50) NOT NULL
);

CREATE TABLE ArmamentoBuque (
	idArmamentoBuque INT NOT NULL PRIMARY KEY,
	idTipoArmamento INT NOT NULL FOREIGN KEY REFERENCES TipoBuque(idTipoBuque),
	NombreArmas VARCHAR(50) NOT NULL,
	CantidadArmas INT NOT NULL,
	CalibreArmamento VARCHAR(50) NOT NULL,
	TipoArma VARCHAR(50) NOT NULL,
	VehiculosTerrestres VARCHAR(50) NOT NULL,
	VehiculosMaritimos VARCHAR(50) NOT NULL
);

CREATE TABLE SaludMarino (
	idSaludMarino INT NOT NULL PRIMARY KEY,
	FKHistorialMedico INT NOT NULL FOREIGN KEY REFERENCES carnéMarino(idDIM),
	TipoSangre CHAR(3) NOT NULL,
	Alergias VARCHAR(50) NOT NULL,
	CondicionesMedicas VARCHAR(50) NOT NULL,
	Vacunas VARCHAR(50) NOT NULL,
	-- Apto, En Condiciones, No Apto
	AptitudMedica VARCHAR(50) NOT NULL,
	FechaUltimoChequeo DATE NOT NULL,
	Detalles VARCHAR NOT NULL
);

CREATE TABLE Sueldo (
	idSueldo INT NOT NULL PRIMARY KEY,
	FKPagoMarino INT NOT NULL FOREIGN KEY REFERENCES carnéMarino(idDIM),
	Marinero INT NOT NULL,
	SueldoBase MONEY NOT NULL,
	Bonificacion FLOAT,
	MetodoPago VARCHAR(50) NOT NULL,
	FechaPago DATE NOT NULL,
	SueldoNeto MONEY NOT NULL,
	--  impuestos, pensión, etc
	Deducciones MONEY NOT NULL
);

CREATE TABLE VeteraniaMarino (
	idVeterania INT NOT NULL PRIMARY KEY,
	FKVeterania INT NOT NULL FOREIGN KEY REFERENCES carnéMarino(idDIM),
	-- Cabo, Teniente, Capitán
	Rango VARCHAR(50) NOT NULL,
	AñosServicio INT NOT NULL,
	MisionesExito INT NOT NULL,
	-- Activo, Retirado, Reservista, etc
	Estado VARCHAR(50) NOT NULL,
	FechaIngreso DATE NOT NULL,
	-- Última fecha de ascenso de rango
	FechaPromocion DATE NOT NULL
);

CREATE TABLE MisionBuque (
	idMisionBuque INT NOT NULL PRIMARY KEY,
	FKMision INT NOT NULL FOREIGN KEY REFERENCES TipoBuque(idTipoBuque),
	Encargado INT NOT NULL,
	EstadoMarinero INT NOT NULL,
	EquipoMision INT NOT NULL,
	FechaInicio DATE NOT NULL,
	FechaFinal DATE NOT NULL,
	-- exitosa, fracaso, en proceso
	Estado VARCHAR(50) NOT NULL,
	Descripcion VARCHAR NOT NULL
);

CREATE TABLE BaseUnidadOperativa (
	idBaseUnidadOperativa INT NOT NULL PRIMARY KEY,
	FKBaseNaval INT NOT NULL FOREIGN KEY REFERENCES Regiones(idRegiones),
	CompraSuministros INT NOT NULL,
	Ubicacion VARCHAR(50) NOT NULL,
	Almacenamiento INT NOT NULL,
	CantidadMarineros INT NOT NULL,
	Descripcion VARCHAR
);

CREATE TABLE CompraSuministros (
	idCompraSuministros INT NOT NULL PRIMARY KEY,
	FKCompraSuministro INT NOT NULL FOREIGN KEY REFERENCES BaseUnidadOperativa(idBaseUnidadOperativa),
	Suministro INT NOT NULL,
	Proveedores INT NOT NULL,
	FechaCompra DATE NOT NULL,
	CantidadCompra INT NOT NULL,
	CostoTotal MONEY NOT NULL,
	ResponsableCompra VARCHAR(50) NOT NULL,
	Destino VARCHAR(50) NOT NULL,
	Estado INT NOT NULL,
	Detalles VARCHAR
);

CREATE TABLE EstadoBuque (
	idEstadoBuque INT NOT NULL PRIMARY KEY,
	FKEstado INT NOT NULL FOREIGN KEY REFERENCES TipoBuque(idTipoBuque),
	GrupoMecanicos INT NOT NULL,
	FechaIngreso DATE NOT NULL,
	FechaSalida DATE NOT NULL,
	Descripcion VARCHAR NOT NULL
);

CREATE TABLE EstadoMarinero (
	idEstadoMarinero INT NOT NULL PRIMARY KEY,
	FKEstado INT NOT NULL FOREIGN KEY REFERENCES MisionBuque(idMisionBuque),
	-- "Intacto", "Herido leve", "Herido grave", "Desaparecido", "Fallecido"
	Estado VARCHAR(50) NOT NULL,
	-- "A bordo", "Hospital", "En tierra"
	Ubicacion VARCHAR(50) NOT NULL,
	-- Última fecha en que se actualizó su estado.
	FechaEstado DATE NOT NULL,
	Detalles VARCHAR NOT NULL
);

CREATE TABLE IdentificacionMarino (
	idIdentifica INT NOT NULL PRIMARY KEY,
	Guatemalteco INT NOT NULL,
	Extranjero INT NOT NULL
);

CREATE TABLE DPI (
	idDPI INT NOT NULL PRIMARY KEY,
	FKGuatemalteco INT NOT NULL FOREIGN KEY REFERENCES IdentificacionMarino(idIdentifica),
	CUI VARCHAR(50) NOT NULL,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Sexo CHAR(2) NOT NULL, -- M, F
	-- los mayas, los garífunas, los xincas y los ladinos o mestizos y extranjero
	Etnia VARCHAR(50) NOT NULL
);

CREATE TABLE Pasaporte (
	idPasaporte INT NOT NULL PRIMARY KEY,
	FKExtranjero INT NOT NULL FOREIGN KEY REFERENCES IdentificacionMarino(idIdentifica),
	NumeroPasaporte INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Nacionalidad VARCHAR(50) NOT NULL,
	Sexo CHAR(2) NOT NULL -- M, F
);

CREATE TABLE EquipoMecanico (
	idEquipoMecanico INT NOT NULL PRIMARY KEY,
	FKGrupoMecanico INT NOT NULL FOREIGN KEY REFERENCES EstadoBuque(idEstadoBuque),
	JefeGrupo INT NOT NULL,
	AreaEquipo VARCHAR(50) NOT NULL,
	-- Operativo, En mantenimiento, Fuera de servicio
	Estado VARCHAR(50) NOT NULL,
	FechaUltimoMantenimiento DATE NOT NULL,
	FechaIngreso DATE NOT NULL,
	FechaSalida DATE NOT NULL
);

CREATE TABLE MecanicoEncargado (
	idMecanicoEncargado INT NOT NULL PRIMARY KEY,
	FKJefeGrupo INT NOT NULL FOREIGN KEY REFERENCES EquipoMecanico(idEquipoMecanico),
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	-- los mayas, los garífunas, los xincas y los ladinos o mestizos y extranjero
	Etnia NVARCHAR(50) NOT NULL,
	NumPasaporte INT NOT NULL,
	AñosExperiencia INT NOT NULL
);

CREATE TABLE EquipoBuque (
	idEquipoBuque INT NOT NULL PRIMARY KEY,
	FKEquipoMision INT NOT NULL FOREIGN KEY REFERENCES MisionBuque(idMisionBuque),
	-- (e.g., "Radar de navegación", "Sistema de comunicación VHF").
	NombreEquipo VARCHAR(50) NOT NULL,
	-- (e.g., "Navegación", "Defensa", "Comunicaciones", "Rescate").
	TipoEquipo VARCHAR(50) NOT NULL,
	-- Operativo, En mantenimiento, Dañado, Fuera de servicio
	Estado VARCHAR(50) NOT NULL,
	FechaAdquisicion DATE NOT NULL,
	FechaUltimoMantenimiento DATE NOT NULL,
	CantidadEquipo VARCHAR(50) NOT NULL,
	FechaVencimiento DATE NOT NULL
);

CREATE TABLE Suministros (
	idSuministros INT NOT NULL PRIMARY KEY,
	FKSuministro INT NOT NULL FOREIGN KEY REFERENCES CompraSuministros(idCompraSuministros),
	Nombre VARCHAR(50) NOT NULL,
	TipoSuministro INT NOT NULL,
	UnidadMedida VARCHAR(50) NOT NULL,
	Stock INT NOT NULL,
	Estado INT NOT NULL,
	Detalles VARCHAR(50) NOT NULL
);

CREATE TABLE ProveedoresSuministros (
	idProveedoresSuministros INT NOT NULL PRIMARY KEY,
	FKProveedores INT NOT NULL FOREIGN KEY REFERENCES CompraSuministros(idCompraSuministros),
	Nombre VARCHAR(50) NOT NULL,
	Contacto VARCHAR(50) NOT NULL,
	TelefonoContacto VARCHAR(50) NOT NULL,
	CorreoProveedor VARCHAR(50) NOT NULL,
	DireccionPro VARCHAR(50) NOT NULL,
	MetodoPago VARCHAR(50) NOT NULL,
	FechaUltimaCompra DATE NOT NULL,
	-- Activo, Suspendido, Inactivo
	Estado VARCHAR(50) NOT NULL,
	NotasAdicionales VARCHAR NOT NULL
);

--Agregar datos
-- Insertar datos en la tabla Marino
INSERT INTO Marino VALUES
(1, 101, 201, 301, 401, 'Carlos', 'Pérez', 1),
(2, 102, 202, 302, 402, 'María', 'Gómez', 2);
SELECT * FROM Marino
-- Insertar datos en la tabla carnéMarino
INSERT INTO carnéMarino VALUES
(401, 1, 501, 10, 601, 2, '1234567890101', '1990-05-10', 'Guatemalteco'),
(402, 2, 502, 5, 602, 1, '1234567890202', '1985-08-25', 'Guatemalteco');
SELECT * FROM carnéMarino
--------------------------------------------------- Insertar datos en la tabla unidadesOperativas
INSERT INTO unidadesOperativas (idUO, FKRegionUnidad, UnidadAsignada, TipoUnidad, NombreUnidad, Descripcion) 
VALUES 
(401, 1, 1, 'Brigada', 'Brigada Naval 1', ''),
(402, 2, 2, 'Capitanía', 'Capitanía del Puerto', '');
SELECT * FROM unidadesOperativas
--------------------------------------------------- Insertar datos en la tabla Domicilio_Marino
INSERT INTO Domicilio_Marino VALUES
(301, 1, 'Avenida Central #123', 'Zona 1', 'Ciudad', 10, '22334455', ''),
(302, 2, 'Calle Secundaria #456', 'Zona 2', 'Pueblo', 15, '66778899', '');
SELECT * FROM Domicilio_Marino
-- Insertar datos en la tabla Contacto_Marino
INSERT INTO Contacto_Marino VALUES
(201, 1, 701, '55512345', '55567890', 'carlos@email.com'),
(202, 2, 702, '55598765', '55543210', 'maria@email.com');
SELECT * FROM Contacto_Marino
-- Insertar datos en la tabla Contacto_Emergencia
INSERT INTO Contacto_Emergencia VALUES
(701, 201, 'Juan', 'Pérez', '66612345', '66667890'),
(702, 202, 'Ana', 'Gómez', '77798765', '77743210');
SELECT * FROM Contacto_Emergencia
--15 consultas utilizando join y consultas anidadas.
-- 1. Obtener la información completa de los marinos con sus carnés
SELECT Marino.idMarino, Marino.Nombre, Marino.Apellido, carnéMarino.CUI, carnéMarino.Nacionalidad 
FROM Marino
JOIN carnéMarino ON Marino.idMarino = carnéMarino.FKDIM;

-- 2. Listar los marinos con su unidad operativa asignada
SELECT Marino.Nombre, Marino.Apellido, unidadesOperativas.NombreUnidad, unidadesOperativas.TipoUnidad 
FROM Marino
JOIN unidadesOperativas ON Marino.UnidadAsignada = unidadesOperativas.idUO;

-- 3. Obtener la dirección de cada marino
SELECT M.Nombre, M.Apellido, D.Direccion, D.Zona, D.Municipio 
FROM Marino M
JOIN Domicilio_Marino D ON M.Domicilio = D.idDomicilio;

-- 4. Mostrar los contactos personales y de emergencia de cada marino
SELECT M.Nombre, M.Apellido, C.TelPersonal, C.Correo, E.Nombre AS ContactoEmergencia, E.TelConEme 
FROM Marino M
JOIN Contacto_Marino C ON M.Contacto = C.idContactoMarino
JOIN Contacto_Emergencia E ON C.ConEmergencia = E.idConEmergencia;

-- 5. Obtener el sueldo de cada marino con su bonificación
SELECT M.Nombre, M.Apellido, S.SueldoBase, S.Bonificacion, S.SueldoNeto 
FROM Marino M
JOIN carnéMarino C ON M.DIM = C.idDIM
JOIN Sueldo S ON C.PagoMarino = S.FKPagoMarino;

-- 6. Mostrar los marinos con su historial médico
SELECT M.Nombre, M.Apellido, SM.TipoSangre, SM.Alergias, SM.CondicionesMedicas 
FROM Marino M
JOIN carnéMarino C ON M.DIM = C.idDIM
JOIN SaludMarino SM ON C.HistorialMedico = SM.FKHistorialMedico;

-- 7. Obtener las misiones asignadas a los buques con su estado
SELECT B.Nombre, M.FechaInicio, M.FechaFinal, M.Estado 
FROM TipoBuque B
JOIN MisionBuque M ON B.idTipoBuque = M.FKMision;

-- 8. Mostrar los buques con sus capitanes asignados
SELECT C.Nombre, C.Apellido, C.Rango, B.Nombre AS NombreBuque 
FROM CapitanDeBuque C
JOIN TipoBuque B ON C.FKEncargado = B.idTipoBuque;

-- 9. Listar los buques con su tipo de armamento
SELECT B.Nombre, A.NombreArmas, A.CantidadArmas, A.CalibreArmamento 
FROM TipoBuque B
JOIN ArmamentoBuque A ON B.idTipoBuque = A.idTipoArmamento;

-- 10. Obtener los marinos con su rango y años de servicio
SELECT M.Nombre, M.Apellido, V.Rango, V.AñosServicio, V.Estado 
FROM Marino M
JOIN carnéMarino C ON M.DIM = C.idDIM
JOIN VeteraniaMarino V ON C.Veterania = V.idVeterania;

-- 11. Mostrar las regiones con sus bases navales
SELECT R.Region, R.BaseNaval, U.NombreUnidad 
FROM Regiones R
JOIN unidadesOperativas U ON R.FKRegiones = U.idUO;

-- 12. Obtener el estado actual de cada buque
SELECT B.Nombre, E.Descripcion, E.FechaIngreso, E.FechaSalida 
FROM TipoBuque B
JOIN EstadoBuque E ON B.idTipoBuque = E.FKEstado;

-- 13. Mostrar las compras de suministros con sus proveedores
SELECT C.ResponsableCompra, C.FechaCompra, P.Nombre, P.TelefonoContacto 
FROM CompraSuministros C
JOIN ProveedoresSuministros P ON C.idCompraSuministros = P.FKProveedores;

-- 14. Listar los mecánicos encargados de los equipos mecánicos
SELECT M.Nombre, M.Apellido, E.AreaEquipo, E.Estado 
FROM MecanicoEncargado M
JOIN EquipoMecanico E ON M.FKJefeGrupo = E.idEquipoMecanico;

-- 15. Obtener los marinos con su identificación
SELECT M.Nombre, M.Apellido, D.CUI AS DPI, P.NumeroPasaporte 
FROM Marino M
LEFT JOIN carnéMarino C ON M.DIM = C.idDIM
LEFT JOIN IdentificacionMarino I ON I.idIdentifica = C.idDIM
LEFT JOIN DPI D ON I.Guatemalteco = D.FKGuatemalteco
LEFT JOIN Pasaporte P ON I.Extranjero = P.FKExtranjero;