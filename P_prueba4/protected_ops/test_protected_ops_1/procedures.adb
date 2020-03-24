with Ada.Text_IO;
with Protected_Ops;
with Ada.Real_Time;

package body Procedures is
	package ART renames Ada.Real_Time;
	package PO renames Protected_Ops;
	package ATIO renames Ada.Text_IO;
--___________________________________________________________________________---

   function Image (T: ART.Time) return String is
      SC: ART.Seconds_Count; -- segundos contados
      TS: ART.Time_Span; -- tiempo de intervalo
   begin
      ART.Split(T, SC, TS);  --  division
      return ART.Seconds_Count'Image(SC) & ":" & Duration'Image(ART.To_Duration(TS));
   end Image;

--___________________________________________________________________________---

   procedure Timed_Procedure is --procedimiento de tiempo
      use type ART.Time;
   begin
      ATIO.Put_Line(Image(ART.Clock) & " Timed_Procedure");

		-- vuelve a programar en el futuro para que un segundo despues vuelva a ejecutarse esto
		-- se reprograma
		
      PO.Program_Timer_Procedure(Procedures.Timed_Procedure'Access,
		 													ART.Clock + ART.Milliseconds(1000));

   end Timed_Procedure;

--___________________________________________________________________________---

   procedure Procedure_1 is
   begin
      ATIO.Put_Line(Image(ART.Clock) & " Procedure_1");

      delay 3.0;
   end Procedure_1;

--___________________________________________________________________________---

   procedure Procedure_2 is
   begin
      ATIO.Put (Image(ART.Clock) & " Procedure_2");

      delay 3.0;
   end Procedure_2;

--___________________________________________________________________________---

end Procedures;
