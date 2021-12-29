
Select 
f.*,
(TTRcd/Valor*100) Porc,
if((RcdCapital/Valor*100)>=30,'Administrativa','Comercial' )TipoCartera
From
(
select i.IdInmueble ,
 i.Estado,

d.Valor,
d.CuotaFnc,
d.estado as EStadoOp,
d.IdAdjudicacion, 
t.Telefono1,
t.Telefono2,
t.Celular,
t.Email,
t.Direccion,
r.TtRcd,
r.RcdCapital,
d.TipoOperacion,
d.Contrato,
d.Fecha,
r.FechaREc,
t.NombreCompleto
from inmuebles i

left join

(
select * from adjudicacion
 

)d
on d.IdInmueble=i.IdInmueble


left join


  (
select IdAdjudicacion,
sum(Capital)RcdCapital,
sum(Capital+InteresCte+InteresMora)TtRcd,
max(Fecha)FechaREc
 from recaudos  
where estado='Aprobado'
group by IdAdjudicacion
)r

on r.IdAdjudicacion=d.IdAdjudicacion


left join
(
select 
IdTercero,
NombreCompleto,
Telefono1,
Telefono2,
Celular,
Direccion,
Email
from 007guardian.terceros
)t
on t.IdTercero=d.idtercero1
)f




