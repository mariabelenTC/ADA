with Ada.Text_IO;

procedure ejer38 is
	package ATIO renames Ada.Text_IO;
	k:Integer;
begin
	k:=Integer'Value(ATIO.Get_Line);
	for i in 1..k loop
		ATIO.Put_Line("hola");
	end loop;
end ejer38;