with Ada.Strings.Unbounded;


package lista is
   package ASU renames Ada.Strings.Unbounded;
   
   type Cell;
   
   type Word_List_Type is access Cell;
   
   type Cell is record
      Word: ASU.Unbounded_String;
      Next: Word_List_Type;
   end record;

   
   Word_List_Error: exception; 
   
   procedure Add_Word_alfabeto(List: in out Word_List_Type; Word: in ASU.Unbounded_String);
   
   procedure Print_All (List: in Word_List_Type);
   
end lista;

