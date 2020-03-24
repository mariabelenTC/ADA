with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Word_Lists;

procedure Prueba_Sorted_Add_Word is
   package ASU renames Ada.Strings.Unbounded;
   List : Word_Lists.Word_List_Type;
begin

   Word_Lists.Sorted_Add_Word (List, "xen");
   Word_Lists.Sorted_Add_Word (List, "pavo");
   Word_Lists.Sorted_Add_Word (List, "bonito");
   Word_Lists.Sorted_Add_Word (List, "cachorro");
   Word_Lists.Sorted_Add_Word (List, "abecedario");
   Word_Lists.Sorted_Add_Word (List, "ramona");
   Word_Lists.Sorted_Add_Word (List, "saturno");
   Word_Lists.Sorted_Add_Word (List, "vivo");


   Word_Lists.Print_All (List);

end Prueba_Sorted_Add_Word;
