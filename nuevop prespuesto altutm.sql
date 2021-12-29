SET @FechaInicial ='2018-07-31'; 
SET @FechaFinal ='2018-08-31';

Select p.*
From
(
SELECT
convert((Car.Id),char)Id,
convert((Car.IdAdjudicacion),char)IdAdjudicacion,
tipo.Cliente AS Cliente,
Car.Concepto Cto,
Car.CuotaNum NCta,
Car.Fecha,
Car.FechaRec AS UltPago,
Car.Capital,
Car.Interes,
Car.Cuota,
Car.DiasCpt,
Car.Diaslqd,
Car.Mora,
Tipo.TipoCartera,
Tipo.Estado,
Tipo.TipoOperacion
FROM
	(
SELECT
rr.Id,
rr.Idadjudicacion,
rr.Concepto,
rr.CuotaNum,
Max(rr.Fecha) Fecha,
IF (Max(rr.FechaRec) IS NULL,	rr.Fecha,		Max(rr.FechaRec)	) FechaRec,		sum(rr.Capital) Capital,
sum(rr.Interes) Interes,sum(rr.cuota) Cuota,
IF (DATEDIFF(@FechaInicial , rr.fecha) <= 0,	0,	DATEDIFF(@FechaInicial , rr.fecha)	) DiasCpt,
sum(rr.SaldointeMora) SaldoInteMora,

IF ((rr.Fecha > max(rr.fechaRec)),(	IF (DATEDIFF(@FechaInicial , rr.fecha) <= 0,0,	DATEDIFF(@FechaInicial , rr.fecha))),
(	IF (	DATEDIFF(		@FechaInicial ,		IF (			Max(rr.FechaRec) IS NULL,		rr.Fecha,			Max(rr.FechaRec))	) <= 0,	0,
DATEDIFF(	@FechaInicial ,IF (Max(rr.FechaRec) IS NULL,	rr.Fecha,	Max(rr.FechaRec))	)))) DiasLqd,

IF (rr.concepto = 'CI',	0,round((	sum(rr.cuota) *	IF ((rr.Fecha > max(rr.fechaRec)),(	IF (	DATEDIFF(@FechaInicial , rr.fecha) <= 0,
0,DATEDIFF(@FechaInicial , rr.fecha))),	(IF (	DATEDIFF(	@FechaInicial ,	IF (Max(rr.FechaRec) IS NULL,	rr.Fecha,	Max(rr.FechaRec))) <= 0,
0,DATEDIFF(@FechaInicial ,	IF (Max(rr.FechaRec) IS NULL,	rr.Fecha,	Max(rr.FechaRec))	)	)	)) * 0 	) / 36000,2)) Mora,
 rr.tipo
FROM
	
(
SELECT
IdCta AS Id,
f.IdAdjudicacion,
Concepto,
f.NumCuota CuotaNum,
f.Fecha,
NULL FechaRec,
f.Capital,
f.Interes AS Interes,
f.Cuota,
0 AS InteresMora,
0 AS InteresCnd,
0 AS MoraCalc,
0 SaldoInteMora,
'Cta' AS Tipo
FROM 	financiacion f
WHERE F.Fecha <= @FechaFinal 
UNION
SELECT
IdFinanciacion AS Id,
r.IdAdjudicacion,
r.Concepto AS concepto,
r.NumCuota AS CuotaNum,
NULL fecha,
Max(r.Fecha) FechaRec,
Sum(- r.Capital) AS Capital,
Sum(- r.InteresCte) AS InteresCte,
sum(-(r.Capital) - r.InteresCte) AS Cuota,
sum(- r.InteresMora) AS InteresMora,
sum(- r.InteresCnd) AS InteresCnd,
sum(r.VrMoraCalc) AS MoraCalc,
sum((r.VrMoraCalc - r.InteresCnd) - r.InteresMora) AS SaldoIntMora,
'Rcd' AS Tipo
FROM recaudos r
WHERE r.Estado != 'Devuelto'
AND r.Fecha <= @FechaInicial 
GROUP BY id
) RR GROUP BY 	rr.id 

) Car
JOIN 
(

select 
tipo.*
from 

(
select 
r.IdAdjudicacion,
c.Identificacion as cliente,
c.Estado,
c.TipoOperacion,
r.Tipo as TipoCartera
from

(
select d.IdAdjudicacion ,
d.RcdCpt/d.Valor*100 Porcentaje,
if((d.RcdCpt/d.Valor*100)>=30,'Admin','Cial')Tipo
from
( 
select a.IdAdjudicacion,a.Valor,if(r.Rcd is null,0 ,r.Rcd)RcdCpt from adjudicacion a 
left JOIN 

(select  idadjudicacion,sum(capital)Rcd From recaudos where estado ='Aprobado' and concepto !='GA'
group by idadjudicacion)r
on r.idadjudicacion=a.idadjudicacion
where estado='Aprobado' or Estado='Juridico')d 
)r  join 002cnsadjudica c  on c.IdAdjudicacion=r.IdAdjudicacion
)tipo

) Tipo
ON tipo.idadjudicacion = car.IdAdjudicacion
where  car.cuota>5 
order by Cliente,IdAdjudicacion,concepto,cuotanum
)p
