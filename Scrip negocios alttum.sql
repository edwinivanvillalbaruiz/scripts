/*INICIO TIPO CARTERA*/
SELECT 
d.*,
round((d.RcdCpt/d.Valor*100) ,2)PorcRecaudo,
if(round((d.RcdCpt/d.Valor*100) ,2)>=30,'Administrativa','Comercial')TipoCartera,
d.Valor-d.RcdCpt as Saldo
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

 )d