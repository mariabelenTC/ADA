with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Word_Lists;

procedure Prueba_Length_Average is
   package ASU renames Ada.Strings.Unbounded;
   Length : Natural;
   List : Word_Lists.Word_List_Type;
begin

   Word_Lists.Add_Word (List, ASU.To_Unbounded_String("hola"));
   Word_Lists.Add_Word (List, ASU.To_Unbounded_String("Jaime"));
   Word_Lists.Add_Word (List, ASU.To_Unbounded_String("bonita"));

   Length := Word_Lists.Length_Average (List);

   Ada.Text_IO.Put_Line(Natural'Image(Length));

end Prueba_Length_Average;
