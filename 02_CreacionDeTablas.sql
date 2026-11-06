Use GestionDeHotel;
GO
create table Empleados (
IdEmpleado int primary key identity (1,1),
Dni int unique not null,
Nombre nvarchar(50) not null,
Correo nvarchar(50) unique not null,
Sueldo decimal (10,2) not null,
HorasSemanales int not null);
GO
create table HorarioEmpleado (
IdHorarioEmpleado int primary key identity (1,1),
IdEmpleado int,
foreign key (IdEmpleado) references Empleados (IdEmpleado),
DiaSemana nvarchar(15) not null,
constraint ValidarDia check (DiaSemana in ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
HoraEntrada Time not null,
HoraSalida Time not null);
GO
create table TiposDeHabitacion(
IdTipoHabitacion int primary key identity(1,1),
NombreTipo nvarchar(30) not null,
CostoHabitacion money not null,
CapacidadHabitacion int not null
)
GO
create table Habitaciones
(IdHabitacion int primary key identity (1,1),
Estado Varchar(15),
Limpieza Varchar(30),
Piso int,
IdTipoHabitacion int not null,
foreign key (IdTipoHabitacion) references TiposDeHabitacion(IdTipoHabitacion)
);
GO
create table Reservas (
IdReserva int primary key identity (1,1),
FechaReserva date not null,
Estado varchar(30),
FechaEntrada date not null,
FechaSalida date not null,
Subtotal decimal(12,2),
IdHabitacion int,
foreign key (IdHabitacion) references Habitaciones(IdHabitacion),
CantidadHuespedes int,
PrecioPorNoche decimal(10,2));
GO
create table Estadias (
IdEstadia int primary key identity(1,1),
FechaHoraCheckIn datetime2,
Estado varchar(30),
FechaHoraCheckOut datetime2,
IdReserva int unique not null,
foreign key (IdReserva) references Reservas(IdReserva));
GO
create table Categorias(
IdCategoria INT primary key identity(1,1),
NombreDeCategoria nvarchar(30) not null
)
GO
create table Productos(
IdProducto INT Primary key identity(1,1),
NombreProducto nvarchar(30) not null,
IdCategoria INT not null,
foreign key (IdCategoria) references Categorias (IdCategoria),
Stock int not null,
Precio money not null
)
GO
create table Huespedes (
IdHuesped int primary key identity(1,1),
NombreHuesped nvarchar(50) not null,
CorreoHuesped nvarchar(60),
FechaNacimiento date not null,
NumeroDeTelefono nvarchar(15)
)
GO
create table ReservasHuespedes(
IdReserva int not null,
foreign key (IdReserva) references Reservas(IdReserva),
IdHuesped int not null,
foreign key (IdHuesped) references Huespedes (IdHuesped),
primary key (IdReserva, IdHuesped),
EsTitular bit not null
)
GO
CREATE TABLE PlazasDeEstacionamiento (
IdPlazaDeEstacionamiento INT  PRIMARY KEY IDENTITY(1,1),
Estado nvarchar(20) NOT NULL,
CONSTRAINT DisponibilidadDeEstacionamiento CHECK (Estado IN ('Disponible', 'Ocupada'))
)
GO
create table Vehiculos(
IdVehiculo int primary key identity(1,1),
IdHuesped int not null,
foreign key (IdHuesped) references Huespedes (IdHuesped),
MarcaVehiculo nvarchar(20) not null,
ModeloVehiculo nvarchar(20) not null,
ColorVehiculo nvarchar(20) not null,
PatenteVehiculo nvarchar(15) unique not null
)
GO
create table VehiculosPlazas(
IdVehiculo int not null,
IdPlazaDeEstacionamiento int not null,
constraint IdVehiculoPlaza primary key (IdVehiculo, IdPlazaDeEstacionamiento),
constraint VehiculoPlaza_Vehiculos foreign key (IdVehiculo) references Vehiculos(IdVehiculo),
constraint VehiculoPlaza_Plaza foreign key (IdPlazaDeEstacionamiento) references PlazasDeEstacionamiento (IdPlazaDeEstacionamiento)
)
GO
create table LimpiezasdeHabitaciones(
IdLimpieza int primary key identity(1,1),
HorarioInicioLimpieza datetime2 not null,
HorarioFinLimpieza datetime2 not null,
IdEmpleado int not null,
foreign key (IdEmpleado) references Empleados (IdEmpleado),
IdHabitacion int not null,
foreign key (IdHabitacion) references Habitaciones (IdHabitacion)
)
GO
CREATE TABLE Facturas (
IdFactura INT PRIMARY KEY IDENTITY(1,1),
IdEmpleado INT NOT NULL,
FOREIGN KEY(IdEmpleado) REFERENCES Empleados(IdEmpleado),
FechaEmision DATE NOT NULL,
IdReserva INT NOT NULL,
FOREIGN KEY(IdReserva) REFERENCES Reservas(IdReserva),
TipoFactura varchar(30) NOT NULL
)
GO
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
Estado Varchar(20) NOT NULL
)
GO
CREATE TABLE DetallesFactura (
IdDetalleFactura INT PRIMARY KEY IDENTITY(1,1),
IdFactura INT NOT NULL,
FOREIGN KEY (IdFactura) REFERENCES Facturas(IdFactura),
Impuesto DECIMAL(12,2) NOT NULL,
Estado Varchar(20) NOT NULL,
PrecioUnitario DECIMAL(12,2) NOT NULL,
Cantidad INT NOT NULL,
CONSTRAINT ValidarCantidadDetalleFactura CHECK (Cantidad > 0)
)
GO
CREATE TABLE Gastos (
IdGasto INT PRIMARY KEY IDENTITY(1,1),
IdEmpleado INT NOT NULL,
FOREIGN KEY(IdEmpleado) REFERENCES Empleados(IdEmpleado),
FechaGasto DATE NOT NULL,
Monto Decimal(12,2) NOT NULL,
Estado Varchar(20) NOT NULL,
CategoriaGasto Varchar(30) NOT NULL,
CONSTRAINT ValidarCategoriaGasto CHECK (CategoriaGasto IN ('Mantenimiento','Insumos','Servicios','Administracion')),
CONSTRAINT ValidarMonto CHECK (Monto > 0)
);
GO
CREATE TABLE ConsumosDeHuesped (
IdHuesped INT NOT NULL,
IdConsumo INT NOT NULL,
FechaConsumo DATE NOT NULL,
CONSTRAINT ConsumoDeHuesped PRIMARY KEY (IdHuesped,IdConsumo)
)
GO
create table ProductosPorConsumo (
IdConsumo int primary key identity(1,1),
Idproducto int,
foreign key (IdProducto) references Productos(IdProducto),
Cantidad int  not null
)
go
create table SolicitudesDeMantenimiento (
IdSolicitud int primary key identity(1,1),
IdEmpleado int,
foreign key (IdEmpleado) references Empleados(IdEmpleado),
Fecha date not null,
Estado nvarchar(20) not null default 'En espera',
constraint ValidarEstado check (Estado in('En espera', 'En process','Finalizada')),
Area nvarchar(25),
constraint ValidarArea check (Area in('Mantenimiento general','Electricidad','Plomeria','Gas','Conexion')),
Descripcion nvarchar(100),
Lugar nvarchar(50) not null,
Equipo nvarchar(50))
go
create table RegistrosDeAsistencia(
IdAsitencia int primary key identity(1,1),
IdEmpleado int,
foreign key (IdEmpleado) references Empleados(IdEmpleado),
horaEntrada datetime2 not null,
horaSalida datetime2 not null
)
go
create table ServiciosExtra(
IdServicio int primary key identity(1,1),
NombreServicio nvarchar(30),
ValorUnitario int not null,
Horario time)
go
create table ConsumosServiciosExtra(
IdConsumoServicio int primary key identity (1,1),
Precio int not null,
IdServicio int,
foreign key (IdServicio) references ServiciosExtra(IdServicio),
IdEstadia int,
foreign key (IdEstadia) references Estadias(IdEstadia)
)
go
