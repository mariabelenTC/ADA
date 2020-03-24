with Ada.Real_Time;
with Ada.Text_IO;
with Procedures;
with Protected_Ops;
with Ada.Strings.Unbounded;

procedure Test_Protected_Ops_2 is


   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;
	package PO renames Protected_Ops;
	package ART renames Ada.Real_Time;
	package P renames Procedures;

	use type ART.Time;
   Value   : ASU.Unbounded_String;

begin
--		PROBLEMA: VARIOS HILOS ESTAN EJECUTANDO CONCURRENTEMENTE CONDIGO
--					QUE ACCEDE A UNA MISMA ESTRUCCTURA DE DATOS
--
--		El programa ppal comienza encargando al sistema
--		que 5000ms despues se ejecute el procedimiento P.Timed_Procedure
--		Llegado ese momento el sistema creará
--		un nuevo hilo de ejecucion para llamar a P.Timed_Procedure
--		cuyo codigo borrará un elemento del Map
--


   ATIO.Put_Line(P.Image(ART.Clock) & " Start");

   -- Program a delete of "www.urjc.es" in 5000ms
   PO.Program_Timer_Procedure(P.Timed_Procedure'Access,
      								ART.Clock + ART.Milliseconds(5000));
	------------------------------------------------------------------------
	-- tendro de 5":

	--		procedure Timed_Procedure is
	--			use type ART.Time;
	--			Success : Boolean;
	--		begin
	--			ATIO.Put_Line(Image(ART.Clock) & " Timed_Procedure deleting www.urjc.es");
	--			ATIO.New_Line;
	--
	--			-- borra uno de los nodos.
	--			Maps.Delete (A_Map, ASU.To_Unbounded_String("www.urjc.es"), Success);
	--
	--		end Timed_Procedure;
	------------------------------------------------------------------------------



--		Antes de que llegue ese momento,
--		el programa ppal prosigue su ejecución	insertando 4 elementos en un Map.

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("facebook.com"),
            				ASU.To_Unbounded_String ("69.63.189.16"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("google.com"),
             				ASU.To_Unbounded_String ("66.249.92.104"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("www.urjc.es"),
             				ASU.To_Unbounded_String ("212.128.240.25"));

   P.Maps.Put (P.A_Map, ASU.To_Unbounded_String ("latimes.com"),
             				ASU.To_Unbounded_String ("69.63.189.11"));

 --Print_Map se retrasará mientras el cursor está visitando el nodo    ????????
 --"www.urjc.es" de la lista enlazada


--		por ultimo el programa ppal llama a Print_Map y mientras que
--		dentro de este procedimiento el cursor está situado sobre el nodo "www.urjc.es"
--		llega el instante en el que el sistema tiene que ejecutar P.Timed_Procedure
--		Este procedimiento borra precisamente esa celda apuntada por el cursor.

	P.Print_Map;

--------------------------------------------------------------------------------
--		procedure Print_Map is
--			C: Procedures.Maps.Cursor := Procedures.Maps.First(Procedures.A_Map);
--			use type ASU.Unbounded_String;
--		begin
--			ATIO.Put_Line ("Map");
--			ATIO.Put_Line ("===");
--
--			while Procedures.Maps.Has_Element(C) loop
--			ATIO.Put_Line(ASU.To_String(Procedures.Maps.Element(C).Key) & " " &
--										ASU.To_String(Procedures.Maps.Element(C).Value));
--			Procedures.Maps.Next(C);
--
--			if Procedures.Maps.Has_Element(C) and then
--		  		Procedures.Maps.Element(C).Key = ASU.To_Unbounded_String("www.urjc.es") then
--				=====================================================================
--					EN ESTE MOMENTO
-- 				SE EJECUTA EL Timed_Procedure:
--			
--					ATIO.Put_Line(Image(ART.Clock) & " Timed_Procedure deleting www.urjc.es");
--					ATIO.New_Line;
--
--					-- borra uno de los nodos.
--					Maps.Delete (A_Map, ASU.To_Unbounded_String("www.urjc.es"), Success);
--				=====================================================================
--				delay 7.0;
--			end if;
--		end loop;
--
--end Print_Map;
--------------------------------------------------------------------------------

--		El hilo que ha ejecutado el procedimiento P.Timed_Procedure se ha ejecutado
--		mientras que el hilo del programa ppal estaba estaba ejecutando Print_Map
--		La operacion de borrar provoca que el cursor que está usando Print_Map
--		para recorrer el Map quede inconsistente,
--		pues el puntero de cursor apunta a un elemento que ha sido borrado
-- 	POR ESO FALLA CON UNA EXCEPTION

   ATIO.Put_Line(P.Image(ART.Clock) & " Finish");

end Test_Protected_Ops_2;
