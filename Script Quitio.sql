CREATE DATABASE Quitio
USE Quitio

-- Crear la tabla Clientes
CREATE TABLE Cliente (
	ClienteID INT PRIMARY KEY,
	Nombre NVARCHAR (50),
	Edad INT,
	Email NVARCHAR (100)
);

-- Crear la tabla Pedidos
CREATE TABLE Pedidos (
	PedidoID INT PRIMARY KEY,
	FechaPedido DATE,
	Total DECIMAL (10, 2),
	ClienteID INT,
	FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

-- tabla detalles pedido
CREATE TABLE DetallesPedido (
	DetalleID INT PRIMARY KEY,
	PedidoID INT,
	Producto NVARCHAR (50),
	Cantidad INT,
	PrecioUnitario DECIMAL(10, 2),
	FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID)
);

SELECT * FROM Cliente
SELECT * FROM Pedidos
SELECT * FROM DetallesPedido

GO
CREATE TRIGGER ActualizarEdadCliente
ON Pedidos
AFTER INSERT
AS
BEGIN
	UPDATE c
	SET Edad = Edad + 1
	FROM Cliente c
	INNER JOIN inserted i ON c.ClienteID = i.ClienteID;
END;

-- Crear indices en las tablas
CREATE INDEX IX_Cliente_Nombre ON Cliente (Nombre);
CREATE INDEX IX_Pedidos_ClienteID ON Pedidos (ClienteID);
CREATE INDEX IX_DetallesPedido_PedidoID ON DetallesPedido (PedidoID);

-- Crear vista de los detalles de los pedidos
GO
CREATE VIEW Vista_DetallesPedidos AS
SELECT p.PedidoID, p.FechaPedido, c.Nombre AS Nombre_Cliente, 
	   d.Producto, d.Cantidad, d.PrecioUnitario
FROM Pedidos p
INNER JOIN Cliente c ON p.ClienteID = c.ClienteID
INNER JOIN DetallesPedido d ON p.PedidoID = d.PedidoID
GO

-- Insertar Datos de Cliente
INSERT INTO Cliente (ClienteID, Nombre, Edad, Email)
VALUES (1, 'Juan Perez', 12, 'jperez@gmail.com'),
	   (2, 'Maria Garcia', 24, 'mgarcia@gmail.com'),
	   (3, 'Pedro Lopez', 45, 'plopez@gmail.com'),
	   (4, 'Laura Martinez', 23, 'lmartinez@gmail.com'),
	   (5, 'Ana Sanchez', 28, 'asanchez@gmail.com');
-- Insertar Datos de Pedidos
INSERT INTO Pedidos (PedidoID, FechaPedido, Total, ClienteID)
VALUES (101, '2024-03-15', 100.00, 1),
	   (102, '2024-03-14', 200.00, 2),
	   (103, '2024-03-13', 300.00, 3),
	   (104, '2024-03-12', 340.50, 4),
	   (105, '2024-03-11', 56.00, 5);
-- Insertar Datos de Detalles Pedidos
INSERT INTO DetallesPedido (DetalleID, PedidoID, Producto, Cantidad, PrecioUnitario)
VALUES (200, 101, 'Tomates', 2, 12.34),
	   (201, 101, 'Piña Hawaiana', 1, 13.45),
	   (202, 103, 'Sandia', 1, 14.12),
	   (203, 103, 'Limones', 3, 12.34),
	   (204, 104, 'Pepino', 2, 10.25);

SELECT * FROM Cliente
SELECT * FROM Pedidos
SELECT * FROM DetallesPedido

-- Consultas optimizadas y estadisticas
-- Consulta optimizada para obtener el total de ventas por cliente
SELECT c.Nombre AS Cliente, SUM(p.Total) AS TotalVentas
FROM Cliente c
INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.Nombre

-- Estadisticas de la base de datos
-- Ver las estadisticas de las tablas
EXEC sp_helpstats 'Cliente';
EXEC sp_helpstats 'Pedidos';
EXEC sp_helpstats 'DetallesPedido';

-- ver el plan de ejecucion de una consulta para ver si se estan utilizando los indices
SET SHOWPLAN_TEXT ON; -- SIN DIBUJOS Y GRAFICAS (Resumen en tablas)
GO
SELECT * FROM Cliente WHERE Nombre = 'Juan Perez'; -- Consulta a la que quiero ver sus stats
GO
SET SHOWPLAN_TEXT OFF; -- CON DIBUJOS Y GRAFICAS (tablas mas detalladas y largas)