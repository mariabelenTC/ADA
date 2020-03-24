with Ada.Text_IO;

procedure ejer64 is
	package ATIO renames Ada.Text_IO;
	
---------------------------------------------------------------------------
	function no_es_menosuno (numero: in out Integer) return Boolean is
		esmenosuno:boolean;
	begin
		esmenosuno:=False;
		if not esmenosuno and numero/= -1 then
			return esmenosuno=True;
		else 
			return esmenosuno=False;
		end if;
	end no_es_menosuno;
-----------------------------------------------------------------------------
	procedure pedir_numero(numero:in out Integer) is
	begin
		ATIO.Put("introduce el siguiente numero:  ");
		numero:=Integer'Value(ATIO.Get_Line);
	end pedir_numero;
-----------------------------------------------------------------------------
	function calcularsuma(numero:in out Integer) return Integer is
	C:Integer;

	begin
		C:=0;
		loop
			pedir_numero(numero);
			if not no_es_menosuno(numero) then
				C:=numero+C;
				--C:=numero+A;
				--A:=C;
			end if;
		exit when numero=-1;
		end loop;
		return C;
	end calcularsuma;
---------------------------------------------------------------------------
	procedure imprimir_resultado(numero:in out Integer) is
	begin 
		ATIO.Put_Line("El resultado es :  " & Integer'Image(numero));

	end imprimir_resultado;
------------------------------------------------------------------------
	numero:Integer;
begin
	numero:=0;
	ATIO.Put_Line("si quieres salir pulsa -1 ");
	numero:=calcularsuma(numero);
	imprimir_resultado(numero);
	
end ejer64;