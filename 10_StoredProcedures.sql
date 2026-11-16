use GestionDeHotel;
go

create procedure sp_EmpleadoLimpiezaLibre
as 
begin
select top 1 e.IdEmpleado, Nombre from Empleados e
left join LimpiezasDeHabitaciones lh
on e.IdEmpleado = lh.IdEmpleado
and cast(lh.HorarioInicioLimpieza as date) = cast(getdate() as date)
group by e.IdEmpleado, e.Nombre
order by count(lh.IdLimpieza) asc;
end;
go

create procedure sp_EmpleadoMantenimientoLibre
as 
begin
select top 1 e.IdEmpleado, Nombre from Empleados e
left join SolicitudesDeMantenimiento sm
on e.IdEmpleado = sm.IdEmpleado
and sm.Fecha = cast(getdate() as date)
group by e.IdEmpleado, e.Nombre
order by count(sm.IdSolicitud) asc;
end; 
go

create procedure sp_HabitacionDisponible
@CantidadHuespedes int
as 
begin
select top 1 h.IdHabitacion, h.IdTipoHabitacion, h.Estado, h.Limpieza, h.Piso,th.NombreTipo,th.CapacidadHabitacion from Habitaciones h
inner join TiposDeHabitacion th
on h.IdTipoHabitacion = th.IdTipoHabitacion
and th.CapacidadHabitacion >= @CantidadHuespedes
where Estado = 'Desocupada' and Limpieza = 'Limpia'
order by th.CapacidadHabitacion asc;
end;
go

create procedure sp_HabitacionLimpia
@IdLimpieza int
as 
begin
update Habitaciones
set Limpieza = 'Limpia'
where IdHabitacion = (
select IdHabitacion from LimpiezasDeHabitaciones
where IdLimpieza = @IdLimpieza);
end;
go

create procedure sp_CheckInEstadia
    @IdReserva int 
as 
begin
    declare @IdHabitacion int; 
    declare @CantidadHuespedes int;

    declare @TablaTemporal table (Id int, IdTipo int, Est varchar(15), Limp varchar(30), Piso int, NombreTipo nvarchar(30), Capacidad int);
    BEGIN TRY
        BEGIN TRANSACTION;
        if not exists (
        select 1
        from Reservas
        where IdReserva = @IdReserva
        )
        begin
            ;throw 50011, 'La reserva indicada no existe.',1;
        end;

        select @CantidadHuespedes = count(*) from ReservasHuespedes
        where IdReserva = @IdReserva;
        insert into @TablaTemporal
        exec sp_HabitacionDisponible @CantidadHuespedes;
        select top 1 @IdHabitacion = Id from @TablaTemporal;
        if @IdHabitacion is null
        begin
             ;throw 50004, 'No hay habitaciones disponibles con capacidad suficiente.', 1;
        end;
        update Estadias
        set FechaHoraCheckIn = getdate()
        where IdReserva = @IdReserva;  
        update Reservas
        set IdHabitacion = @IdHabitacion
        where IdReserva = @IdReserva;
        update Habitaciones
        set Estado = 'Ocupada'
        where IdHabitacion = @IdHabitacion;
        COMMIT TRANSACTION;
    end try
    begin catch
        if @@TRANCOUNT > 0
        Begin
            Rollback transaction;
        end;
        throw;
    end catch
end;
go

create procedure sp_PlazasLibres
as 
begin
select top 1 IdPlazaDeEstacionamiento, Estado from PlazasDeEstacionamiento
where Estado = 'Disponible'
order by IdPlazaDeEstacionamiento asc;
end;
go

create procedure sp_AsignarEstacionamiento 
@IdVehiculo int
as 
begin
    declare @IdPlaza int
    declare @TablaTemporal table (Id int,Estado nvarchar(20));
    begin try
        begin transaction;
        if not exists (
        select 1
        from Vehiculos
        where IdVehiculo = @IdVehiculo
        )
        begin
            ;throw 50013, 'El Vehiculo indicado no existe.',1;
        end;
        if exists(
        select 1
        from VehiculosPlazas
        where IdVehiculo = @IdVehiculo
        )
        begin
            ;throw 50014, 'El vehiculo ya tiene una plaza asignada.',1;
        end;
        insert into @TablaTemporal
        exec sp_PlazasLibres;
        select top 1 @IdPlaza = Id from @TablaTemporal;
        if @IdPlaza is null
        begin
        ;throw 50015, 'No hay plazas de estacionamiento disponibles.', 1;
        end;
        insert into VehiculosPlazas (IdVehiculo, IdPlazaDeEstacionamiento)
        values (@IdVehiculo, @IdPlaza);
        commit transaction;
        select @IdPlaza as PlazaAsignada;
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction;
        end;
        throw;
    end catch
end;
go

create procedure sp_RegistrarPago 
    @IdReserva int,
    @Metodo varchar(30),
    @Importe decimal(12,2),
    @Cuotas int,
    @Descripcion varchar(200),
    @Estado varchar(20)
as
begin
    begin try
        if not exists(
            select 1
            from Reservas
            where @IdReserva = IdReserva
        )
        begin 
            ;throw 50016, 'La reserva indicada no existe.',1;
        end;
        if @Importe <= 0 or @Importe is null
            begin
                ;throw 50017,'El importe del pago debe ser mayor a cero y no nulo.',1;
            end;
        if @Cuotas <= 0 or @Cuotas is null
            begin
                ;throw 50018,'La cantidad de cuotas debe ser mayor a cero y no nula.',1;
            end;
        insert into Pagos(IdReserva,Metodo,Importe,Cuotas,Descripcion,Estado)
        values (@IdReserva,@Metodo,@Importe,@Cuotas,@Descripcion,@Estado);
    end try
    begin catch
        throw;
    end catch
end;
go



       