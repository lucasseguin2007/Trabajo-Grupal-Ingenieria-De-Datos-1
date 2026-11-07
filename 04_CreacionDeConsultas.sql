use GestionDeHotel

-- ver habitaciones disponibles
select
    IdHabitacion,
    IdTipoHabitacion,
    Piso,
    Estado,
    Limpieza
from Habitaciones
where Estado = 'Disponible'
order by Piso asc, IdHabitacion asc;

-- ver las reservas entre noviembre y diciembre 2026
select
    IdReserva,
    FechaReserva,
    FechaEntrada,
    FechaSalida,
    Estado,
    CantidadHuespedes
from Reservas
where FechaEntrada >= '2026-11-01' and FechaEntrada <= '2026-11-30'
order by FechaEntrada asc;

-- ver productos con poco stock
select
    IdProducto,
    nombreProducto,
    Stock,
    Precio
from Productos
where Stock <= 10
order by Stock asc;

-- mostrar habitaciones y tipo de habitación
select
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    R.Estado,
    H.IdHabitacion,
    H.Piso,
    TH.NombreTipo,
    TH.CapacidadHabitacion
from Reservas R
inner join Habitaciones H on R.IdHabitacion = H.IdHabitacion
inner join tiposdeHabitacion TH on H.IdTipoHabitacion = TH.IdTipoHabitacion
order by R.FechaEntrada asc;

-- que huespédes estan asociados a cada reserva
select
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    H.IdHuesped,
    H.nombreHuesped,
    H.correoHuesped,
    H.NumeroDeTelefono
from Reservas R
inner join ReservasHuespedes RH on R.IdReserva = RH.IdReserva
inner join Huespedes H on RH.IdHuesped = H.IdHuesped
order by R.IdReserva asc, H.nombreHuesped asc;

-- consultar estadias y sus reservas
select
    E.IdEstadia,
    E.FechaHoraCheckIn,
    E.FechaHoraCheckOut,
    E.Estado as EstadoEstadia,
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    R.IdHabitacion
from Estadias E
inner join Reservas R on E.IdReserva = R.IdReserva
order by E.FechaHoraCheckIn desc;

-- consultar tareas de limpieza por empleado (SACAR)
select
    L.IdLimpieza,
    E.IdEmpleado,
    E.Nombre,
    H.IdHabitacion,
    H.Piso,
    L.HorarioInicioLimpieza,
    L.HorarioFinLimpieza
from LimpiezasdeHabitaciones L
inner join Empleados E on L.IdEmpleado = E.IdEmpleado
inner join Habitaciones H on L.IdHabitacion = H.IdHabitacion
order by L.HorarioFinLimpieza desc;

--consultar los consumos que realizaron los huespedes
select
    H.IdHuesped,
    H.nombreHuesped,
    C.IdConsumo,
    C.FechaConsumo,
    P.NombreProducto as Producto,
    PC.Cantidad
from ConsumosdeHuesped C
inner join Huespedes H on C.IdHuesped = H.IdHuesped
inner join ProductosPorConsumo PC on C.IdConsumo = PC.IdConsumo
inner join Productos P on PC.IdProducto = P.IdProducto
order by C.FechaConsumo desc;


-- cuantas reservas hay por tipo de habitacion
select
    TH.idTipoHabitacion,
    TH.NombreTipo,
    count(R.IdReserva) as CantidadReservas
from TiposdeHabitacion TH
inner join Habitaciones H on TH.idTipoHabitacion = H.IdTipoHabitacion
inner join Reservas R on H.IdHabitacion = R.IdHabitacion
group by    TH.idTipoHabitacion,
    TH.NombreTipo
order by CantidadReservas desc;

--cuanto gasto un huespéd en productos
select
    H.IdHuesped,
    H.NombreHuesped,
    sum(PC.Cantidad * P.Precio) as TotalGastado
from Huespedes H
inner join ConsumosDeHuesped C on H.IdHuesped = C.IdHuesped
inner join ProductosPorConsumo PC on C.IdConsumo = PC.IdConsumo
inner join Productos P on PC.Idproducto = P.IdProducto
group by
    H.IdHuesped,
    H.nombreHuesped
order by TotalGastado desc;

-- cuantos ingresos hubo por reservas
select
    year(R.FechaReserva) as Anio,
    month(R.FechaReserva) as Mes,
    sum(R.PrecioPorNoche * DATEDIFF(day, R.FechaEntrada, R.FechaSalida)) as IngresosReservas
from Reservas R
group by
    year(R.FechaReserva),
    month(R.FechaReserva)
order by    
Anio asc,
Mes asc;

