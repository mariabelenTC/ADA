package body Comparador_Array is

	function Menor(Primero: ASU.Unbounded_String; Segundo: ASU.Unbounded_String) return Boolean is
	begin
		if(Primero < Segundo) then
			return True;
		else
			return False;
		end if;
	end Menor;

end Comparador_Array;
