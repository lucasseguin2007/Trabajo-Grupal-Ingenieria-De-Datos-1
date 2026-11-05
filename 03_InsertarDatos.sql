USE GestionDeHotel;
GO

INSERT INTO Empleados(DNI,Nombre,Correo,Sueldo,HorasSemanales) VALUES
(40111222,'Juan Zeljkovic','juan@gmail.com',1100000,40),
(41222333,'Pepe Perez','Pepe@gmail.com',950000,40),
(42333444,'Ivan Marcone','perro@gmail.com',950000,40),
(43444555,'Leones Godoy','burro@gmail.com',900000,40),
(44555666,'Juan Arrayago','teamo@gmail.com',780000,40),
(47627624,'Marco Sobrido','marcosobrido@gmail.com',810000,40),
(46777888,'Mauricio Daian','mauricio@gmail.com',900000,30),
(47888999,'Lionel Messi','messi@gmail.com',850000,30),
(48999000,'Uriel Fretes','urifretes@gmail.com',1300000,40),
(49123456,'Matias Messi','matias@gmail.com',980000,40),
(40234567,'Lucas Seguin','neuquen@gmail.com',820000,40),
(41345678,'Santino Testino','testi@gmail.com',980000,40),
(42456789,'Juan Sama','juanp@gmail.com',760000,30),
(43567890,'Legui Leguiza','ezequiel@gmail.com',760000,30),
(44678901,'Santiago Montiel','santimontiel@gmail.com',700000,20),
(45789012,'Alexis Cuello','cuello@gmail.com',700000,20),
(46890123,'Luka Kishima','luquita@gmail.com',720000,30),
(47901234,'Joaquin Castellano','joacoc@gmail.com',80000,40),
(48012345,'Nicolas Paz','nicopaz@gmail.com',800000,40),
(49123457,'Juan Ignacio','juani@gmail.com',650000,20);
GO

Insert into HorarioEmpleado(IdEmpleado,DiaSemana,HoraEntrada,HoraSalida) values
(1,'Lunes','08:00','16:00'),
(1,'Martes','08:00','16:00'),
(1,'Miercoles','08:00','16:00'),
(2,'Lunes','16:00','23:00'),
(2,'Martes','16:00','23:00'),
(3,'Jueves','08:00','16:00'),
(3,'Viernes','08:00','16:00'),
(4,'Sabado','08:00','16:00'),
(4,'Domingo','08:00','16:00'),
(5,'Lunes','07:00','15:00'),
(5,'Martes','07:00','15:00'),
(6,'Miercoles','07:00','15:00'),
(6,'Jueves','07:00','15:00'),
(7,'Viernes','15:00','23:00'),
(7,'Sabado','15:00','23:00'),
(8,'Domingo','15:00','23:00'),
(9,'Martes','09:00','17:00'),
(10,'Miercoles','09:00','17:00'),
(11,'Jueves','09:00','17:00'),
(12,'Viernes','09:00','17:00'),
(13,'Lunes','06:00','14:00'),
(14,'Martes','06:00','14:00'),
(15,'Sabado','10:00','18:00'),
(16,'Domingo','10:00','18:00'),
(17,'Viernes','08:00','16:00');
GO

INSERT INTO RegistrosDeAsistencia(IdEmpleado,horaEntrada,horaSalida,fecha) VALUES
(1,'08:02','16:05','2026-11-02'),
(1,'08:00','16:00','2026-11-03'),
(1,'07:58','16:10','2026-11-04'),
(2,'16:05','23:00','2026-11-02'),
(2,'16:00','23:02','2026-11-03'),
(3,'08:10','16:00','2026-10-29'),
(3,'08:00','15:55','2026-10-30'),
(4,'08:00','16:00','2026-10-31'),
(4,'08:20','16:00','2026-11-01'),
(5,'07:01','15:00','2026-11-02'),
(5,'07:05','15:00','2026-11-03'),
(6,'07:00','15:10','2026-10-28'),
(6,'07:00','15:00','2026-10-29'),
(6,'06:55','15:03','2026-11-04'),
(7,'15:00','23:04','2026-10-30'),
(7,'15:30','23:00','2026-10-31'),
(8,'15:00','23:07','2026-11-01'),
(9,'09:00','17:00','2026-11-03'),
(10,'09:00','17:20','2026-10-28'),
(11,'09:00','17:00','2026-10-29'),
(13,'06:00','14:01','2026-11-02'),
(14,'06:25','14:00','2026-11-03');
GO


