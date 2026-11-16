use GestionDeHotel
go

select NombreServicio, ValorUnitario from ServiciosExtra
where ValorUnitario > (select AVG(ValorUnitario) from ServiciosExtra
);

select Nombre, Sueldo from Empleados
where Sueldo > (select Avg(Sueldo) from Empleados
);

select IdReserva, PrecioPorNoche * DATEDIFF(DAY, FechaEntrada, FechaSalida) as ImporteCalculado
from Reservas
where PrecioPorNoche * DATEDIFF(DAY, FechaEntrada, FechaSalida) > (
    select MAX(PrecioPorNoche * DATEDIFF(DAY, FechaEntrada, FechaSalida))
    from Reservas
    where FechaReserva BETWEEN '2026-09-01' AND '2026-09-30'
);

select IdHabitacion, Piso from Habitaciones h
inner join TiposDeHabitacion th
on h.IdTipoHabitacion = th.idTipoHabitacion
where th.CostoHabitacion = (select max(CostoHabitacion) from TiposDeHabitacion
); 

select NombreHuesped, CorreoHuesped from Huespedes h
where not exists (
select IdHuesped from Vehiculos v
where h.IdHuesped = v.IdHuesped
);

select Nombre, DNI, Correo from Empleados e
inner join LimpiezasdeHabitaciones l
on e.IdEmpleado = l.idEmpleado
group by e.Nombre, e.DNI, e.Correo, e.IdEmpleado
having count(l.IdLimpieza) = (select max(CantidadLimpiezas)
from (
select count(IdLimpieza) as CantidadLimpiezas from LimpiezasdeHabitaciones
group by IdEmpleado) as Limpiezas );