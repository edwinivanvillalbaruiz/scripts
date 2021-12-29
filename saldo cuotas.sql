 
SELECT 
f.Fecha,
f.IdAdjudicacion,
f.Id,
f.CuotaNum,
f.Capital-(if(r.RcdCapital is null,0,r.RcdCapital))Capital,
f.Interes -if(r.RcdInteresCte is null,0,r.RcdInteresCte)Interes,
f.Cuota - if(r.RcdCuota is null,0,r.RcdCuota)Cuota,
r.UltimoPago

from 004cuotasfnc f
left JOIN 
(
SELECT
Id ,
Max(Fecha)as UltimoPago,
sum(Capital)as RcdCapital,
sum(Interescte)as RcdInteresCte,
sum(Capital+InteresCte)as RcdCuota
from recaudos 
where IdAdjudicacion='Adj351'
GROUP BY Id
)r  on  f.Id=r.Id

where f.IdAdjudicacion='Adj351'