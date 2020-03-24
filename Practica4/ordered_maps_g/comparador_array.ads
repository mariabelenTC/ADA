with Ada.Strings.Unbounded;

package Comparador_Array is

	package ASU renames Ada.Strings.Unbounded;

	use type ASU.Unbounded_String;

	function Menor(Primero: ASU.Unbounded_String; Segundo: ASU.Unbounded_String) return Boolean;

end Comparador_Array;
