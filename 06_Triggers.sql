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
				ON h.IdTipo = t.idTipoHabitacion
			WHERE (
				SELECT COUNT(*)
				FROM ReservasHuespedes rh
				WHERE rh.idReserva = i.idReserva
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
			WHERE rh.idReserva = i.idReserva
				AND rh.esTitular = 1
			) > 1
		)
	BEGIN
		THROW 50004,


