use GestionDeHotel
-- Calcular importe de una reserva (recibe identificador de reserva y devuelve cuanto cuesta el alojamiento)
create function fn_ImporteReserva (@IdReserva INT) returns decimal(12,2) as
begin
    declare @Importe decimal(12,2);
    select
        @Importe = PrecioPorNoche * DATEDIFF(DAY, FechaEntrada, FechaSalida)
    from Reservas
    where IdReserva = @IdReserva;
    return @Importe;
end;

-- calcula el importe de una reserva especifica (10 en este caso)
select dbo.fn_ImporteReserva(10) as ImporteReserva;


-- calcular saldo pendiente de una reserva
create or alter function fn_SaldoPendienteReserva (@IdReserva INT) returns decimal(12,2) as
begin
    declare @ImporteReserva decimal(12,2);
    declare @TotalPagado decimal(12,2);
    declare @Saldo decimal (12,2)
    set @ImporteReserva = dbo.fn_ImporteReserva(@IdReserva);
    select
        @TotalPagado = coalesce(sum(Importe), 0)
    from Pagos
    where IdReserva = @IdReserva;
    if @ImporteReserva is null
        return null;
        set @Saldo = @ImporteReserva - @TotalPagado;
        if @Saldo < 0
            set @Saldo = 0;
    return @Saldo;
End;

--consultar saldo de todas las reservas 
select
    IdReserva,
    dbo.fn_SaldoPendienteReserva(IdReserva) as SaldoPendiente
from Reservas;

--consultar cuanto gasto un huesped en productos
create function fn_TotalGastadoHuesped (@IdHuesped INT) returns decimal(12,2) as
begin
    declare @TotalGastado decimal(12,2);
    select
        @TotalGastado = coalesce(SUM(PC.Cantidad * P.Precio),0)
    from ConsumosDeHuesped C
    inner join ProductosPorConsumo PC on C.IdConsumo = PC.IdConsumo
    inner join Productos P on PC.IdProducto = P.IdProducto
    where C.IdHuesped = @IdHuesped;
    return @TotalGastado;
END;

-- muestra cuanto gasto cada huesped
select
    H.IdHuesped,
    H.NombreHuesped,
    dbo.fn_TotalGastadoHuesped(H.IdHuesped) as TotalGastado
from Huespedes H
order by TotalGastado desc;

--consultar habitaciones disponibles para un periodo

create or alter function fn_HabitacionesDisponibles (@FechaEntrada date, @FechaSalida date) returns table as
return (
    select
        H.IdHabitacion,
        H.Piso,
        H.Estado,
        H.Limpieza,
        T.IdTipoHabitacion,
        T.NombreTipo,
        T.CostoHabitacion,
        T.CapacidadHabitacion
    from Habitaciones H
    inner join TiposDeHabitacion T on H.IdTipoHabitacion = T.IdTipoHabitacion
    where @FechaEntrada < @FechaSalida and not exists
        (
            select 1
            from Reservas R
            where R.IdHabitacion = H.IdHabitacion AND R.FechaEntrada < @FechaSalida AND R.FechaSalida > @FechaEntrada
        )
);

select * from dbo.fn_HabitacionesDisponibles('2026-11-10', '2026-11-15');