INSERT INTO tiposdeHabitacion(nombreTipo,costoHabitacion,capacidadHabitacion,cantidadHabitaciones) VALUES
('Simple',45000,1,4),
('Doble Estandar',70000,2,4),
('Doble Lujo',85000,2,3),
('Triple',100000,3,2),
('Familiar',130000,4,3),
('Suite',160000,2,3),
('Suite Presidencial',300000,4,1);
GO

INSERT INTO Habitaciones(Estado,Limpieza,Piso,IdTipo) VALUES
('Ocupada','Limpia',1,1),
('Disponible','Limpia',1,1),
('Disponible','Limpia',1,1),
('Mantenimiento','Pendiente',1,1),
('Ocupada','Limpia',2,2),
('Disponible','Limpia',2,2),
('Reservada','Limpia',2,2),
('Disponible','Pendiente',2,2),
('Ocupada','Limpia',3,3),
('Disponible','Limpia',3,3),
('Disponible','En proceso',3,3),
('Ocupada','Limpia',3,4),
('Disponible','Limpia',3,4),
('Reservada','Limpia',4,5),
('Disponible','Limpia',4,5),
('Mantenimiento','Pendiente',4,5),
('Disponible','Limpia',5,6),
('Disponible','Limpia',5,6),
('Disponible','Limpia',5,6),
('Disponible','Limpia',5,7);
GO


INSERT INTO huespedes(nombreHuesped,correoHuesped,fechaNacimiento,numTelefono) VALUES
('Luquitas flores', 'mebailocedrola@gmail.com','1985-03-14','+5491155550001'),
('Arquero Cedrola','bailealuquitas@gmail.com','1990-07-22','+5491155550002'),
('Luis Suarez ','luchosuarez@gmail.com','1978-11-05','+5491155550003'),
('Santiago Villanti','villa@gmail.com','1992-01-30','+5491155550004'),
('Bauti viñas','bautistaviñas@gmail.com','1983-09-18','+5491155550005'),
('Paola Argento','paolaarg@gmail.com','1995-04-09','+5491155550006'),
('Nacho Mendes','nachom@gmail.com','1970-12-25','+5491155550007'),
('Vicente Escalante',NULL,'1998-06-17','+5491155550008'),
('Cabrita Estevez','cabrita@gmail.com','1988-02-11','+5491155550009'),
('Pepe Lopez','pepito@gmail.com','1991-08-03','+5491155550010'),
('Martinez Quarta','martinezq@gmail.com','1993-10-27','+5491155550011'),
('Lolo lopez','lolopez@gmail.com','1986-05-19','+5491155550012'),
('Juan Juanicio','juanjuanicio@gmail.com','1980-01-08','+5491155550013'),
('Tomas Toto','TomasToto@gmail.com','1994-09-12','+5491155550014'),
('Bruno Bububu','bruno@gmail.com','1989-03-29','+5491155550015'),
('Mike Morales','torito@gmail.com','1996-12-02','+5491155550016'),
('Estevan Quito','Estebanquito@gmail.com','2000-07-14','+5491155550017'),
('Nicolas Tagliafico','taglia@gmail.com','1997-11-21','+5491155550018'),
('Joaquin Correa',NULL,'1984-04-06',NULL),
('Matias Soule','matisoule@mail.com','1999-02-25','+5491155550020');
GO

