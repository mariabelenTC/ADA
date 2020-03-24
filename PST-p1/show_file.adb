with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;




procedure Show_File is
   package ACL renames Ada.Command_Line;
   package ASU renames Ada.Strings.Unbounded;
   
   Usage_Error: exception;
   procedure imprimir_fichero(File_Name: in out ASU.Unbounded_String) is
      
      File: Ada.Text_IO.File_Type;
 
      Finish: Boolean;
      Line: ASU.Unbounded_String;
   begin
      File_Name := ASU.To_Unbounded_String(ACL.Argument(1));        
      Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));

      Finish := False;

      while not Finish loop
         begin
            Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
            Ada.Text_IO.Put_Line(ASU.To_String(Line));

         exception
            when Ada.IO_Exceptions.End_Error =>
             Finish := True;
         end;
      end loop;
      Ada.Text_IO.Close(File);
   end imprimir_fichero;

   File_Name: ASU.Unbounded_String;
      
begin

   if ACL.Argument_Count /= 1 then
      raise Usage_Error;
   end if;
   
   imprimir_fichero(File_Name);
   exception
   when Usage_Error =>
      Ada.Text_IO.Put_Line("Use: ");
      Ada.Text_IO.Put_Line("  " & ACL.Command_Name & " <file>");
   
end Show_File;
