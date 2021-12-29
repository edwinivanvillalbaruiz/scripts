select 
f.IdAdjudicacion AS IdAdjudicacion,
f.Cliente,
f.TipoCartera,  
f.Estado,
f.Valor,
f.BaseComision,
Count(NumCuota)CuotasPdt, 
min(f.Fecha) AS Fecha,
max(f.UltimaFechaPago) AS UltimoPago, 
sum(f.SaldoCapital) AS TtSdoCapital, 
sum(f.SaldoInteres) AS TtSdoInteres, 
sum(f.SaldoCuota) AS TtSdoCuota, 
max(f.DiasCpt) AS DiasMora ,
f.Saldo                         
from
 ( 
/*Inicio SaldoCuotas*/
SELECT 
d.*,
round((d.RcdCpt/d.Valor*100) ,2)PorcRecaudo,
if(round((d.RcdCpt/d.Valor*100) ,2)>=30,'Administrativa','Comercial')TipoCartera,
d.Valor-d.RcdCpt as Saldo,
f.IdCta AS IdCta,
f.Concepto ,
f.NumCuota ,
f.Fecha ,
f.SaldoCapital ,
f.SaldoInteres,
f.SaldoCuota ,
f.UltimaFechaPago,
f.DiasCpt,
if(((f.DiasCpt >= -(2)) and (f.DiasCpt <= 0)),'L1',if(((f.DiasCpt >= 1) and (f.DiasCpt < 10)),'L2',if(((f.DiasCpt >= 10) and (f.DiasCpt <= 15)),'L3',if(((f.DiasCpt >= 16) and (f.DiasCpt <= 30)),'C1',if(((f.DiasCpt >= 31) and (f.DiasCpt <= 60)),'C2',if(((f.DiasCpt >= 61) and (f.DiasCpt <= 90)),'C3',if(((f.DiasCpt >= 91) and (f.DiasCpt <= 99)),'C4',if(((f.DiasCpt >= 100) and (f.DiasCpt <= 104)),'PJ',if(((f.DiasCpt >= 105) and (f.DiasCpt <= 119)),'J1',if(((f.DiasCpt >= 120) and (f.DiasCpt <= 149)),'J2',if((f.DiasCpt >= 150),'DM','Aldia'))))))))))) AS Gestion  
  
FROM
(
SELECT C.*,
if(r.Rcd Is null,0,r.Rcd)RcdCpt
FROM
(
/*Inicio 002CnsAdjduica*/
SELECT
a.IdAdjudicacion ,
a.Valor,
a.BaseComision,
a.Porcentaje,
a.IdTercero1,
c.NombreCompleto Cliente,
a.Estado ,
a.Contrato,
a.IdInmueble,
a.TipodeAdjudicacion,
a.Temporada,
a.Grado,
a.TipoOperacion  
FROM adjudicacion a 
JOIN contabilidad_alttum.terceros c 
ON c.IdTercero = a.IdTercero1 
/*Final 002CnsAdjduica*/
)C

LEFT JOIN 

(
SELECT  
idadjudicacion,
IF( sum(capital)IS NULL,0,SUM(capital))Rcd From recaudos where estado ='Aprobado' and concepto !='GA'group by idadjudicacion
)R on r.idadjudicacion=C.idadjudicacion
where C.estado='Aprobado' or C.Estado='Juridico'
 )d 
left join
(
SELECT
f.IdCta AS IdCta,
f.IdAdjudicacion AS IdAdjudicacion,
f.Concepto AS Concepto,
f.NumCuota AS NumCuota,
f.Fecha AS Fecha,
f.Capital AS Capital,
f.Interes AS Interes,
f.Cuota AS Cuota,
f.SaldoCapital AS SaldoCapital,
f.SaldoInteres AS SaldoInteres,
f.SaldoCuota AS SaldoCuota,
f.UltimaFechaPago AS UltimaFechaPago,
f.Usuario AS Usuario,
f.FechaOperacion AS FechaOperacion,
f.Conse AS Conse,
to_days( curdate( ) ) - to_days( f.Fecha )  AS DiasCpt                    

FROM	financiacion f 
)f
on f.idadjudicacion=d.idadjudicacion
/*final SaldoCuotas*/
)f
 where DiasCpt >-61 and f.SaldoCuota>0  
 group by f.IdAdjudicacion