INSERT INTO PlazasDeEstacionamiento(Estado) VALUES
('Ocupada'),('Ocupada'),('Ocupada'),('Ocupada'),
('Disponible'),('Disponible'),('Disponible'),('Disponible'),
('Disponible'),('Disponible'),('Disponible'),('Disponible'),
('Disponible'),('Disponible'),('Disponible'),('Disponible'),
('Disponible'),('Disponible'),('Disponible'),('Disponible');
GO

INSERT INTO vehiculos(idHuesped,marcaVehiculo,modeloVehiculo,colorVehiculo,patenteVehiculo,IdPlazaDeEstacionamiento) VALUES
(9,'Toyota','Corolla','Gris','AB123CD',1),
(10,'Volkswagen','Gol Trend','Blanco','AC456EF',2),
(11,'Ford','Focus','Azul','AD789GH',3),
(12,'Chevrolet','Onix','Rojo','AE012IJ',4),
(13,'Renault','Sandero','Negro','AF345KL',5),
(14,'Fiat','Cronos','Plata','AG678MN',6),
(1,'Peugeot','208','Blanco','AA111BB',7),
(2,'Honda','Fit','Verde','AA222CC',8),
(3,'Citroen','C3','Gris','AA333DD',9),
(5,'Nissan','Versa','Negro','AA444EE',10),
(6,'Toyota','Hilux','Blanco','AA555FF',11),
(15,'Jeep','Renegade','Azul','AA666GG',12);
GO


INSERT INTO Reservas(FechaReserva,Estado,FechaEntrada,FechaSalida,Importe,Subtotal,IdHabitacion,CantidadHuespedes,PrecioPorNoche) VALUES
('2026-09-01','Finalizada','2026-09-10','2026-09-13',163350,135000,2,1,45000),
('2026-09-05','Finalizada','2026-09-15','2026-09-18',254100,210000,6,2,70000),
('2026-09-12','Finalizada','2026-09-20','2026-09-22',205700,170000,10,2,85000),
('2026-09-18','Finalizada','2026-09-28','2026-10-01',363000,300000,13,3,100000),
('2026-09-25','Finalizada','2026-10-05','2026-10-10',786500,650000,15,4,130000),
('2026-10-01','Finalizada','2026-10-12','2026-10-14',387200,320000,18,2,160000),
('2026-10-08','Finalizada','2026-10-17','2026-10-20',163350,135000,3,1,45000),
('2026-10-10','Finalizada','2026-10-22','2026-10-25',254100,210000,5,2,70000),
('2026-10-15','Finalizada','2026-10-24','2026-10-27',1089000,900000,20,4,300000),
('2026-10-20','Finalizada','2026-10-28','2026-10-31',254100,210000,8,2,70000),
('2026-10-25','En curso','2026-11-02','2026-11-06',217800,180000,1,1,45000),
('2026-10-26','En curso','2026-11-03','2026-11-07',338800,280000,5,2,70000),
('2026-10-28','En curso','2026-11-01','2026-11-05',411400,340000,9,2,85000),
('2026-10-30','En curso','2026-11-04','2026-11-08',484000,400000,12,3,100000),
('2026-10-29','Confirmada','2026-11-10','2026-11-13',254100,210000,7,2,70000),
('2026-11-01','Confirmada','2026-11-12','2026-11-15',471900,390000,14,2,130000),
('2026-11-02','Confirmada','2026-11-20','2026-11-24',1452000,1200000,20,2,300000),
('2026-11-03','Pendiente','2026-12-01','2026-12-05',774400,640000,19,2,160000),
('2026-11-04','Pendiente','2026-12-10','2026-12-12',108900,90000,2,1,45000),
('2026-10-05','Cancelada','2026-10-18','2026-10-20',205700,170000,11,2,85000),
('2026-10-12','Cancelada','2026-10-30','2026-11-02',471900,390000,16,3,130000),
('2026-10-14','Cancelada','2026-11-05','2026-11-08',580800,480000,19,2,160000);
GO

