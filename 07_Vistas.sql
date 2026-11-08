use GestionDeHotel;

--Ver informacion completa de las reservas

Create view vw_ReservasDetalle as
Select
	R.IdReserva,
	R.FechaReserva,
	R.FechaEntrada,
	R.FechaSalida,
	R.Estado as EstadoReserva,
	R.CantidadHuespedes,
	R.PrecioPorNoche,
	DATEDIFF(day, R.FechaEntrada, R.FechaSalida) as CantidadNoches,
	R.PrecioPorNoche * DATEDIFF(day, R.FechaEntrada, R.FechaSalida) as ImporteCalculado,
	H.IdHabitacion,
	H.Piso,
	H.Estado as EstadoHabitacion,
	T.NombreTipo,
	T.CapacidadHabitacion
	From Reservas R
	inner join Habitaciones h on R.IdHabitacion = H.IdHabitacion
	inner join TiposDeHabitacion T on H.IdTipoHabitacion = T.IdTipoHabitacion;

	-- ver reservas en suites
	Select * From vw_ReservasDetalle Where NombreTipo = 'Suite';


--Estado de cuenta de las reservas 

create or alter view vw_EstadoCuentaReservas as
select
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    R.Estado as EstadoReserva,
    R.PrecioPorNoche * DATEDIFF(day, R.FechaEntrada, R.FechaSalida) as ImporteReserva,
    count(P.IdPago) as CantidadPagos,
    coalesce(sum(P.Importe), 0) as TotalPagado,
    (R.PrecioPorNoche * DATEDIFF(day, R.FechaEntrada, R.FechaSalida)) - coalesce(sum(P.Importe), 0) as SaldoPendiente
from Reservas R
left join Pagos P on R.IdReserva = P.IdReserva
group by
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    R.Estado,
    R.PrecioPorNoche;

Select * From vw_EstadoCuentaReservas where SaldoPendiente > 0;

create or alter view vw_GastosMensuales as
Select
	year(G.FechaGasto) as Anio,
	month(G.FechaGasto) as Mes,
	G.CategoriaGasto,
	count (G.IdGasto) as CantidadGastos,
	Sum(G.Monto) as TotalGastado,
	avg(G.Monto) as PromedioGasto
	from Gastos G
	group by year(G.FechaGasto), Month(G.FechaGasto), G.CategoriaGasto;

-- conocer gastos de noviembre
	select * from vw_GastosMensuales where Anio = 2026 and Mes = 11;

--ver categorias donde mas se gasto
	select CategoriaGasto, sum(TotalGastado) as TotalPorCategoria from vw_GastosMensuales
	group by CategoriaGasto
	order by TotalPorCategoria desc;


--Consumos realizados por cada huesped
create or alter view vw_ConsumosHuespedes as
Select H.IdHuesped, H.NombreHuesped, 
count(distinct C.IdConsumo) as CantidadConsumos,
Sum(PC.Cantidad * P.Precio) as TotalGastado
From Huespedes H
inner join ConsumosDeHuesped C on H.IdHuesped = C.IdConsumo
inner join ProductosPorConsumo PC on C.IdConsumo = PC.IdConsumo
inner join Productos P on PC.Idproducto = P.IdProducto
group by H.IdHuesped, H.NombreHuesped;

--ver que huesped gasto mas
select * from vw_ConsumosHuespedes order by TotalGastado Desc;

-- Historial de estadias
create VIEW vw_HistorialEstadias as
select
    E.IdEstadia,
    E.IdReserva,
    E.FechaHoraCheckIn,
    E.FechaHoraCheckOut,
    E.Estado as EstadoEstadia,
    R.IdHabitacion,
    R.FechaEntrada,
    R.FechaSalida,
    case
        when E.FechaHoraCheckOut IS NULL
            then DATEDIFF(hour, E.FechaHoraCheckIn, getdate())
        else DATEDIFF(hour, E.FechaHoraCheckIn, E.FechaHoraCheckOut)
    end as HorasEstadia
from Estadias E
inner join Reservas R on E.IdReserva = R.IdReserva;

--consultar estadias mas largas
select * from vw_HistorialEstadias
order BY HorasEstadia desc;
