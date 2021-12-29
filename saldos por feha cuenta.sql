set @cuenta='23352001';
set @fecha='2017-12-30';
Select 
IdTercero,
Factura,
NombreCompleto,
Sum(Saldo)Saldo,
Programada,
Autorizacion  
FROM
(SELECT
d.IdTercero AS Idtercero,
d.Factura AS Factura,
t.NombreCompleto AS nombrecompleto,
sum( ( d.Haber - d.Debe ) ) AS Saldo,
d.Programada AS Programada,
d.Autorizacion AS Autorizacion 
FROM
diario d JOIN 007guardian.terceros t ON  t.IdTercero = d.IdTercero 
and fecha <=@fecha
WHERE 	Cuenta=@cuenta 	AND  d.Estado = 1 

GROUP BY 	d.IdTercero,	d.Factura
)d Where Saldo !=0 group by IdTercero;