INSERT INTO ReservasHuespedes(idReserva,idHuesped,esTitular) VALUES
(1,1,1),
(2,2,1),(2,3,0),
(3,4,1),(3,5,0),
(4,3,1),(4,6,0),(4,7,0),
(5,5,1),(5,2,0),(5,4,0),(5,8,0),
(6,6,1),(6,7,0),
(7,1,1),
(8,8,1),(8,4,0),
(9,7,1),(9,3,0),(9,2,0),(9,6,0),
(10,2,1),(10,5,0),
(11,9,1),
(12,10,1),(12,11,0),
(13,12,1),(13,8,0),
(14,7,1),(14,3,0),(14,6,0),
(15,13,1),(15,14,0),
(16,15,1),(16,16,0),
(17,14,1),(17,15,0),
(18,16,1),(18,13,0),
(20,5,1),(20,3,0),
(21,6,1),(21,7,0),(21,8,0),
(22,20,1),(22,1,0);
GO

Insert into Estadias(FechaHoraCheckIn,Estado,FechaHoraCheckOut,IdReserva) values
('2026-09-10 14:05:00','Finalizada','2026-09-13 10:10:00',1),
('2026-09-15 15:00:00','Finalizada','2026-09-18 11:00:00',2),
('2026-09-20 14:30:00','Finalizada','2026-09-22 10:00:00',3),
('2026-09-28 16:10:00','Finalizada','2026-10-01 12:30:00',4),
('2026-10-05 14:00:00','Finalizada','2026-10-10 10:00:00',5),
('2026-10-12 13:45:00','Finalizada','2026-10-14 11:00:00',6),
('2026-10-17 14:20:00','Finalizada','2026-10-20 09:50:00',7),
('2026-10-22 15:15:00','Finalizada','2026-10-25 10:30:00',8),
('2026-10-24 14:00:00','Finalizada','2026-10-27 12:00:00',9),
('2026-10-28 14:10:00','Finalizada','2026-10-31 10:20:00',10),
('2026-11-02 14:30:00','En curso',NULL,11),
('2026-11-03 15:10:00','En curso',NULL,12),
('2026-11-01 14:00:00','En curso',NULL,13),
('2026-11-04 13:50:00','En curso',NULL,14);
GO




INSERT INTO categorias(nombredeCategoria) VALUES
('Bebidas sin alcohol'),
('Bebidas con alcohol'),
('Snacks'),
('Desayunos'),
('Comidas'),
('Postres'),
('Higiene personal'),
('Souvenirs');
GO

INSERT INTO Productos(nombreProducto,idCategoria,stock,precio) VALUES
('Agua mineral 500ml',1,120,1500),
('Coca cola 500ml',1,90,2200),
('Jugo de naranja',1,40,2500),
('Cerveza ',2,60,4500),
('Vino ',2,35,5500),
('Fernet',2,25,6000),
('Papas fritas',3,50,2800),
('Doritos',3,30,3500),
('Barra de cereal',3,0,1800),
('Desayuno continental',4,40,8000),
('Desayuno americano',4,30,10500),
('Tostados con mermelada',4,45,4200),
('Milanesa con papas fritas',5,20,12500),
('Ensalada Cesar',5,18,9800),
('Pizza de muzzarella',5,15,11000),
('Flan con dulce de leche',6,22,4800),
('Brownie con helado',6,3,5200),
('Papel Higienico',7,70,3000),
('Cepillo dental',7,60,1200),
('Saquitos de Te Green Hill',7,80,1800);
GO

INSERT INTO ProductosPorConsumo(Idproducto,cantidad,precioTotal) VALUES
(1,2,3000),
(10,1,8000),
(4,3,13500),
(13,2,25000),
(5,2,11000),
(7,1,2800),
(15,2,22000),
(11,2,21000),
(16,1,4800),
(6,2,12000),
(4,4,18000),
(14,3,29400),
(2,2,4400),
(10,1,8000),
(3,2,5000),
(12,2,8400),
(4,2,9000),
(17,1,5200),
(18,1,3000),
(8,2,7000);
GO

