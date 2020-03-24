with Ada.Text_IO;
procedure ejer65 is

	package ATIO renames Ada.Text_IO;

	type Apariciones is array (0..10) of Integer;

	conjuntonumeros:Apariciones;
-------------------------------------------------------------------------------------
--	function No_repetido (conjuntonumeros:in out Apariciones;
		--					numero: in out Integer) return Boolean is
--	
--	k:Integer;
--	repetido: Boolean;
--	begin
--		k:=0;
--		repetido:= False;
--		while (not repetido and k<1000) loop
--			if(conjuntonumeros(k)=numero) then
--				repetido:= True;
--			end if;
--			k:= k+1;
--		end loop;
--		return not repetido;
--		
--	end No_repetido;
------------------------------------------------------------------------------------	
	procedure Intro_Numero(conjuntonumeros:in out Apariciones) is
	numero:Integer;
	numerocomparacion:Integer;
	n:Integer;
	begin
		n:=0;
		numerocomparacion:=0;	
		while n<=10 loop
			numero:=Integer'Value(ATIO.Get_Line);
			--if No_repetido(conjuntonumeros,numero)then
			if numerocomparacion/= numero then
				conjuntonumeros(n):=numero;
				n:=n+1;
			end if;
			numerocomparacion:=numero;
			exit when numero=0;
			
		end loop; 

	end Intro_Numero;
------------------------------------------------------------------------------------
	procedure print_array (conjuntonumeros:Apariciones) is

	begin
		for k in 0..10 loop
			if conjuntonumeros(k)/=0 then
				ATIO.Put_Line(Integer'Image(conjuntonumeros(k)));
			end if;
		end loop;
	end print_array;
-------------------------------------------------------------------------------------
	function multiplicar(conjuntonumeros: in out Apariciones) return Integer is
		producto:Integer;
	
		k:Integer;
	begin
		producto:=1;
		k:=0;
		while k<10 and conjuntonumeros(K)/=0 loop
			producto:=conjuntonumeros(K)*producto;
			k:=k+1;
		end loop;
		return producto;
	end multiplicar;
------------------------------------------------------------------------------------
	resultado:Integer;

begin
	
	conjuntonumeros:=(others=>0);
	Intro_Numero(conjuntonumeros);
	print_array(conjuntonumeros);
	if conjuntonumeros(0) /= 0 then 
	resultado:=multiplicar(conjuntonumeros);
	ATIO.Put_Line(Integer'Image(resultado));
	else
		ATIO.Put_Line("introduzca numeros");
	end if;

end ejer65;