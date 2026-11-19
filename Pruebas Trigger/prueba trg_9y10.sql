
USE GestionDeHotel;
GO

BEGIN TRY
    BEGIN TRANSACTION;
    SELECT * FROM PlazasDeEstacionamiento
    WHERE IdPlazaDeEstacionamiento = 5;
    INSERT INTO VehiculosPlazas
        (IdVehiculo, IdPlazaDeEstacionamiento)
    VALUES (3, 5);
    SELECT * FROM PlazasDeEstacionamiento
    WHERE IdPlazaDeEstacionamiento = 5;
    DELETE FROM VehiculosPlazas
    WHERE IdVehiculo = 3 AND IdPlazaDeEstacionamiento = 5;
    SELECT * FROM PlazasDeEstacionamiento
    WHERE IdPlazaDeEstacionamiento = 5;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
