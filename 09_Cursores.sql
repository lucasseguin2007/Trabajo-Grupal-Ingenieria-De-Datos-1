Use GestionDeHotel;
GO

--Calcular lo que gasto cada huesped en comparacion a sus dias de estadia

DECLARE @IdHuesped INT;

DECLARE calcGastoProm CURSOR FAST_FORWARD FOR
SELECT IdHuesped FROM Huespedes;

OPEN calcGastoProm;
FETCH NEXT FROM calcGastoProm INTO @IdHuesped;

WHILE @@fetch_status = 0
BEGIN
	DECLARE @Dias int, @Gasto decimal(12,2), @GastoPorDia decimal(12,2)
	select @Dias = isnull(SUM(DATEDIFF(day ,Estadias.FechaHoraCheckIn, ISNULL(Estadias.FechaHoraCheckOut,getdate()))),0)
	from ReservasHuespedes
	inner join Estadias ON Estadias.IdReserva = ReservasHuespedes.IdReserva
	where ReservasHuespedes.IdHuesped = @IdHuesped;
	select @Gasto = isnull(sum(ProductosPorConsumo.Cantidad * Productos.Precio),0)
	from ConsumosDeHuesped
	inner join ProductosPorConsumo ON ProductosPorConsumo.IdConsumo = ConsumosDeHuesped.IdConsumo
	inner join Productos ON Productos.IdProducto = ProductosPorConsumo.IdProducto
	Where ConsumosDeHuesped.IdHuesped = @IdHuesped;

	if @Dias = 0
		set @GastoPorDia = 0
	else
		set @GastoPorDia = @Gasto/@Dias;

	PRINT('El huesped de id: '+ cast(@IdHuesped as NVARCHAR) + ' estuvo ' + CAST(@Dias as NVARCHAR) + ' dias y gasto: ' + CAST(@Gasto as NVARCHAR) + ' y su gasto por dia fue: ' + CAST(@GastoPorDia as NVARCHAR))
	fetch next from calcGastoProm INTO @IdHuesped
	END;

	close calcGastoProm;
	deallocate calcGastoProm;

--Calcular que empleado hizo facturas por mas plata

declare @IdEmpleado INT, @maxTotal decimal(12,2), @IdEmpleadomax int
set @maxTotal = -1
set @IdEmpleado = -1
declare masPlataxFactEmpleado CURSOR FAST_FORWARD for select IdEmpleado FROM Empleados

open masPlataxFactEmpleado;

fetch next from masPlataxFactEmpleado into @IdEmpleado

while @@FETCH_STATUS = 0
begin
	declare @Total decimal(12,2)
	select @Total = isnull(sum(DetallesFactura.PrecioUnitario * DetallesFactura.Cantidad + DetallesFactura.Impuesto),0) from Facturas
	inner join DetallesFactura on DetallesFactura.IdFactura = Facturas.IdFactura
	where Facturas.IdEmpleado = @IdEmpleado and DetallesFactura.Estado <> 'Anulada'

	if @Total >= @maxTotal
	begin
	 set @maxTotal= @Total
	 set @IdEmpleadomax = @IdEmpleado
	end;
	fetch next from masPlataxFactEmpleado into @IdEmpleado
end;

PRINT('El empleado que mas facturo fue ' + cast(@IdEmpleadomax as nvarchar)+ ' con ' + CAST(@MaxTotal as NVARCHAR))

close masPlataxFactEmpleado;
deallocate masPlataxFactEmpleado;


--Agregar 10% de costo a las reservas que su estadia termino despues del fin de su reserva

declare @IdReserva int, @fechasalida date, @fechasalidaprometida date

declare agregarCostoMulta CURSOR FAST_FORWARD for select IdReserva from Reservas

open agregarCostoMulta

fetch next from agregarCostoMulta into @IdReserva

while @@FETCH_STATUS = 0
begin
	set @fechasalida = null
	set @fechasalidaprometida = null
	select @fechasalida = Estadias.FechaHoraCheckOut from Reservas
	inner join Estadias on Estadias.IdReserva = Reservas.IdReserva
	where @IdReserva = Reservas.IdReserva

	select @fechasalidaprometida = Reservas.FechaSalida from Reservas
	where Reservas.IdReserva = @IdReserva
	if (@fechasalida>@fechasalidaprometida)
	begin
		Update Reservas
		set PrecioPorNoche = PrecioPorNoche*1.10
		where Reservas.IdReserva = @IdReserva
	end

	fetch next from agregarCostoMulta into @IdReserva
end;

close agregarCostoMulta;
deallocate agregarCostoMulta;

--actualizar habitaciones(si tienen estadia en curso ocupado sino disponible, si tiene reserva futura reservada

declare @IdHabitacion int, @ahora int, @futuras int

declare actualizarHabitaciones cursor fast_forward for
select IdHabitacion from Habitaciones

open actualizarHabitaciones

fetch next from actualizarHabitaciones into @IdHabitacion

while @@FETCH_STATUS = 0
begin
	select @ahora = count(*) from Estadias
	inner join Reservas on Reservas.IdReserva = Estadias.IdReserva
	WHERE Reservas.IdHabitacion = @IdHabitacion and Estadias.Estado = 'En curso'
	select @futuras = count(*) from Reservas
	where IdHabitacion = @IdHabitacion and FechaEntrada > getdate() and Estado in ('Confirmada','Pendiente')
	if @ahora > 0
		update Habitaciones set Estado = 'Ocupada' where IdHabitacion = @IdHabitacion
	else if @futuras > 0
		update Habitaciones set Estado = 'Reservada' where IdHabitacion = @IdHabitacion
	else
		update Habitaciones set Estado = 'Disponible' where IdHabitacion = @IdHabitacion

	fetch next from actualizarHabitaciones into @IdHabitacion
end;

close actualizarHabitaciones;
deallocate actualizarHabitaciones;

--crear tareas de limpieza a habitaciones sucias
declare @idlimpHabitacion int, @estado varchar(30), @empleado int
declare @empleadoLibre table (IdEmpleado int, Nombre nvarchar(50))
declare limpiarHabitaciones cursor fast_forward for select IdHabitacion from Habitaciones

open limpiarHabitaciones
fetch next from limpiarHabitaciones  into @idlimpHabitacion
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
	fetch next from limpiarHabitaciones  into @idlimpHabitacion
end;

close limpiarHabitaciones;
deallocate limpiarHabitaciones;