
create procedure ConsultasConFecha(Nombre Varchar(60),FechaInicial datetime,FechaFinal DateTime)
BEGIN
IF Nombre='Recaudos'
THEN
SELECT  
a.Cliente,
a.Categoria,
r.*
From
(
Select
IdAdjudicacion,
Fecha,
NumRecibo,
Operacion,
FormaPago,
Valor
From datosrecaudos
Where Fecha>=FechaInicial And Fecha <=FechaFinal
)r

join 
(
SELECT 
a.IdAdjudicacion,
a.Contrato,
a.IdTercero1,
t.NombreCompleto as Cliente,
a.Valor,
a.FormaPago,
a.Estado,
c.Nombre as Categoria,
c.Años
from adjudicacion a
left join categorias c on c.IdCategoria=a.IdCategoria
left join 007guardian.terceros t on t.idtercero=a.Idtercero1
)a on a.IdAdjudicacion =r.IdAdjudicacion;
END IF;
END;