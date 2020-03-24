with Ada.Real_Time;

package Procedures is
	package ART renames Ada.Real_Time;
	
   function Image (T: ART.Time) return String;
   procedure Timed_Procedure;
   procedure Procedure_1;
   procedure Procedure_2;

end Procedures;
