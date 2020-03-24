with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Sub_3 is
	package ASU renames Ada.Strings.Unbounded;
	function Factorial (N: Positive) return Positive is
		Resultado: Integer;
	begin
		if N = 1 then
			Resultado := 1;
		else
			Resultado := N * Factorial(N-1);
		end if;
		
		return Resultado;
	
	end Factorial;
	
	US:ASU.Unbounded_String;
	
	P: Integer;
	
begin
	US:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
	P := Integer'value(ASU.To_String(US));
	
	Ada.Text_IO.Put_Line ("El factorial de " & Positive'Image(P) & " es " & Positive'Image(Factorial(P)));

end Sub_3;

