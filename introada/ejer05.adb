with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure ejer005 is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;

	Totalcentimos:Integer;
	totalEuros: Float;

	function Contar_Monedas(mon:Integer;Rep:Integer) return Integer is
		Num:Integer;
	begin
		Num:= mon*Rep;
		return Num;
	end Contar_Monedas;
	
		--
	function Sumar_Monedas(Rep1: Integer;Rep2:Integer;
						   Rep5: Integer;Rep10: Integer;
						   Rep20: Integer;Rep50: Integer; RepE1:Integer; RepE2:Integer) return Integer is
						   
		Cent_1,Cent_2,Cent_5,Cent_10,Cent_20,Cent_50,Euro_1,Euro_2: Integer;
	
	begin
		Cent_1:=1;
		Cent_2:=2;
		Cent_5:=5;
		Cent_10:=10;
		Cent_20:=20;
		Cent_50:=50;
		Euro_1:=100;
		Euro_2:=200;
		
		return Contar_Monedas(Cent_1,Rep1) + Contar_Monedas(Cent_2,Rep2) +
			   Contar_Monedas(Cent_5,Rep5) + Contar_Monedas(Cent_10,Rep10) +
			   Contar_Monedas(Cent_20,Rep20) + Contar_Monedas(Cent_50,Rep50)+
			   Contar_Monedas(Euro_1,RepE1)+ Contar_Monedas(Euro_2,RepE2);
		
	end Sumar_Monedas;
	

begin
	
	
		ATIO.Put("monedas de 1 centimo: ");
		C1:=Integer'value(ATIO.Get_Line);

	
	totalcentimos:=Sumar_Monedas(C1,C2,C5,C10,C20,C50,E1,E2);
	totalEuros:= Float(totalcentimos) / 100.0;
	ATIO.Put("tienes en total: ");
	ATIO.Put(Float'image(totalEuros));
	ATIO.Put(" Euros");


end ejer005;

