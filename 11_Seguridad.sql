USE gestiondehotel;
GO
 
CREATE SCHEMA admin;
GO
CREATE SCHEMA gerente;
GO
CREATE SCHEMA recepcionista;
GO
CREATE SCHEMA personal;
GO
CREATE SCHEMA huesped;
GO
 
CREATE LOGIN login_admin WITH PASSWORD = 'admin';
CREATE LOGIN login_gerente WITH PASSWORD = 'gerente';
CREATE LOGIN login_recepcionista WITH PASSWORD = 'recepcion';
CREATE LOGIN login_limpieza WITH PASSWORD = 'limpieza';
CREATE LOGIN login_mantenimiento WITH PASSWORD = 'mantenimiento';
CREATE LOGIN login_estacionamiento WITH PASSWORD = 'estacionamiento';
CREATE LOGIN login_contable WITH PASSWORD = 'contable';
CREATE LOGIN login_inventarios WITH PASSWORD = 'inventarios';
CREATE LOGIN login_seguridad WITH PASSWORD = 'seguridad';
CREATE LOGIN login_serviciosextra WITH PASSWORD = 'serviciosextra';
CREATE LOGIN login_huesped WITH PASSWORD = 'huesped';
GO
 
CREATE USER usuario_admin FOR LOGIN login_admin;
CREATE USER usuario_gerente FOR LOGIN login_gerente;
CREATE USER usuario_recepcionista FOR LOGIN login_recepcionista;
CREATE USER usuario_limpieza FOR LOGIN login_limpieza;
CREATE USER usuario_mantenimiento FOR LOGIN login_mantenimiento;
CREATE USER usuario_estacionamiento FOR LOGIN login_estacionamiento;
CREATE USER usuario_contable FOR LOGIN login_contable;
CREATE USER usuario_inventarios FOR LOGIN login_inventarios;
CREATE USER usuario_seguridad FOR LOGIN login_seguridad;
CREATE USER usuario_serviciosextra FOR LOGIN login_serviciosextra;
CREATE USER usuario_huesped FOR LOGIN login_huesped;
GO
 
ALTER USER usuario_admin WITH DEFAULT_SCHEMA = admin;
ALTER USER usuario_gerente WITH DEFAULT_SCHEMA = gerente;
ALTER USER usuario_recepcionista WITH DEFAULT_SCHEMA = recepcionista;
ALTER USER usuario_limpieza WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_mantenimiento WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_estacionamiento WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_contable WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_inventarios WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_seguridad WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_serviciosextra WITH DEFAULT_SCHEMA = personal;
ALTER USER usuario_huesped WITH DEFAULT_SCHEMA = huesped;
GO
 
grant select, insert, update, delete, execute on schema::dbo to usuario_admin;
 
grant select on schema::dbo to usuario_gerente;
grant execute on schema::dbo to usuario_gerente;
deny insert, update, delete on schema::dbo to usuario_gerente;
 
grant insert on registrosdeasistencia to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
deny update, delete on registrosdeasistencia to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
grant select, insert on consumosdehuesped to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
grant select, insert on productosporconsumo to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
grant select on productos to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_seguridad, usuario_serviciosextra;
deny select, insert, update, delete on empleados to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
deny select, insert, update, delete on horarioempleado to usuario_recepcionista, usuario_limpieza, usuario_mantenimiento, usuario_estacionamiento, usuario_contable, usuario_inventarios, usuario_seguridad, usuario_serviciosextra;
 
grant select, insert, update on reservas to usuario_recepcionista;
grant select, insert, update on estadias to usuario_recepcionista;
grant select, insert on huespedes to usuario_recepcionista;
grant select, insert on reservashuespedes to usuario_recepcionista;
grant select on habitaciones to usuario_recepcionista;
grant select on tiposdehabitacion to usuario_recepcionista;
grant select on fn_habitacionesdisponibles to usuario_recepcionista;
grant execute on fn_importereserva to usuario_recepcionista;
deny select, insert, update, delete on pagos to usuario_recepcionista;
deny select, insert, update, delete on facturas to usuario_recepcionista;
deny select, insert, update, delete on gastos to usuario_recepcionista;
deny delete on reservas to usuario_recepcionista;
deny delete on estadias to usuario_recepcionista;
 
grant select, insert, update on limpiezasdehabitaciones to usuario_limpieza;
grant select, update on habitaciones to usuario_limpieza;
 
grant select, insert, update on solicitudesdemantenimiento to usuario_mantenimiento;
 
grant select on vehiculos to usuario_estacionamiento;
grant select, insert, update on plazasdeestacionamiento to usuario_estacionamiento;
grant select, insert, update on vehiculosplazas to usuario_estacionamiento;
 
grant select, insert, update on facturas to usuario_contable;
grant select, insert, update on detallesfactura to usuario_contable;
grant select, insert, update on pagos to usuario_contable;
grant select, insert, update on gastos to usuario_contable;
grant select on reservas to usuario_contable;
grant select on vw_estadocuentareservas to usuario_contable;
grant execute on fn_saldopendientereserva to usuario_contable;
 
grant select, insert, update on productos to usuario_inventarios;
grant select on categorias to usuario_inventarios;
 
grant select on huespedes to usuario_seguridad;
grant select on reservas to usuario_seguridad;
grant select on reservashuespedes to usuario_seguridad;
deny insert, update, delete on huespedes to usuario_seguridad;
deny insert, update, delete on reservas to usuario_seguridad;
 
grant select, insert, update on serviciosextra to usuario_serviciosextra;
grant select, insert, update on consumosserviciosextra to usuario_serviciosextra;
grant select on estadias to usuario_serviciosextra;
 
deny select, insert, update, delete on empleados to usuario_huesped;
deny select, insert, update, delete on pagos to usuario_huesped;
deny select, insert, update, delete on gastos to usuario_huesped;
deny delete on reservas to usuario_huesped;
 
go