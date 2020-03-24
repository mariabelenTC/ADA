with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure escribir is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	
	
	type TipoNombre is array (1..3) of ASU.Unbounded_String;
	conjuntoNombres: TipoNombre;
	

	procedure escribir (nombre:TipoNombre) is
	
	
	begin
	
		for k in 1..3 loop
			ATIO.Put_Line(" La alumna " & ASU.To_String(nombre(k)) & " del colegio");
		end loop;
	end escribir;

	procedure introducirnombre(nombre:in out TipoNombre) is
	US:ASU.Unbounded_String;
	
	begin
		
		for k in 1..3 loop
			US:=ASU.To_Unbounded_String(ATIO.Get_Line);
			nombre(k):=US;
			
		end loop;
	end introducirnombre;


	--nombre:array (1..3) of String(1..5);
	--n: integer;
begin
	--conjuntoNombres:=("maria", "belen", "sofia");
	introducirnombre(conjuntoNombres);
	--n:=1;
	escribir(conjuntoNombres);
	ATIO.Put_Line("hola");
	--for k in 1..3 loop
	--	ATIO.Put_Line(" La alumna " & nombre(n) & " del colegio compañia");
	--	n:= n + 1;
	--end loop;
end escribir;

	
