with Ada.Text_IO;


procedure sucesivo is
	package ATIO renames Ada.Text_IO;
	type Tiponumeros is array (1..10) of Integer;
	conjunto_numeros:Tiponumeros;

	procedure Intro_Numero(conjuntonumeros:in out Tiponumeros) is
	numero:Integer;
	numerocomparacion:Integer;
	k:Integer;
	begin
		numerocomparacion:=0;	
		k:=1;
		while k<=10 and numero/=0 loop

			numero:=Integer'Value(ATIO.Get_Line);
			if numerocomparacion /= numero then 
			conjuntonumeros(k):=numero;
			
			k:=K+1;
			end if;
			numerocomparacion:=numero;
			
		end loop; 
		

	end Intro_Numero;
begin
Intro_Numero(conjunto_numeros);
for k in 1..10 loop
ATIO.Put_Line(Integer'Image(conjunto_numeros(k)));
end loop;
	
		
		
	
end sucesivo;