Insert into ConsumosDeHuesped(IdHuesped,IdConsumo,FechaConsumo) values
(1,1,'2026-09-11'),
(1,2,'2026-09-12'),
(2,3,'2026-09-16'),
(4,4,'2026-09-21'),
(3,5,'2026-09-29'),
(5,6,'2026-10-06'),
(5,7,'2026-10-08'),
(6,8,'2026-10-13'),
(7,9,'2026-10-13'),
(8,10,'2026-10-23'),
(7,11,'2026-10-25'),
(3,12,'2026-10-26'),
(2,13,'2026-10-29'),
(9,14,'2026-11-03'),
(10,15,'2026-11-03'),
(11,16,'2026-11-04'),
(12,17,'2026-11-02'),
(12,18,'2026-11-03'),
(9,19,'2026-11-04'),
(7,20,'2026-11-04');
GO


INSERT INTO Facturas(IdEmpleado,FechaEmision,IdReserva,TipoComprobante) values
(1,'2026-09-13',1,'Factura B'),
(2,'2026-09-18',2,'Factura B'),
(1,'2026-09-22',3,'Factura A'),
(3,'2026-10-01',4,'Factura B'),
(1,'2026-10-10',5,'Factura A'),
(2,'2026-10-14',6,'Factura B'),
(4,'2026-10-20',7,'Factura B'),
(3,'2026-10-25',8,'Factura B'),
(7,'2026-10-27',9,'Factura A'),
(1,'2026-11-01',21,'Factura B'),
(2,'2026-11-03',15,'Factura B'),
(3,'2026-11-04',16,'Factura A'),
(2,'2026-10-20',7,'Factura B');
GO

Insert into DetallesFactura(IdFactura,Subtotal,Impuesto,Estado,Total,PrecioUnitario,Cantidad) values
(1,135000,28350,'Pagada',163350,45000,3),
(1,11000,2310,'Pagada',13310,11000,1),
(2,210000,44100,'Pagada',254100,70000,3),
(2,13500,2835,'Pagada',16335,13500,1),
(3,170000,35700,'Pagada',205700,85000,2),
(3,25000,5250,'Pagada',30250,25000,1),
(4,300000,63000,'Pagada',363000,100000,3),
(4,11000,2310,'Pagada',13310,11000,1),
(5,650000,136500,'Pagada',786500,130000,5),
(5,24800,5208,'Pagada',30008,24800,1),
(6,320000,67200,'Pagada',387200,160000,2),
(6,25800,5418,'Pagada',31218,25800,1),
(7,135000,28350,'Pagada',163350,45000,3),
(8,210000,44100,'Pagada',254100,70000,3),
(8,12000,2520,'Pagada',14520,12000,1),
(9,900000,189000,'Pagada',1089000,300000,3),
(9,47400,9954,'Pagada',57354,47400,1),
(10,130000,27300,'Pagada',157300,130000,1),
(11,63000,13230,'Pagada',76230,63000,1),
(12,117000,24570,'Emitida',141570,117000,1),
(13,135000,28350,'Anulada',163350,45000,3);
GO

