USE GestionDeHotel;
GO

drop procedure if exists sp_EmpleadoLimpiezaLibre
GO

create procedure sp_EmpleadoLimpiezaLibre
as
begin
select top 1 e.IdEmpleado, e.Nombre from Empleados e
left join LimpiezasDeHabitaciones lh
on e.IdEmpleado = lh.IdEmpleado
group by e.IdEmpleado, e.Nombre
order by count(lh.IdLimpieza) asc;
end;
GO

update Habitaciones set Limpieza = 'Pendiente' where IdHabitacion in (1, 2, 3)

select IdHabitacion, Limpieza from Habitaciones where Limpieza = 'Pendiente'

declare @idlimpHabitacion int, @estado varchar(30), @empleado int
declare @empleadoLibre table (IdEmpleado int, Nombre nvarchar(50))
declare cur_limpiarHabitaciones cursor fast_forward for select IdHabitacion from Habitaciones

open cur_limpiarHabitaciones
fetch next from cur_limpiarHabitaciones  into @idlimpHabitacion
while @@FETCH_STATUS=0
begin
	select @estado = Habitaciones.Limpieza from Habitaciones
	where Habitaciones.IdHabitacion = @IdlimpHabitacion
	if @estado = 'Pendiente'
	begin
		delete from @empleadoLibre
		insert into @empleadoLibre exec sp_EmpleadoLimpiezaLibre
		set @empleado= null
		select @empleado = IdEmpleado from @empleadoLibre
		insert into LimpiezasdeHabitaciones (HorarioInicioLimpieza, HorarioFinLimpieza, IdEmpleado, IdHabitacion)
		VALUES (getdate(),dateadd(hour,1,getdate()), @empleado, @idlimpHabitacion);
		Update Habitaciones
		set Limpieza = 'Limpia'
		where Habitaciones.IdHabitacion = @idlimpHabitacion
 	end;
	fetch next from cur_limpiarHabitaciones  into @idlimpHabitacion
end;

close cur_limpiarHabitaciones;
deallocate cur_limpiarHabitaciones;

select IdHabitacion, Limpieza from Habitaciones where Limpieza = 'Pendiente'

select top 5 LimpiezasdeHabitaciones.IdHabitacion, Empleados.Nombre, LimpiezasdeHabitaciones.HorarioInicioLimpieza
from LimpiezasdeHabitaciones
inner join Empleados on Empleados.IdEmpleado = LimpiezasdeHabitaciones.IdEmpleado
order by LimpiezasdeHabitaciones.IdLimpieza desc
GO
