with Ada.Text_IO;
with Ada.Strings.Unbounded;
procedure monedasrecord is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	type monedas is record
		ValorMoneda: Natural:=0;
		RepeticionMoneda:Natural:=0;
		total:Natural;
	end record;

	type tipomonedas is array (0..7) of monedas;
	monedero:tipomonedas;
	
	Vmoneda:array (0..7) of Natural;
	numero:array(0..7) of Natural;
	
	suma:Natural;
	
begin
	suma:=0;
	numero:=(1,2,5,10,20,50,1,2);
	Vmoneda:=(1,2,5,10,20,50,100,200);

	for k in 0..7 loop
		if k <=5 then
			ATIO.Put(" introduzca " &  Integer'Image(numero(k))  & " centimos: " );
		else 
			ATIO.Put(" introduzca " &  Integer'Image(numero(k)) & " euros :" );
		end if;
		monedero(k).RepeticionMoneda:=Natural'value(ATIO.Get_Line);
		monedero(k).ValorMoneda:=vmoneda(k);
	end loop;
	
	for k in 0..7 loop
		
		monedero(k).total:=monedero(k).RepeticionMoneda * monedero(k).ValorMoneda;
	end loop;
	
	for k in 0..7 loop
		suma:=monedero(k).total+suma;
	end loop;
	ATIO.Put("total monedas:  " & Natural'Image(suma));







----comprobar---------------
	Ada.Text_IO.New_Line;
	ATIO.Put("monedas introducidas guardadas en el array:  ");
	for k in 0..7 loop	
		ATIO.Put(Natural'Image(monedero(k).RepeticionMoneda));
	end loop;
	Ada.Text_IO.New_Line;
	ATIO.Put("valor de las monedas guardadas en el array: ");
	for k in 0..7 loop
		ATIO.Put(Natural'Image(monedero(k).ValorMoneda));
	end loop;
	Ada.Text_IO.New_Line;


	ATIO.Put_Line("holamundo");

end monedasrecord;