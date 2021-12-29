drop procedure MovimientoCuenta;
create procedure MovimientoCuenta(VarCuenta varchar(15),VarIdTercero varchar(60),VarFechaInicial datetime ,VarFechaFinal datetime)
BEGIN
IF VarIdTercero is null
THEN
Select 
d.*,
@Saldo:= @Saldo + d.Debe - d.Haber Saldo 
 From 
Diario d, 
(SELECT @Saldo:= (Select if(sum(debe-haber) is null,0,sum(debe-haber))  from diario where cuenta = VarCuenta and fecha < VarFechaInicial and Estado=1) ) r
Where d.estado = 1 
and Cuenta = VarCuenta    
and d.fecha >= VarFechaInicial and 
d.fecha  <= VarFechaFinal 
ORDER by fecha ;

else 

IF VarCuenta is null
THEN
Select 
d.*,
@Saldo:= @Saldo + d.Debe - d.Haber Saldo 
 From 
Diario d, 
(SELECT @Saldo:= (Select if(sum(debe-haber) is null,0,sum(debe-haber))  from diario where cuenta = VarCuenta and fecha < VarFechaInicial and Estado=1) ) r
Where d.estado = 1 
And IdTercero = VarIdTercero  
and d.fecha >= VarFechaInicial and 
d.fecha  <= VarFechaFinal 
ORDER by fecha ;



ELSE

Select 
d.*,
@Saldo:= @Saldo + d.Debe - d.Haber Saldo 
From 
Diario d, 
(SELECT @Saldo:= (Select if(sum(debe-haber) is null,0,sum(debe-haber))  from diario where cuenta = VarCuenta and fecha < VarFechaInicial and Estado=1) ) r
Where d.estado = 1 
and Cuenta = VarCuenta   
And IdTercero = VarIdTercero
and d.fecha >= VarFechaInicial
and d.fecha  <= VarFechaFinal 
ORDER by fecha  ;
END IF;
end if;
END ; 