INSERT INTO Pagos(IdReserva,Metodo,Importe,Cuotas,Descripcion,Estado) values
(1,'Efectivo',176660,1,'Pago total al check-out','Aprobado'),
(2,'Tarjeta de credito',270435,3,'Pago en 3 cuotas','Aprobado'),
(3,'Transferencia',235950,1,'Transferencia bancaria','Aprobado'),
(4,'Tarjeta de credito',376310,1,'Tarjeta rechazada por fondos insuficientes','Rechazado'),
(4,'Efectivo',376310,1,'Pago en recepcion tras el rechazo','Aprobado'),
(5,'Transferencia',300000,1,'Sena al reservar','Aprobado'),
(5,'Tarjeta de debito',516508,1,'Saldo al check-out','Aprobado'),
(6,'Tarjeta de credito',418418,6,'6 cuotas sin interes','Aprobado'),
(7,'Efectivo',163350,1,NULL,'Aprobado'),
(8,'Tarjeta de debito',268620,1,'Pago al check-out','Aprobado'),
(9,'Transferencia',400000,1,'Sena al reservar','Aprobado'),
(9,'Tarjeta de credito',746354,12,'Saldo en 12 cuotas','Aprobado'),
(10,'Efectivo',254100,1,'Cobro pendiente tras el check-out','Pendiente'),
(11,'Transferencia',100000,1,'Anticipo','Aprobado'),
(12,'Tarjeta de credito',100000,1,'Garantia de reserva','Aprobado'),
(13,'Tarjeta de credito',411400,3,'Pago anticipado en 3 cuotas','Aprobado'),
(15,'Transferencia',76230,1,'Sena 30%','Aprobado'),
(16,'Tarjeta de credito',141570,1,'Sena 30%','Pendiente'),
(17,'Transferencia',360000,1,'Sena 30% suite','Aprobado'),
(20,'Tarjeta de credito',205700,1,'Pago anticipado de reserva cancelada','Reembolsado'),
(21,'Tarjeta de debito',157300,1,'Penalidad por cancelacion tardia','Aprobado'),
(22,'Tarjeta de credito',100000,1,'Pago rechazado por el emisor','Rechazado');
GO
INSERT INTO Gastos(IdEmpleado,FechaGasto,Monto,Estado,CategoriaGasto) values
(9,'2026-09-02',45000,'Pagado','Insumos'),
(10,'2026-09-05',120000,'Pagado','Mantenimiento'),
(9,'2026-09-08',350000,'Pagado','Servicios'),
(11,'2026-09-12',28000,'Pagado','Insumos'),
(12,'2026-09-15',95000,'Pagado','Mantenimiento'),
(9,'2026-09-20',180000,'Pagado','Administracion'),
(10,'2026-09-25',62000,'Pagado','Mantenimiento'),
(11,'2026-10-01',410000,'Pagado','Servicios'),
(9,'2026-10-03',37500,'Pagado','Insumos'),
(12,'2026-10-07',230000,'Pagado','Mantenimiento'),
(13,'2026-10-10',15800,'Pagado','Insumos'),
(9,'2026-10-14',200000,'Pagado','Administracion'),
(10,'2026-10-18',88000,'Aprobado','Mantenimiento'),
(11,'2026-10-22',54000,'Aprobado','Insumos'),
(9,'2026-10-26',430000,'Aprobado','Servicios'),
(12,'2026-10-28',310000,'Pendiente','Mantenimiento'),
(13,'2026-11-01',22000,'Pendiente','Insumos'),
(9,'2026-11-02',150000,'Pendiente','Administracion'),
(14,'2026-11-03',75000,'Rechazado','Servicios'),
(10,'2026-11-04',49500,'Pendiente','Mantenimiento');
GO

