with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Array_De_Registros is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	
	type Persona is record
		Nombre: ASU.Unbounded_String := ASU.To_Unbounded_String(" ");
		Edad:Integer := 20;
	end record;
	
	
	type Grupo is array (1..10) of Persona;
	L: Grupo;
begin
	L(1).Edad := 15;
	ATIO.Put_Line(Integer'Image(L(1).Edad));
	
	L(1) := (ASU.To_Unbounded_String("Luis"), 25);
	ATIO.Put_Line(ASU.To_String(L(1).Nombre));
	ATIO.Put_Line(Integer'Image(L(1).Edad));
	

end Array_De_Registros;
