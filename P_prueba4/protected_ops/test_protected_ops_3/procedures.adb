with Ada.Text_IO;
with Protected_Ops;
with Ada.Real_Time;

package body Procedures is
   package ATIO renames Ada.Text_IO;
	package ART renames Ada.Real_Time;
--____________________________________________________________________________--
   function Image (T: ART.Time) return String is
      SC: ART.Seconds_Count;
      TS: ART.Time_Span;
   begin
      ART.Split(T, SC, TS);
      return ART.Seconds_Count'Image(SC) &  ":" &
        						Duration'Image(ART.To_Duration(TS));
   end Image;
--____________________________________________________________________________--
   procedure Timed_Procedure is
      use type ART.Time;
      Success : Boolean;
   begin
      ATIO.Put (Image(ART.Clock));
      ATIO.Put_Line(" Timed_Procedure deleting www.urjc.es");
      ATIO.New_Line;
      Maps.Delete (A_Map, ASU.To_Unbounded_String("www.urjc.es"), Success);

   end Timed_Procedure;
--____________________________________________________________________________--
	procedure Print_Map is
      C: Procedures.Maps.Cursor := Procedures.Maps.First(Procedures.A_Map);
      use type ASU.Unbounded_String;
   begin
      ATIO.Put_Line("Map");
      ATIO.Put_Line("===");

      while Procedures.Maps.Has_Element(C) loop
         ATIO.Put_Line (ASU.To_String(Procedures.Maps.Element(C).Key) & " " &
                                 ASU.To_String(Procedures.Maps.Element(C).Value));

         Procedures.Maps.Next(C);

         if Procedures.Maps.Has_Element(C) and then
           Procedures.Maps.Element(C).Key = ASU.To_Unbounded_String("www.urjc.es") then
            delay 7.0;
         end if;
      end loop;

   end Print_Map;
--____________________________________________________________________________--

end Procedures;
