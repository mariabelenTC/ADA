with Ada.Text_IO;

procedure ejer265 is
	package ATIO renames Ada.Text_IO;
	
---------------------------------------------------------------------------
	function no_es_cero (numero: in out Integer) return Boolean is
		escero:boolean;
	begin
		escero:=False;
		if not escero and numero/= 0 then
			return escero=True;
		else 
			return escero=False;
		end if;
	end no_es_cero;
---------------------------------------------------------------------------
	procedure pedir_numero(numero:in out Integer; anterior:in out Integer) is
	numero_intro:Integer;	
	begin		
		ATIO.Put("introduce el siguiente numero:  ");
	
		 
			numero_intro:=Integer'Value(ATIO.Get_Line);
			if anterior= numero_intro then
				numero:=1;
			else
				numero:=numero_intro;
			end if;
			anterior:=numero;		
	end pedir_numero;
-------------------------------------------------------------------------
	function producto(numero:in out Integer) return Integer is
	C:Integer;
	anterior:Integer:=1;

	begin
		C:=1;
		
		loop
		pedir_numero(numero,anterior);
			--pedir_numero(numero);
			if not no_es_cero(numero) then
				C:=numero*C;
			end if;
		exit when numero=0;
		end loop;
		return C;
	end producto;
----------------------------------------------------------------------------
	procedure imprimir_resultado(numero:in out Integer) is
	begin 
		ATIO.Put_Line("El producto es :  " & Integer'Image(numero));

	end imprimir_resultado;
------------------------------------------------------------------------

	numero:Integer;
begin
	numero:=1;

	ATIO.Put_Line("si quieres salir pulsa 0 ");
	numero:=producto(numero);
	imprimir_resultado(numero);
	
	
end ejer265;