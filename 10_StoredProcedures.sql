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
where Estado = 'Disponible' and Limpieza = 'Limpia'
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

    BEGIN TRY
        BEGIN TRANSACTION;
        if not exists (
        select 1
        from Reservas
        where IdReserva = @IdReserva and Estado = 'Confirmada'
        )
        begin
            ;throw 50021, 'La reserva debe estar confirmada para realizar el check-in.',1;
        end;
        if not exists (
            select 1
            from Reservas
            where IdReserva = @IdReserva and FechaEntrada = CAST(GETDATE() as DATE)
        )
        Begin
            ;throw 50022,'El check-in debe realizarse en la fecha de entrada de la reserva.',1;
        end;
        if exists (
            select 1
            from Estadias
            Where IdReserva = @IdReserva and (FechaHoraCheckIn is not null or Estado in ('En curso','Finalizada'))
        )
        begin
            ;throw 50023, 'La reserva ya tiene un check-in registrado.',1;
        end;
        select @IdHabitacion = @IdHabitacion
        from Reservas
        where IdReserva = @IdReserva;

        if @IdHabitacion is null
        begin 
            ;throw 50012,'La reserva no tiene una habitacion asignada.',1;
        end;
        if not exists (
            select 1
            from Habitaciones 
            where IdHabitacion = @IdHabitacion and Estado in ('Disponible', 'Reservada') and Limpieza = 'Limpia'
           )
        begin 
            ;throw;50019, 'La habitacion reservada no esta disponible para el check-in',1;
        end;
        select @CantidadHuespedes = count(*)
        from ReservasHuespedes
        where IdReserva = @IdReserva;
        if exists (
            select 1
            from Habitaciones H
            inner join TiposDeHabitacion T
                on H.IdTipoHabitacion = T.IdTipoHabitacion
            where H.IdHabitacion = @IdHabitacion
                and @CantidadHuespedes > t.CapacidadHabitacion
            )
        begin
            ;throw 50020, 'La cantidad de huespedes supera la capacidad de la habitacion.',1;
        end;
        if exists(
            select 1
            from Estadias
            where IdReserva = @IdReserva
           )
        BEGIN
            update Estadias
            set FechaHoraCheckIn = GETDATE(), Estado = 'En curso', FechaHoraCheckOut = null
            where IdReserva = @IdReserva;
        END
        ELSE
        begin 
            insert into Estadias
                (IdReserva,FechaHoraCheckIn,FechaHoraCheckOut,Estado)
            Values
                (@IdReserva,GETDATE(), null,'En curso')
        end;
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



       