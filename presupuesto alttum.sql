SET @FechaInicial ='2018-06-30'; 
SET @FechaFinal ='2018-07-30';

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
Tipo.Estado
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
Select
tipo.IdAdjudicacion,
tipo.Cliente,
tipo.Estado,
IF ((tipo.Valor > 0),'Comercial','Administrativa') AS TipoCartera
from
(
SELECT
b.IdAdjudicacion,
b.Identificacion AS Cliente,
b.Estado,
IF (b.CuotaInicial < b.BaseInicial,b.CuotaInicial,b.BaseInicial)-(if((ri.valor)is null ,0,(ri.valor))) Valor
FROM 004cnsadjudicainicial b 
LEFT JOIN 
(
SELECT
r.IdAdjudicacion,
if(sum(r.Capital)is null,0,sum( r.Capital)) Valor
FROM recaudos r
WHERE 	r.estado = 'Aprobado' and r.Concepto='CI'
AND R.fecha <= @FechaInicial
GROUP BY 	r.idadjudicacion
)ri on ri.IdAdjudicacion=b.IdAdjudicacion
where b.FechaContrato <=@FechaInicial
and (Estado ='Aprobado' or Estado='Juridico') 
)tipo
) Tipo
ON tipo.idadjudicacion = car.IdAdjudicacion
where  car.cuota>5 
order by Cliente,IdAdjudicacion,concepto,cuotanum
)p













