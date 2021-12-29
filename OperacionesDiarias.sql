SET @Cuenta = '11100505';
SET @Fecha = '2019-08-31';
SELECT	sum( debe - haber )SaldoAnterior FROM	diario WHERE	fecha <= @Fecha AND cuenta = @Cuenta AND estado = 1;
SELECT Fecha, Cheque,detalle,haber FROM diario WHERE fecha > @Fecha AND cuenta = @Cuenta AND estado = 1 AND HABER >0;
SELECT Fecha,Cheque,Motivo,debe FROM diario WHERE	fecha > @Fecha 	AND cuenta = @Cuenta 	AND estado = 1 	AND DEBE > 0;
SELECT	sum( debe )Debe,	sum(- Haber )Haber FROM	diario WHERE	fecha > @Fecha 	AND cuenta = @Cuenta 	AND estado = 1;
SELECT(	sum( debe )-	sum(- Haber ) )Saldo FROM	diario WHERE	fecha > @Fecha 	AND cuenta = @Cuenta 	AND estado = 1 ;