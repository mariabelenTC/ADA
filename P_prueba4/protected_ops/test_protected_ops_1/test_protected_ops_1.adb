with Ada.Real_Time;
with Ada.Text_IO;
with Procedures;
with Protected_Ops;

procedure Test_Protected_Ops is
	package ATIO renames Ada.Text_IO;
	package ART renames Ada.Real_Time;
	package PO renames Protected_Ops;
	package P renames Procedures;

   use type ART.Time;
begin

	--		el procedimiento Protected_Call no es interrumpido
	--		por otros procedimientos procedimientos cuya ejecucion se encargó
	--		al sistema mediante una llamada a Program_Timer_Procedure

   ATIO.Put_Line(P.Image(ART.Clock) & " Start" );

   PO.Program_Timer_Procedure(P.Timed_Procedure'Access, ART.Clock + ART.Milliseconds(3000));
-- dentro de 3"  que se ejecute lo que sea que haga P.Timed_Procedure'Access
--		procedure Timed_Procedure is
--			use type ART.Time;
--		begin
--			ATIO.Put_Line(Image(ART.Clock) & " Timed_Procedure");
--
--		PO.Program_Timer_Procedure(Procedures.Timed_Procedure'Access,
--														ART.Clock + ART.Milliseconds(1000));
--
--		end Timed_Procedure;

	delay 5.0;

	--P.Procedure_1;
	--Timer_Procedure y este, se ejecutan en el mismo momento.

	PO.Protected_Call(P.Procedure_1'Access);
	------------------------------------------------
	-- P.Procedure_1 se ejecutara en exclusion a los demas
	--		procedure Procedure_1 is
	--		begin
	--			ATIO.Put_Line(Image(ART.Clock) & " Procedure_1");
	--
	--			delay 3.0;

	--		end Procedure_1;
	-----------------------------------------------------------

	-- como tiene que esperar 3" no deja que se ejecute otro que llame
	-- a protected_Call
	-- ni Timer_Procedure

	delay 5.0;

	PO.Protected_Call(P.Procedure_2'Access);
	-------------------------------------------------
	--		procedure Procedure_2 is
	--		begin
	--			ATIO.Put (Image(ART.Clock) & " Procedure_2");
	--
	--			delay 3.0;
	--		end Procedure_2;
	------------------------------------------------------
	-- Espera 3" impidiendo que el Timer_Procedure haga nada

	delay 10.0;

	ATIO.Put_Line(P.Image(ART.Clock) & " Finish");

	-- cuando llega al final todos los Program_Timer_Procedure terminan

end Test_Protected_Ops;
