with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure intro_numero is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	
	--US:ASU.Unbounded_String;
	Num2:Integer;
begin

	--US:= ASU.To_Unbounded_String(ATIO.Get_Line);
	--Num2:=Integer'value(ASU.To_String(US));
	Num2:=Integer'value(ATIO.Get_Line);

end intro_numero;
