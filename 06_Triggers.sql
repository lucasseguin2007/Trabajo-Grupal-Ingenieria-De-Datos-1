USE GestionDeHotel;
GO
-- 1. Trigger: impide que dos reservas confirmadas ocupen una misma habitacion en fechas que se superpongan
CREATE TRIGGER trg_ValidarDisponibilidadHabitacion
ON Reservas 
AFTER INSERT, UPDATE
AS 
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM inserted i
			INNER JOIN Reservas r
			On i.IdHabitacion = r.IdHabitacion
			WHERE  NOT (i.IdReserva = r.IdReserva)
			AND i.Estado = 'Confirmada'
			AND r.Estado = 'Confirmada'
			AND i.FechaEntrada < r.FechaSalida
			AND i.FechaSalida > r.FechaEntrada
		)
		BEGIN
			;THROW 50001,'La habitaciion ya esta reservada para esas fechas.',1;
		END
	END;
GO

-- 2 Trigger: Impedir cancelaciones 1 dia antes.
CREATE TRIGGER trg_ValidarCancelacionReserva
ON Reservas
AFTER UPDATE
AS
	BEGIN 
		IF EXISTS (
			SELECT 1
			FROM inserted i
			INNER JOIN deleted d
			ON i.IdReserva = d.IdReserva
			WHERE i.Estado = 'Cancelada'
			AND NOT (d.Estado = 'Cancelada')
			AND CAST(GETDATE() AS DATE) > DATEADD(DAY, -1, i.FechaEntrada)
		)
		BEGIN
			;THROW 50002,'No se puede cancelar la reserva el dia del Check In.',1;
		END
	END;
GO

--3 Trigger: impide que se registre una reserva con más huéspedes de los que permite la habitación.
CREATE TRIGGER trg_ValidarCapacidadHabitacion
ON ReservasHuespedes
AFTER INSERT, UPDATE
AS
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM inserted i
			INNER JOIN Reservas r
				ON i.IdReserva = r.IdReserva
			INNER JOIN Habitaciones h
				ON r.IdHabitacion = h.IdHabitacion
			INNER JOIN tiposdeHabitacion t
				ON h.IdTipoHabitacion = t.idTipoHabitacion
			WHERE (
				SELECT COUNT(*)
				FROM ReservasHuespedes rh
				WHERE rh.IdReserva = i.IdReserva
			) > t.capacidadHabitacion
		)
		BEGIN
			;THROW 50003, 'La cantidad de huespedes supera la capacidad de la habitacion.',1;

		END
	END;
GO

--4 Trigger: Controla que cada reserva tenga un único huésped titular

CREATE TRIGGER trg_ValidarTitularReserva
ON ReservasHuespedes
AFTER INSERT, UPDATE
AS 
	BEGIN
		IF Exists (
			SELECT 1
			FROM inserted i
			WHERE (
				SELECT COUNT(*)
				FROM ReservasHuespedes rh
				WHERE rh.IdReserva = i.IdReserva
					AND rh.EsTitular = 1
				) > 1
			)
		BEGIN
			;THROW 50004, 'Una reserva no puede tener mas de un titular.',1;
		END
	END;
GO

--5 Trigger: Valida que el Check in se haga según la regla de negocio

CREATE TRIGGER trg_ValidarHorarioCheckIn
ON Estadias
AFTER INSERT, UPDATE
AS
	BEGIN
		IF exists (
			SELECT 1
			FROM inserted i
			WHERE CAST(i.FechaHoraCheckIn AS TIME) < '14:00:00'
			)
		BEGIN
			;THROW 50005, 'El Check in se debe realiza despues de las 14:00',1;
		END
	END;
GO

--6 Trigger: Impedir que un menor de edad sea titular de una reserva
CREATE TRIGGER trg_ValidarEdadTitular
ON ReservasHuespedes
AFTER INSERT, UPDATE
AS
	BEGIN
		IF exists (
			SELECT 1
			FROM inserted i
			INNER JOIN Huespedes h
			ON i.IdHuesped = h.IdHuesped
			WHERE i.EsTitular = 1 
			AND (DATEADD(YEAR,18,h.FechaNacimiento) > CAST(GETDATE() AS DATE))
			)
		BEGIN
			;THROW 50006, 'El titular debe ser mayor de 18 años',1;
		END
	END;
GO

--7 Trigger: Actualizar el stock de un Producto consumido por un huesped
CREATE TRIGGER trg_ActualizarStock
ON ProductosPorConsumo
AFTER INSERT
AS
	BEGIN
		IF exists (
			SELECT 1
			FROM Productos p
			INNER JOIN (
				SELECT IdProducto, SUM(Cantidad) as TotalConsumido
				From inserted
				Group by Idproducto
			) c
			On p.IdProducto = c.Idproducto
			WHERE c.TotalConsumido > p.Stock
		)
		BEGIN
			;THROW 50007, 'No hay stock suficiente',1;
		END
		UPDATE p
		SET p.Stock = p.Stock - c.TotalConsumido
		FROM Productos p
		INNER JOIN (
			SELECT IdProducto, SUM(Cantidad) as TotalConsumido
			From inserted
			Group by Idproducto
		) c
		On p.IdProducto = c.Idproducto
	END;
GO

--8 Trigger: Alertar por bajo stock
CREATE TRIGGER trg_AlertaStockBajo
ON Productos
AFTER UPDATE
AS
	BEGIN
		IF exists (
			SELECT 1
			FROM inserted
			WHERE Stock < 10
		)
		BEGIN
			PRINT 'ATENCION: hay productos con bajo stock.';
		END
	END;
GO

--9 Trigger: Actualizar la disponibilidad del estacionamiento
CREATE TRIGGER trg_ActualizarEstadoEstacionamiento
ON VehiculosPlazas
AFTER INSERT
AS
	BEGIN
		IF exists(
			SELECT 1
			FROM VehiculosPlazas vp
			WHERE vp.IdPlazaDeEstacionamiento IN (
				SELECT IdPlazaDeEstacionamiento
				FROM inserted
			)
			GROUP BY vp.IdPlazaDeEstacionamiento
			HAVING COUNT(*) > 1
		)
		BEGIN
			;THROW 50009, 'La plaza ya tiene un vehiculo asignado.',1;
		END
		UPDATE p
		SET p.Estado = 'Ocupada'
		FROM PlazasDeEstacionamiento p
		INNER JOIN inserted i 
		ON i.IdPlazaDeEstacionamiento = p.IdPlazaDeEstacionamiento
	END;
GO

--10 Trigger: 
CREATE TRIGGER trg_LiberarPlazaEstacionamiento
ON VehiculosPlazas
AFTER DELETE
AS
	BEGIN
		UPDATE p
		SET p.Estado = 'Disponible'
		FROM PlazasDeEstacionamiento p
		INNER JOIN deleted d
		ON d.IdPlazaDeEstacionamiento = p.IdPlazaDeEstacionamiento
		WHERE NOT EXISTS (
			SELECT 1
			FROM VehiculosPlazas vp
			WHERE vp.IdPlazaDeEstacionamiento = p.IdPlazaDeEstacionamiento
		);
	END;
GO
		

