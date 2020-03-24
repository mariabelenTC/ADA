with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Exceptions;
with Ada.IO_Exceptions;

procedure ficher is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package ACL renames Ada.Command_Line;
	package AIOE renames Ada.IO_Exceptions;

	Usage_Error: exception;
	
	US: ASU.Unbounded_String;
	Fich: ATIO.File_Type;
	
	Finish: Boolean; 
	US2:ASU.Unbounded_String;
	Error_Argument:exception;

begin
	ATIO.Open(Fich, ATIO.Append_File, "prueba.tmp");
	ATIO.Put_Line("Introduce palabra: ");
	ATIO.Put(Fich, ATIO.Get_Line);
	ATIO.Put_Line(" ");
	ATIO.Close(Fich);
	
	if ACL.Argument_Count /= 1 then
		raise Error_Argument;
    end if;
    
	US := ASU.To_Unbounded_String(ACL.Argument(1));        
    ATIO.Open(Fich, ATIO.In_File, ASU.To_String(US));
	Finish := False;
	
	while not Finish loop
      begin
	     US2 := ASU.To_Unbounded_String(ATIO.Get_Line(Fich));
	     ATIO.Put_Line(ASU.To_String(US2));
		
		exception
			when AIOE.End_Error =>
			Finish := True;
		end; 
    end loop;
    ATIO.Close(Fich);
	
	
	exception
   
    when Error_Argument =>
		ATIO.Put_Line("introduzca esto por ejemplo:     ./ficher prueba.tmp ");	
end ficher;