--calcular precio promedio por categoria
select
    C.IdCategoria,
    C.NombreDeCategoria,
    count(P.IdProducto) as CantidadProductos,
    avg(P.Precio) as PrecioPromedio,
    min(P.Precio) as PrecioMinimo,
    max(P.Precio) as PrecioMaximo
from Categorias C
inner join Productos P on C.IdCategoria = P.IdCategoria
group by    C.IdCategoria,
    C.NombreDeCategoria
order by PrecioPromedio desc;

-- encontrar huespedes que realizaron mas de una reserva
select
    H.IdHuesped,
    H.nombreHuesped,
    count(distinct RH.IdReserva) as CantidadReservas
from Huespedes H
inner join ReservasHuespedes RH on H.IdHuesped = RH.IdHuesped
group by
    H.IdHuesped,
    H.nombreHuesped
having count(distinct RH.IdReserva) > 1
order by CantidadReservas desc;

-- identificar que productos tienen mayor demanda
select
    P.IdProducto,
    P.nombreProducto,
    sum(PC.Cantidad) as CantidadConsumida
from Productos P
inner join ProductosPorConsumo PC on P.IdProducto = PC.IdProducto
group by
    P.IdProducto,
    P.nombreProducto
having sum(PC.Cantidad) >= 5
order by CantidadConsumida desc;

--clasificar reservas segun su estado
select
    IdReserva,
    FechaEntrada,
    FechaSalida,
    Estado,
    case
        when FechaSalida < cast(getdate() as date)
            then 'Finalizada'

        when FechaEntrada <= cast(getdate() as date)
             AND FechaSalida > cast(getdate() as date)
            then 'En curso'

        else 'Pendiente'
    end as SituacionReserva
from Reservas
order by FechaEntrada asc;

-- encontrar habitaciones que nunca tuvieron reservas
select
    H.IdHabitacion,
    H.IdTipoHabitacion,
    H.Piso,
    H.Estado
from Habitaciones H
where not exists (
    select 1
    from Reservas R
    where R.IdHabitacion = H.IdHabitacion
)
order by H.Piso asc;

--buscar habitaciones disponibles en un periodo especifico (no tienen reserva que se superponga con las fechas solicitadas
declare @FechaEntrada date = '2026-11-10';
declare @FechaSalida date = '2026-11-15';

select
    H.IdHabitacion,
    H.IdTipoHabitacion,
    H.Piso,
    H.Estado
from Habitaciones H
where not exists (
    select 1
    from Reservas R
    where R.IdHabitacion = H.IdHabitacion and R.FechaEntrada < @FechaSalida and R.FechaSalida > @FechaEntrada
)
order by H.Piso, H.IdHabitacion;

--reservas sin pagos registrados
select
    R.IdReserva,
    R.FechaEntrada,
    R.FechaSalida,
    R.PrecioPorNoche * DATEDIFF (day, R.FechaEntrada, R.FechaSalida) as ImporteCalculado,
    R.Estado
from Reservas R
left join Pagos P on R.IdReserva = P.IdReserva
where P.IdPago is null;

-- cuanto cobro el hotel por metodo de pago
select
    Metodo,
    count(IdPago) as CantidadPagos,
    sum(Importe) as TotalRecaudado
from Pagos
group by Metodo
order by TotalRecaudado desc;

--gastos por categoria
select
    CategoriaGasto,
    count(IdGasto) as CantidadGastos,
    sum(Monto) as TotalGastado
from Gastos
group by CategoriaGasto
order by TotalGastado desc;

--calcular las horas trabajadas de cada empleado
select
    E.IdEmpleado,
    E.Nombre,
    sum(datediff(minute, A.HoraEntrada, A.HoraSalida)) / 60.0
        as HorasTrabajadas
from Empleados E
inner join RegistrosDeAsistencia A on E.IdEmpleado = A.IdEmpleado
group by
    E.IdEmpleado,
    E.Nombre
order by HorasTrabajadas desc;


--consultar estados de problemas del hotel

select
    S.IdSolicitud,
    E.Nombre as Empleado,
    S.Fecha,
    S.Area,
    S.Lugar,
    S.Equipo,
    S.Descripcion,
    S.Estado
from SolicitudesDeMantenimiento S
inner join Empleados E on S.IdEmpleado = E.IdEmpleado
where S.Estado = 'En Proceso' or S.Estado = 'En Espera' or S.Estado = 'Finalizada'
order by S.Fecha asc;

-- ver que servicios adicionales son mas usados
select
    S.IdServicio,
    S.NombreServicio,
    count(*) as CantidadUsos
from ServiciosExtra S
inner join ConsumosServiciosExtra C
    on S.IdServicio = C.IdServicio
group by
    S.IdServicio,
    S.NombreServicio
order by CantidadUsos desc;

