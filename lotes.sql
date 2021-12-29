 SELECT
i.IdInmueble,
i.Estado,
i.ManzanaNumero,
i.LoteNumero,
d.Valor,
d.CuotaFnc,
d.estado AS EStadoOp,
d.IdAdjudicacion,
t.Telefono1,
t.Telefono2,
t.Celular,
t.Email,
d.Identificacion,
d.Direccion,
d.TipoCartera,
r.TtRcd,
r.FechaREc 
FROM
inmuebles i
LEFT JOIN ( SELECT * FROM 004cnsadjudica WHERE estado != 'Desistido' ) d ON d.IdInmueble = i.IdInmueble
LEFT JOIN
(
SELECT
IdAdjudicacion,
sum( Capital + InteresCte + InteresMora ) TtRcd,
max( Fecha ) FechaREc 
FROM
recaudos 
WHERE
estado = 'Aprobado' 
GROUP BY
IdAdjudicacion 
) r ON r.IdAdjudicacion = d.IdAdjudicacion
LEFT JOIN 
( 
SELECT IdTercero,
Telefono1, 
Telefono2, 
Celular,
Email 
FROM 007guardian.terceros ) t ON t.IdTercero = d.idtercero1