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
end;
go
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
insert into @TablaTemporal
exec sp_PlazasLibres;
select top 1 @IdPlaza = Id from @TablaTemporal;
if @IdPlaza is null
begin
    ;throw 50007, 'No hay plazas de estacionamiento disponibles.', 1;
end;
insert into VehiculosPlazas (IdVehiculo, IdPlazaDeEstacionamiento)
values (@IdVehiculo, @IdPlaza);
update PlazasDeEstacionamiento
set Estado = 'Ocupada'
where IdPlazaDeEstacionamiento = @IdPlaza;
select @IdPlaza as PlazaAsignada;
end;
go