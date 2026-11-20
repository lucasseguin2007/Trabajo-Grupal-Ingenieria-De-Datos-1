USE GestionDeHotel;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @IdConsumoPrueba INT;
    INSERT INTO ConsumosDeHuesped
        (IdHuesped, FechaConsumo)
    VALUES (1, '2026-11-19');
    SET @IdConsumoPrueba = SCOPE_IDENTITY();
    INSERT INTO ProductosPorConsumo
        (IdConsumo, IdProducto, Cantidad)
    VALUES (@IdConsumoPrueba, 9, 1);
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
