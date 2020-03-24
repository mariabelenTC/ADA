with Ada.Text_IO;
With Ada.Strings.Unbounded;

procedure Registros is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;

	type Persona is record
		Nombre: ASU.Unbounded_String := ASU.To_Unbounded_String("holiiiiii ");
		Edad: Integer:= 20;
	end record;
	
	P: Persona;
	Q: Persona;
begin
	
	P.Edad:=15;
	ATIO.Put_Line(ASU.To_String(P.Nombre));
	ATIO.Put_Line(Integer'Image(P.Edad));
	P:=(ASU.To_Unbounded_String("Luis"),25);
	ATIO.Put_Line(ASU.To_String(P.Nombre));
	ATIO.Put_Line(Integer'Image(P.Edad));
	
	p:=(Nombre=> ASU.To_Unbounded_String("Pepe"), Edad=> 10);
	ATIO.Put_Line(ASU.To_String(P.Nombre));
	ATIO.Put_Line(Integer'Image(P.Edad));
end Registros;