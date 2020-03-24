package body Operaciones is

	procedure Doblar (A: in out Integer) is
	begin
		A := 2 * A;
	end Doblar;

	function Factorial (N: Positive) return Positive is
	begin
		if N = 1 then
			return 1;
		else
			return N * Factorial(N-1);
		end if;
	end Factorial;
	
	procedure Incrementar (Ptr: access Integer) is
	begin
		Ptr.all := Ptr.all + 1;
	end Incrementar;

end Operaciones;
