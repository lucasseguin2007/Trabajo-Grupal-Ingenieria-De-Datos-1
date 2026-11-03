Use GestionDeHotel;
GO
create table Empleados 
	(IdEmpleado int primary key identity (1,1),
	DNI int unique not null,
	Nombre nvarchar(50) not null,
	Correo nvarchar(50) unique not null,
	Sueldo decimal (10,2) not null,
	HorasSemanales int not null);

create table HorarioEmpleado (
	IdHorarioEmpleado int primary key identity (1,1),
	IdEmpleado int, 
	foreign key (IdEmpleado) references Empleados (IdEmpleado),
	DiaSemana nvarchar(15) not null,
	constraint ValidarDia check (DiaSemana in ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
	HoraEntrada Time not null,
	HoraSalida Time not null);

	

create table Habitaciones
	(IdHabitacion int primary key identity (1,1),
	Estado Varchar(15),
	Limpieza Varchar(30),
	Piso int,
	IdTipo int not null);

create table Reservas (
	IdReserva int primary key identity (1,1),
	FechaReserva date not null,
	Estado varchar(30),
	FechaEntrada date not null,
	FechaSalida date not null,
	Importe decimal(12,2),
	Subtotal decimal(12,2),
	IdHabitacion int,
	foreign key (IdHabitacion) references Habitaciones(IdHabitacion),
	CantidadHuespedes int,
	PrecioPorNoche decimal(10,2));

create table Estadias (
	IdEstadia int primary key identity(1,1),
	FechaHoraCheckIn datetime2,
	Estado varchar(30),
	FechaHoraCheckOut datetime2,
	IdReserva int unique not null,
	foreign key (IdReserva) references Reservas(IdReserva));


create table categorias(
idCategoria INT primary key identity(1,1),
nombredeCategoria nvarchar(30) not null
)


create table Productos(
idProducto INT Primary key identity(1,1),
nombreProducto nvarchar(30) not null,
idCategoria INT not null,
foreign key (idCategoria) references Categorias (idCategoria),
stock int not null,
precio money not null
)


create table huespedes (
idHuesped int primary key identity(1,1),
nombreHuesped nvarchar(50) not null,
correoHuesped nvarchar(60),
fechaNacimiento date not null,
numTelefono nvarchar(15)
)
create table ReservasHuespedes(
idReserva int not null,
foreign key (idReserva) references Reservas (idReserva),
idHuesped int not null,
foreign key (idHuesped) references Huespedes (idHuesped),
primary key (idReserva, idHuesped),
esTitular bit not null
)
CREATE TABLE PlazasDeEstacionamiento (
	IdPlazaDeEstacionamiento INT  PRIMARY KEY IDENTITY(1,1),
	Estado nvarchar(20) NOT NULL,
	CONSTRAINT DisponibilidadDeEstacionamiento CHECK (Estado IN ('Disponible', 'Ocupada'))
	)
create table vehiculos(
idVehiculo int primary key identity(1,1),
idHuesped int not null,
foreign key (idHuesped) references Huespedes (idHuesped),
marcaVehiculo nvarchar(20) not null,
modeloVehiculo nvarchar(20) not null,
colorVehiculo nvarchar(20) not null,
patenteVehiculo nvarchar(15) unique not null,
IdPlazaDeEstacionamiento int not null,
foreign key (IdPlazaDeEstacionamiento) references PlazasDeEstacionamiento (IdPlazaDeEstacionamiento)
)

create table tiposdeHabitacion(
idTipoHabitacion int primary key identity(1,1),
nombreTipo nvarchar(30) not null,
costoHabitacion money not null,
capacidadHabitacion int not null,
cantidadHabitaciones int not null
)

create table LimpiezasdeHabitaciones(
idLimpieza int primary key identity(1,1),
horarioInicioLimpieza time not null,
horarioFinLimpieza time not null,
fechaLimpieza date not null,
idEmpleado int not null,
foreign key (idEmpleado) references Empleados (idEmpleado),
idHabitacion int not null,
foreign key (idHabitacion) references Habitaciones (idHabitacion)
)


CREATE TABLE Facturas (
	IdFactura INT PRIMARY KEY IDENTITY(1,1),
	IdEmpleado INT NOT NULL,
	FOREIGN KEY(IdEmpleado) REFERENCES Empleados(IdEmpleado),
	FechaEmision DATE NOT NULL,
	IdReserva INT NOT NULL,
	FOREIGN KEY(IdReserva) REFERENCES Reservas(IdReserva),
	TipoComprobante varchar(30) NOT NULL,
	)

CREATE TABLE Pagos (
	IdPago INT PRIMARY KEY IDENTITY(1,1),
	IdReserva INT NOT NULL,
	FOREIGN KEY (IdReserva) REFERENCES Reservas(IdReserva),
	Metodo Varchar(30) NOT NULL,
	Importe Decimal(12,2) NOT NULL,
	Constraint PagoImporte CHECK (Importe >= 0),
	Cuotas INT NOT NULL DEFAULT 1,
	Constraint PagoCuotas CHECK (Cuotas >= 1),
	Descripcion Varchar(200),
	Estado Varchar(20) NOT NULL,
	)

CREATE TABLE DetallesFactura (
	IdDetalleFactura INT PRIMARY KEY IDENTITY(1,1),
	IdFactura INT NOT NULL,
	FOREIGN KEY (IdFactura) REFERENCES Facturas(IdFactura),
	Subtotal DECIMAL(12,2) NOT NULL,
	Impuesto DECIMAL(12,2) NOT NULL,
	Estado Varchar(20) NOT NULL,
	Total Decimal(12,2) NOT NULL,
	PrecioUnitario DECIMAL(12,2) NOT NULL,
	Cantidad INT NOT NULL,
	CONSTRAINT ValidarCantidadDetalleFactura CHECK (Cantidad > 0),
	)


CREATE TABLE Gastos (
	IdGasto INT PRIMARY KEY IDENTITY(1,1),
	IdEmpleado INT NOT NULL,
	FOREIGN KEY(IdEmpleado) REFERENCES Empleados(IdEmpleado),
	FechaGasto DATE NOT NULL,
	Monto Decimal(12,2) NOT NULL,
	Estado Varchar(20) NOT NULL,
	CategoriaGasto Varchar(30) NOT NULL,
	CONSTRAINT ValidarCategoriaGasto CHECK (CategoriaGasto IN ('Mantenimiento','Insumos','Servicios','Administracion')),
	CONSTRAINT ValidarMonto CHECK (Monto > 0),
	);

CREATE TABLE ConsumosDeHuesped (
	IdHuesped INT NOT NULL,
	IdConsumo INT NOT NULL,
	FechaConsumo DATE NOT NULL,
	CONSTRAINT ConsumoDeHuesped PRIMARY KEY (IdHuesped,IdConsumo),
	)
create table ProductosPorConsumo (
IdConsumo int primary key identity(1 ,1),
Idproducto int,
foreign key (IdProducto) references Productos(IdProducto),
cantidad int  not null,
precioTotal int not null)
go
create table SolicitudesDeMantenimiento (
IdSolicitud int primary key identity(1,1),
IdEmpleado int,
foreign key (IdEmpleado) references Empleados(IdEmpleado),
fecha date not null,
estado nvarchar(20) not null default 'En espera',
constraint ValidarEstado check (estado in('En espera', 'En proceso','Finalizada')),
area nvarchar(25),
constraint ValidarArea check (area in('Mantenimiento general','Electricidad','Plomeria','Gas','Conexion')),
descripcion nvarchar(100),
lugar nvarchar(50) not null, 
equipo nvarchar(50))
go
create table RegistrosDeAsistencia(
IdAsitencia int primary key identity(1,1),
IdEmpleado int,
foreign key (IdEmpleado) references Empleados(IdEmpleado),
horaEntrada time not null,
horaSalida time not null,
fecha date not null)
go
create table ServiciosExtra(
IdServicio int primary key identity(1,1),
nombreServicio nvarchar(30),
precioTotal int not null,
horario time)
go
create table ConsumosServiciosExtra(
IdConsumoServicio int primary key identity (1,1),
precio int not null,
IdServicio int,
foreign key (IdServicio) references ServiciosExtra(IdServicio),
IdEstadia int,
foreign key (IdEstadia) references Estadias(IdEstadia)
);
go

