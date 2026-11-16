--Cancelar las reservas pendientes cuya fecha de entrada ya paso
 
declare @IdReservaVencida int
 
declare cur_cancelarReservasVencidas CURSOR FAST_FORWARD for
select IdReserva from Reservas
where Estado = 'Pendiente' and FechaEntrada < getdate()
 
open cur_cancelarReservasVencidas
 
fetch next from cur_cancelarReservasVencidas into @IdReservaVencida
 
while @@FETCH_STATUS = 0
begin
	Update Reservas
	set Estado = 'Cancelada'
	where Reservas.IdReserva = @IdReservaVencida
 
	PRINT('Se cancelo la reserva de id: ' + cast(@IdReservaVencida as NVARCHAR) + ' porque estaba pendiente y su fecha de entrada ya paso')
	fetch next from cur_cancelarReservasVencidas into @IdReservaVencida
end;
 
close cur_cancelarReservasVencidas;
deallocate cur_cancelarReservasVencidas;
 
 
--Hacer el check-out automatico de las estadias en curso que ya pasaron su fecha de salida, y dejar la habitacion pendiente de limpieza
 
declare @IdEstadiaVencida int, @IdHabitacionVencida int
 
declare cur_checkOutAutomatico CURSOR FAST_FORWARD for
select Estadias.IdEstadia, Reservas.IdHabitacion from Estadias
inner join Reservas on Reservas.IdReserva = Estadias.IdReserva
where Estadias.Estado = 'En curso' and Reservas.FechaSalida < getdate()
 
open cur_checkOutAutomatico
 
fetch next from cur_checkOutAutomatico into @IdEstadiaVencida, @IdHabitacionVencida
 
while @@FETCH_STATUS = 0
begin
	Update Estadias
	set FechaHoraCheckOut = getdate(), Estado = 'Finalizada'
	where Estadias.IdEstadia = @IdEstadiaVencida
 
	Update Habitaciones
	set Limpieza = 'Pendiente'
	where Habitaciones.IdHabitacion = @IdHabitacionVencida
 
	PRINT('Check-out automatico de la estadia de id: ' + cast(@IdEstadiaVencida as NVARCHAR) + ' en la habitacion de id: ' + cast(@IdHabitacionVencida as NVARCHAR))
	fetch next from cur_checkOutAutomatico into @IdEstadiaVencida, @IdHabitacionVencida
end;
 
close cur_checkOutAutomatico;
deallocate cur_checkOutAutomatico;
 
 
--Reporte de ocupacion por habitacion (cantidad de estadias y dias ocupada)
 
declare @IdHabitacionRep int, @CantEstadias int, @DiasOcupada int
 
declare cur_reporteOcupacion CURSOR FAST_FORWARD for
select IdHabitacion from Habitaciones
 
open cur_reporteOcupacion
 
fetch next from cur_reporteOcupacion into @IdHabitacionRep
 
while @@FETCH_STATUS = 0
begin
	select @CantEstadias = count(*),
	@DiasOcupada = isnull(SUM(DATEDIFF(day, Estadias.FechaHoraCheckIn, ISNULL(Estadias.FechaHoraCheckOut,getdate()))),0)
	from Estadias
	inner join Reservas on Reservas.IdReserva = Estadias.IdReserva
	where Reservas.IdHabitacion = @IdHabitacionRep
 
	PRINT('La habitacion de id: ' + cast(@IdHabitacionRep as NVARCHAR) + ' tuvo ' + CAST(@CantEstadias as NVARCHAR) + ' estadias y estuvo ocupada ' + CAST(@DiasOcupada as NVARCHAR) + ' dias')
	fetch next from cur_reporteOcupacion into @IdHabitacionRep
end;
 
close cur_reporteOcupacion;
deallocate cur_reporteOcupacion;
 
 --Reporte de consumo por producto
 
declare @IdProductoRep int, @UnidadesConsumidas int, @TotalGenerado decimal(12,2)
 
declare cur_reporteProductos CURSOR FAST_FORWARD for
select IdProducto from Productos
 
open cur_reporteProductos
 
fetch next from cur_reporteProductos into @IdProductoRep
 
while @@FETCH_STATUS = 0
begin
	select @UnidadesConsumidas = isnull(SUM(ProductosPorConsumo.Cantidad),0),
	@TotalGenerado = isnull(SUM(ProductosPorConsumo.Cantidad * Productos.Precio),0)
	from ProductosPorConsumo
	inner join Productos on Productos.IdProducto = ProductosPorConsumo.IdProducto
	where ProductosPorConsumo.IdProducto = @IdProductoRep
 
	PRINT('El producto de id: ' + cast(@IdProductoRep as NVARCHAR) + ' se consumio ' + CAST(@UnidadesConsumidas as NVARCHAR) + ' veces y genero: ' + CAST(@TotalGenerado as NVARCHAR))
	fetch next from cur_reporteProductos into @IdProductoRep
end;
 
close cur_reporteProductos;
deallocate cur_reporteProductos;
 


--crear tareas de limpieza a habitaciones sucias
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