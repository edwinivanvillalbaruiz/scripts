
create procedure Consultas(Nombre Varchar(60))
BEGIN
IF Nombre='Canje'
THEN
SELECT  
a.Cliente,
a.Categoria,
r.*
From
(
SELECT Fecha,
Recibo,
IdAdjudicacion,
sum(Capital+InteresCte+InteresMora)As 
Valor, 
Estado 
From recaudos
Where Estado='Pendiente'
GROUP by Recibo
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