use GestionDeHotel
go

select nombreServicio, precioTotal from ServiciosExtra
where precioTotal > (select AVG(precioTotal) from ServiciosExtra
);

select Nombre, Sueldo from Empleados
where Sueldo > (select Avg(Sueldo) from Empleados
);

select IdReserva, Importe from Reservas
where Importe > (select max(Importe) from Reservas where FechaReserva between '2023-01-01' and '2023-12-31'
);

select IdHabitacion, Piso from Habitaciones h
inner join tiposdeHabitacion th
on h.IdTipo = th.idTipoHabitacion
where th.costoHabitacion = (select max(costoHabitacion) from tiposdeHabitacion
); 

select nombreHuesped, correoHuesped from Huespedes h
where not exists (
select idHuesped from vehiculos v
where h.idHuesped = v.idHuesped
);

select Nombre, DNI, Correo from Empleados e
inner join LimpiezasdeHabitaciones l
on e.IdEmpleado = l.idEmpleado
group by e.Nombre, e.DNI, e.Correo, e.IdEmpleado
having count(l.idLimpieza) = (select max(CantidadLimpiezas)
from (
select count(idLimpieza) as CantidadLimpiezas from LimpiezasdeHabitaciones
group by IdEmpleado) as Limpiezas );