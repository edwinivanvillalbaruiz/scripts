update financiacion f,004recaudosresumidos r 
set f.saldocapital=f.capital+r.Capital,f.SaldoInteres=f.interes+r.Interescte, 
 f.saldocuota=f.cuota+r.cuota where f.idcta=r.id