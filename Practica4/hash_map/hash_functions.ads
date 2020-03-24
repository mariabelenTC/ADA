with Ada.Strings.Unbounded;

package Hash_Functions is

	package ASU renames Ada.Strings.Unbounded;

	use type ASU.Unbounded_String;

	function Hash_Natural() return Hash_Range;

end Comparador_Array;
