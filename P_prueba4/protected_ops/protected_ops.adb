with Ada.Real_Time.Timing_Events;
with Ada.Text_IO;

package body Protected_Ops is
   package ART renames Ada.Real_Time;
   package ARTTE renames Ada.Real_Time.Timing_Events;

   Timed_Procedure : Procedure_A;
--___________________________________________________________________________---

   protected P is --????????????????????????????????????
      procedure Timer_Procedure (TE: in out ARTTE.Timing_Event); --Timing_Event: Sincronizacion_Evento
      procedure Call_Procedure (H: Procedure_A);
   end P;

--___________________________________________________________________________---

   protected body P is

      procedure Timer_Procedure (TE: in out ARTTE.Timing_Event) is
      begin
         Timed_Procedure.all;
      end Timer_Procedure;

      procedure Call_Procedure (H: Procedure_A) is
      begin
         H.all;
      end Call_Procedure;

   end P;

--___________________________________________________________________________---

   TE: ARTTE.Timing_Event;
   procedure Program_Timer_Procedure (H: Procedure_A; T: Ada.Real_Time.Time) is
      use type ART.Time;
   begin
      Timed_Procedure := H;

      ARTTE.Set_Handler(TE,T,P.Timer_Procedure'Access);

   end Program_Timer_Procedure;
--___________________________________________________________________________---

	procedure Protected_Call (H: Procedure_A) is
   begin
      P.Call_Procedure (H);
   end Protected_Call;

--___________________________________________________________________________---
end Protected_Ops;
