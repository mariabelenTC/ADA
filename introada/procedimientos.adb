with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Sub_1 is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	
	procedure Suma (A: in Integer; B: in Integer; C: out Integer) is
	begin
		C := A + B;
	end Suma;
	US:ASU.Unbounded_String;
	P: Integer;
	Q: Integer;
begin
	
	US:=ASU.To_Unbounded_String(ATIO.Get_Line);
	
	P:=Integer'value(ASU.To_String(US));
	
	Suma (P, P, Q);
	ATIO.Put_Line ("El doble de " & Integer'Image(P) & " es " &
	Integer'Image(Q));
end Sub_1;
