 select 
p.Idadjudicacion,
a.Identificacion as Cliente,
P.fecha,
p.TasaComision,comision,a.Valor,p.Comision/Valor/TasaComision*100
from pagocomision p   
join 004cnsadjudica a on a.idadjudicacion=p.idadjudicacion
where 
 p.fecha>='2019-06-01' and p.fecha<='2019-06-30' 
and idcargo=9


