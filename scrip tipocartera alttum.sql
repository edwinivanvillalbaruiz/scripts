select d.* ,
d.RcdCpt/d.Valor*100 Porcentaje,
if((d.RcdCpt/d.Valor*100)>=30,'Admin','Cial')Tipo
from
( 
select a.IdAdjudicacion,a.Valor,if(r.Rcd is null,0 ,r.Rcd)RcdCpt from adjudicacion a 
left JOIN 

(select  idadjudicacion,sum(capital)Rcd From recaudos where estado ='Aprobado'
group by idadjudicacion)r
on r.idadjudicacion=a.idadjudicacion
where estado='Aprobado' or Estado='Juridico')d 









