with Ada.Real_Time;
with Ada.Text_IO;
with Procedures;
with Protected_Ops;
with Ada.Strings.Unbounded;

procedure Test_Protected_Ops_3 is


   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;
	package PO renames Protected_Ops;
	package P renames Procedures;
	package ART renames Ada.Real_Time;

	use type ART.Time;
   Value   : ASU.Unbounded_String;

begin


   ATIO.Put_Line(P.Image(ART.Clock) & " Start" );

   -- Program a delete of "www.urjc.es" in 5000ms
   PO.Program_Timer_Procedure(P.Timed_Procedure'Access,
							ART.Clock + ART.Milliseconds(5000));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("facebook.com"),
             				ASU.To_Unbounded_String ("69.63.189.16"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("google.com"),
             				ASU.To_Unbounded_String ("66.249.92.104"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("www.urjc.es"),
             				ASU.To_Unbounded_String ("212.128.240.25"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("latimes.com"),
             				ASU.To_Unbounded_String ("69.63.189.11"));

   -- Print_Map will be delayed while the cursor is visiting node
   --  "www.urjc.es" of the linked list



--		Protegiendo la ejecucion de Print_Map haciendo que se llame
--		a través de PO.Protected_Call se consigue que el hilo del programa ppal que
--		se está ejecutando Print_Map no pueda ser interrumpido
--		mientras que está recorriendo el Map por el hilo del programa ppl que intenta
--		borrar un elemento. Por ello en este caso el programa termina sin elevar
--		una exception, ya que no se borra el elemento del Map
--		hasta que ha concluido su ejecucion Print_Map.
--

	PO.Protected_Call(P.Print_Map'Access);
--------------------------------------------------------------------------------
		--procedure Print_Map is
		--	C: Procedures.Maps.Cursor := Procedures.Maps.First(Procedures.A_Map);
		--	use type ASU.Unbounded_String;
		--begin
		--	ATIO.Put_Line ("Map");
		--	ATIO.Put_Line ("===");
		--
		--	while Procedures.Maps.Has_Element(C) loop
		--		ATIO.Put_Line(ASU.To_String(Procedures.Maps.Element(C).Key) & " " &
		--										ASU.To_String(Procedures.Maps.Element(C).Value));
		--		Procedures.Maps.Next(C);
		--
		--		if Procedures.Maps.Has_Element(C) and then
		--		  Procedures.Maps.Element(C).Key = ASU.To_Unbounded_String("www.urjc.es") then
		--			delay 7.0;
		--		end if;
		--	end loop;
		--
		--end Print_Map;
		-- HASTA QUE NO TERMINE NO SE PUEDE EJECUTAR NADA MAS.

--------------------------------------------------------------------------------
--  PASADOS LOS 7" SI SE PUEDE EJECUTAR TIME P.Timed_Procedure'Access Y BOORA.
delay 5.0;
P.Print_Map;

   delay 2.0;

   ATIO.Put_Line(P.Image(ART.Clock) & " Finish" );

end Test_Protected_Ops_3;
