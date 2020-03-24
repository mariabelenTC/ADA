with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;
procedure trocear_file is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package AE renames Ada.Exceptions;
	package ACL renames Ada.Command_Line;
	package ACH renames Ada.Characters.Handling;
	Usage_Error: exception;


-----------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------
	procedure Trocear_F(Frase:in out ASU.Unbounded_String;				
						Delimiter: in String) is
		palabra: ASU.Unbounded_String;
		P_Blanco:Integer;
		Length_F:Natural;	
	begin
		loop 
			Length_F:=ASU.Length(Frase);
			--ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));
			P_Blanco:=ASU.Index(Frase," ");
			--ATIO.Put_Line("poscion de un espacio: " & Integer'Image(P_Blanco));		
			if P_Blanco = 1 then
				Frase:= ASU.Tail(Frase,Length_F-P_Blanco);	
			elsif P_Blanco/= 0 then
				Palabra:= ASU.Head(Frase,P_Blanco -1);
				ATIO.Put_Line(ASU.To_String(Palabra));
				Frase:=ASU.Tail(Frase,Length_F-P_Blanco);
			elsif P_Blanco=0  and Length_F/=0 then 
				Frase:=ASU.Tail(Frase,Length_F);
				ATIO.Put_Line(ASU.To_String(Frase));
			end if;			
		exit when P_Blanco = 0; -- para que no se salga de mi rango
		end loop;
	end Trocear_F;
----------------------------------------------------------------------------------------
procedure imprimir_fichero(File_Name: in out ASU.Unbounded_String) is
      
      File: Ada.Text_IO.File_Type;
 
      Finish: Boolean;
      Line: ASU.Unbounded_String;
   begin        
      Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));

      Finish := False;

      while not Finish loop
         begin
            Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
            Line := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Line))); -- Extension 2	
           -- Ada.Text_IO.Put_Line(ASU.To_String(Line));
            Trocear_F(Line, " ");

         exception
            when Ada.IO_Exceptions.End_Error =>
             Finish := True;
         end;
      end loop;
      Ada.Text_IO.Close(File);
   end imprimir_fichero;
   --------------------------------------------------------------------------- 
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
   ----------------------------------------------------------------------------
	namefile:ASU.Unbounded_String;
	Es_i:Boolean;
	option:Integer;
begin
	comprobar_comandos(namefile,Es_i);
	ATIO.Put_Line("nombre del fichero:  " & ASU.To_String(namefile));
	if not Es_i then
		imprimir_fichero(namefile);
	else
		Seleccionar_Opciones(option);
	end if;

	--ATIO.Put_Line(Boolean'Image(Es_i));
	
	
	
	exception
   	when Usage_Error =>
      Ada.Text_IO.Put_Line("Use: ");
      Ada.Text_IO.Put_Line(" -i" & ACL.Command_Name & " <file>");
end trocear_file;