INSERT INTO SolicitudesDeMantenimiento(IdEmpleado,fecha,estado,area,descripcion,lugar,equipo) values
(5,'2026-10-01','Finalizada','Plomeria','canilla del baño anda mal','Habitacion 6','Canilla'),
(6,'2026-10-03','Finalizada','Electricidad','el velador no enciende','Habitacion 8','Velador'),
(1,'2026-10-05','Finalizada','Conexion','no hay WiFi en el piso 3','Piso 3','Router'),
(2,'2026-10-08','Finalizada','Gas','olor a gas en la cocina','Cocina','Calefon'),
(5,'2026-10-10','Finalizada','Mantenimiento general','se cayo la puerta del placard','Habitacion 13','Placard'),
(6,'2026-10-15','Finalizada','Plomeria','el inodoro pierde agua','Habitacion 15','Inodoro'),
(1,'2026-10-18','Finalizada','Mantenimiento general','se trabo la cerradura trabada','Habitacion 3','Cerradura'),
(4,'2026-10-20','Finalizada','Conexion','el televisor sin señal','Habitacion 10','Televisor'),
(5,'2026-10-22','En proceso','Electricidad','El aire acondicionado no funciona','Habitacion 4','Aire acondicionado'),
(6,'2026-10-25','En proceso','Plomeria','ls ducha no toene presion de agua','Habitacion 16','Ducha'),
(2,'2026-10-27','En proceso','Mantenimiento general','la pintura se humedecio','Pasillo piso 2','Pared'),
(1,'2026-10-29','En espera','Electricidad','la luz del pasillo parpadea','Pasillo piso 4','Luminaria'),
(3,'2026-10-30','En espera','Gas','revision anual','Sala de maquinas','Caldera'),
(5,'2026-11-01','En espera','Conexion','no anda el WiFi en recepcion','Recepcion','Router'),
(4,'2026-11-02','En espera','Plomeria','la pileta del baño se tapo','Habitacion 8','Pileta'),
(2,'2026-11-04','En espera','Conexion','el cable HDMI del televisor no anda','Habitacion 1','Cable HDMI'),
(6,'2026-11-03','En espera',NULL,'hay ruidos extraños en el ascensor','Ascensor',NULL),
(7,'2026-11-02','En espera','Mantenimiento general','la ventana no agarra la traba','Habitacion 11','Ventana');
GO

INSERT INTO SolicitudesDeMantenimiento(IdEmpleado,fecha,area,descripcion,lugar,equipo) values
(8,'2026-11-03','Electricidad','el enchufe al lado de la cama tira chispa','Habitacion 2','Enchufe');
GO

INSERT INTO LimpiezasdeHabitaciones(horarioInicioLimpieza,horarioFinLimpieza,fechaLimpieza,idEmpleado,idHabitacion) values
('08:00','08:40','2026-11-02',5,2),
('08:45','09:30','2026-11-02',5,3),
('09:35','10:20','2026-11-02',5,6),
('07:00','07:45','2026-11-03',5,1),
('07:50','08:30','2026-11-03',5,5),
('08:35','09:15','2026-11-03',5,9),
('07:00','07:40','2026-11-04',6,10),
('07:45','08:30','2026-11-04',6,13),
('08:35','09:20','2026-11-04',6,15),
('09:30','10:30','2026-11-04',6,19),
('06:30','07:10','2026-11-02',13,12),
('07:15','07:55','2026-11-02',13,14),
('08:00','08:45','2026-11-02',13,18),
('06:30','07:15','2026-11-03',14,17),
('07:20','08:00','2026-11-03',14,20),
('08:05','08:50','2026-11-03',14,2),
('07:00','07:45','2026-10-29',6,8),
('07:50','08:35','2026-10-29',6,11),
('07:00','07:40','2026-10-28',6,7),
('07:45','08:30','2026-10-28',6,4);
GO

INSERT INTO ServiciosExtra(nombreServicio,precioTotal,horario) values
('Circuito de spa',18000,'10:00'),
('Lavanderia',6500,NULL),
('Traslado al aeropuerto',25000,'06:00'),
('Late check-out',15000,'12:00'),
('Alquiler de bicicleta',5000,'09:00'),
('Desayuno en la habitacion',7500,'08:00'),
('Cochera cubierta',8000,NULL),
('Excursion guiada',32000,'09:30'),
('Masaje descontracturante',22000,'16:00'),
('Cena romantica',45000,'21:00');
GO

INSERT INTO ConsumosServiciosExtra(precio,IdServicio,IdEstadia) values
(6500,2,1),
(18000,1,2),
(18000,1,2),
(25000,3,3),
(22000,9,4),
(15000,4,4),
(45000,10,5),
(32000,8,5),
(6500,2,5),
(7500,6,6),
(8000,7,8),
(18000,1,8),
(32000,8,9),
(45000,10,9),
(22000,9,9),
(6500,2,10),
(7500,6,11),
(18000,1,12),
(25000,3,13),
(22000,9,12);
GO
