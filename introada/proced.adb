with Ada.Text_IO;


procedure proced is
	package ATIO renames Ada.Text_IO;
	
	procedure Suma (A: in Integer; B: in Integer; C: out Integer) is
	begin
		C := A + B;
	end Suma;
	
	procedure triplicar (A: in out Integer) is 
	begin
		A:=A*3;
	end triplicar;
	
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
	
	procedure Incrementar (Ptr: access Integer) is
	begin
		Ptr.all := Ptr.all + 1;
	end Incrementar;
	
	P: aliased Integer;
	Q: Integer;	
begin
------------------------------------------------------------------------	
	P := Integer'Value(ATIO.Get_Line);
	Suma (P, P, Q);
	ATIO.Put_Line ("El doble de " & Integer'Image(P) & 
					" es " & Integer'Image(Q));
------------------------------------------------------------------------
	P := Integer'Value(ATIO.Get_Line);
	ATIO.Put ("El triple de " & Integer'Image(P));
	Triplicar(P);
	ATIO.Put_Line (" es " & Integer'Image(P));
------------------------------------------------------------------------	
	P := Integer'Value(ATIO.Get_Line);
	ATIO.Put_Line ("El factorial de " & Positive'Image(P) & 
					" es " & Positive'Image(Factorial(P)));
------------------------------------------------------------------------
	P:= Integer'Value(ATIO.Get_Line);
	ATIO.Put("Un incremento de " & Integer'Image(P));
	Incrementar (P'Access);
	ATIO.Put_Line (" es " & Integer'Image(P));

	exception 
		when Constraint_Error =>
			ATIO.Put_Line("No ha introducido un numero");
	
end proced;
