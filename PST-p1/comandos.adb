with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;

procedure comandos is
	package ACL renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	Usage_Error: exception;
	
	procedure Seleccionar_Opciones (option:in out Integer) is
		begin
			loop
   				ATIO.New_Line;
				ATIO.Put_Line("Options");
				ATIO.Put_Line("1 Add word");
				ATIO.Put_Line("2 Delete word");
				ATIO.Put_Line("3 Search word");
				ATIO.Put_Line("4 Show all word");
				ATIO.Put_Line("5 Quit");
				ATIO.New_Line;
				ATIO.Put("Your option? ");
				option:=Integer'Value(ATIO.Get_line);
				ATIO.New_Line;	
				if  option = 1 then
					ATIO.Put("añado palabra");	
				elsif option = 2 then
					ATIO.Put("borrar palabra");
				elsif option=3 then
					ATIO.Put("buscar palabra");
				elsif option = 4 then
					ATIO.Put_Line("mostrar todas las palabras");
				else 
					ATIO.Put("opcion incorrecta");
				end if;
				exit when option = 5;
			end loop;
				if option =5 then
					ATIO.Put_Line(" salir y max word");
			end if;
	end Seleccionar_Opciones;	
	option:Integer;
--------------------------------------------------------------------------------------------------------------------
	procedure comprobar_comandos(Nombre_file:out ASU.Unbounded_String; Es_i:out Boolean) is
		
	begin

		case ACL.Argument_Count is
			when 1 =>
				if ACL.Argument(1)/= "-i" then 
					Nombre_file:=ASU.To_Unbounded_String(ACL.Argument(1));
					Es_i:=False;
				else 
					raise Usage_Error;
				end if;
			when 2 =>
				if ACL.Argument(1) = "-i" then
					Nombre_file:=ASU.To_Unbounded_String(ACL.Argument(2));
					Es_i:=True;
				elsif ACL.Argument(2) ="-i" then
					Nombre_file:=ASU.To_Unbounded_String(ACL.Argument(1));
					Es_i:=True;
				else 
					raise Usage_Error;
				end if;
			when others=>
				raise Usage_Error;
		end case;
	end comprobar_comandos;
----------------------------------------------------------------------------------------------------------------------
	namefile:ASU.Unbounded_String;
	Es_i:Boolean;
begin
	comprobar_comandos(namefile,Es_i);

	
	ATIO.Put_Line("nombre del fichero:  " & ASU.To_String(namefile));
	
	ATIO.Put_Line("ha introducido comando -i: " & Boolean'Image(Es_i));
	
   exception
   when Usage_Error =>
      Ada.Text_IO.Put_Line("Use: ");
      Ada.Text_IO.Put_Line(" -i" & ACL.Command_Name & " <file>");
end comandos;