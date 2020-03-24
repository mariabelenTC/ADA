with Ada.Text_IO;

procedure monedasarray is 
package ATIO renames Ada.Text_IO;

type TipoMonedas is array (0..7) of Natural;
conjuntomonedas: TipoMonedas;

-------------------------------------------------------------------------
procedure Pedirmonedas(conjuntomonedas: in out TipoMonedas) is
	moneda: Natural;
	numero:array(0..7) of Natural;
	
	
begin
	numero:=(1,2,5,10,20,50,1,2);
	for k in 0..7 loop
		if k <=5 then 
			ATIO.Put(" introduzca " &  Integer'Image(numero(k))  & "centimos: " );	
		else 
			ATIO.Put(" introduzca " &  Integer'Image(numero(k)) & "Euros: " );
		end if;
		moneda:=Natural'value(ATIO.Get_Line);
		conjuntomonedas(k):= moneda;
	end loop;
end pedirmonedas;
----------------------------------------------------------------------------
procedure ImprimirMonedas(conjuntomonedas: in out TipoMonedas) is
begin
	for K in 0..7 loop
	ATIO.Put_Line(Natural'Image(conjuntomonedas(k)));
    end loop;
end ImprimirMonedas;
----------------------------------------------------------------------------
procedure Contar_Monedas(conjuntomonedas: in out TipoMonedas)  is
	valormonedas: TipoMonedas;
	monedero:TipoMonedas;
	n:Integer;
	TotalCentimos:Natural;
	TotalEuros:Float;
begin
	valormonedas:= (1,2,5,10,20,50,100,200);
	
	for k in 0..7 loop
		monedero(k):=valormonedas(k)*conjuntomonedas(k);
				
	end loop;
	TotalCentimos:= monedero(0) + monedero(1) + monedero(2) + 
	monedero(3)+ monedero(4) + monedero(5) + monedero(6) + monedero(7);
	
	TotalEuros:= Float(totalcentimos) / 100.0;
	ATIO.Put("tienes en total: ");
	ATIO.Put(Float'image(totalEuros));
	ATIO.Put(" Euros");
end Contar_Monedas;
----------------------------------------------------------------------------
begin
	ATIO.Put_Line("introduzco monedas");
	Pedirmonedas(conjuntomonedas);
	ATIO.Put_Line("esto es todo lo que se ha guardado en el array de monedas introducidas");
	ImprimirMonedas(conjuntomonedas);
	Contar_Monedas(conjuntomonedas);

end monedasarray;
