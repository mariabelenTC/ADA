with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure introducirpalabras is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;

	US:ASU.Unbounded_String:=ASU.To_Unbounded_String(ATIO.Get_Line);
	nombre:ASU.To_String(US);
	
	procedure intro(Palabra: in out US) is
	begin
		null;
	end intro;
begin
	ATIO.Put_Line("hola");
end introducirpalabras;