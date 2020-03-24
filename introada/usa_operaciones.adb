with Ada.Text_IO;
with Operaciones;

procedure Usa_Operaciones is
	package ATIO renames Ada.Text_IO;
	
	P: aliased Integer;
	Q: Positive;
begin
------------------------------------------------------------------------
	P := Integer'Value(ATIO.Get_Line);
	ATIO.Put ("El doble de " & Integer'Image(P));
	Operaciones.Doblar(P);
	ATIO.Put_Line (" es " & Integer'Image(P));
------------------------------------------------------------------------	
	P := Integer'Value(ATIO.Get_Line);
	ATIO.Put("El factorial de " & Positive'Image(P));
	Q:=Operaciones.Factorial (P);
	ATIO.Put_Line (" es " & Positive'Image(Q));
------------------------------------------------------------------------
	P:= Integer'Value(ATIO.Get_Line);
	ATIO.Put("Un incremento de " & Integer'Image(P));
	Operaciones.Incrementar (P'Access);
	ATIO.Put_Line (" es " & Integer'Image(P));
------------------------------------------------------------------------
	
end Usa_Operaciones;
