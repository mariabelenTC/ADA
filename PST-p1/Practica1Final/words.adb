with Ada.Text_IO;
with Ada.Command_Line;
with Word_Lists;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;
with Ada.Strings.Maps;

procedure words is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package ACL renames Ada.Command_Line;
	package WL renames Word_Lists;
	package ASM renames Ada.Strings.Maps;
	package ACH renames Ada.Characters.Handling;
	
	Usage_Error: exception;
	opciones: exception;
	namefile:ASU.Unbounded_String;
	Es_i:Boolean;
	option:Integer;
	Lista:WL.Word_List_Type;
	Word:ASU.Unbounded_String;
	Count:Natural;
---------------------------------------------------------------------------------------------------
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
			else 
				raise Usage_Error;
			end if;
		when others=>
			raise Usage_Error;
		end case;
	end comprobar_comandos;
-----------------------------------------------------------------------------------------------
	procedure Trocear_F(Frase:in out ASU.Unbounded_String;Lista:in out WL.Word_List_Type) is
		palabra: ASU.Unbounded_String;
		P_Blanco:Integer;
		Length_F:Natural;	
	begin
		loop 
			Length_F:=ASU.Length(Frase);
			--ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));
			P_Blanco:=ASU.Index(Frase,ASM.To_Set("&|#@¬][*^<>$~%`',.-;:+-·=)1234567890(""¿?!¡_/ "));
			--ATIO.Put_Line("poscion de un espacio: " & Integer'Image(P_Blanco));		
			if P_Blanco = 1 then
				Frase:= ASU.Tail(Frase,Length_F-P_Blanco);	
			elsif P_Blanco/= 0 then
				Palabra:= ASU.Head(Frase,P_Blanco -1);
				--ATIO.Put_Line(ASU.To_String(Palabra)); ----- AÑADIR A MI LISTA
				WL.Add_Word(Lista,Palabra);
				Frase:=ASU.Tail(Frase,Length_F-P_Blanco);
			elsif P_Blanco=0  and Length_F/=0 then 
				Frase:=ASU.Tail(Frase,Length_F);
				--ATIO.Put_Line(ASU.To_String(Frase));
				WL.Add_Word(Lista,Frase);
			end if;			
		exit when P_Blanco = 0; -- para que no se salga de mi rango
		end loop;		
	end Trocear_F;
----------------------------------------------------------------------------------------
 procedure Leer_Fichero(File_Name: in out ASU.Unbounded_String) is
      File: Ada.Text_IO.File_Type;
      Finish: Boolean;
      Line: ASU.Unbounded_String;
   begin        
      Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));
      Finish := False;
      while not Finish loop
         begin
            Line := ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line(File)));
            Trocear_F(Line,Lista);
         exception
            when Ada.IO_Exceptions.End_Error =>
             Finish := True;
         end;
      end loop;
      Ada.Text_IO.Close(File);
   	exception
   	when Ada.IO_Exceptions.Name_Error=>
   		Ada.Text_IO.Put_Line((ASU.To_String(namefile))& ": " & "File not found");
   end Leer_Fichero;
----------------------------------------------------------------------------------------------- 
	procedure Seleccionar_Opciones (option:out Integer; Lista: in out WL.Word_List_Type) is	
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
				ATIO.Put("Word? ");

				Word:=ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line));
				ATIO.Put_Line("word  |" & ASU.To_String(Word) & "| added");
				Trocear_F(Word,Lista);
			elsif option = 2 then
				ATIO.Put("Word? ");
				Word:=ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line));
				ATIO.Put_Line("|" & ASU.To_String(Word) & "| deleted");
				WL.Delete_Word(Lista,Word);
			elsif option=3 then
				ATIO.Put("Word? ");
				Word:=ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line));
				WL.Search_Word(Lista,Word,Count);
			elsif option = 4 then
				WL.Print_All(Lista);
			elsif option /= 5 then
				raise opciones;				
			end if;
		exit when option = 5;
		end loop;
		if option =5 then
			WL.Max_Word(Lista,Word,Count);
		end if;	
		exception
			when WL.Word_List_Error=>	
				ATIO.Put_Line("No hay palabra");
	end Seleccionar_Opciones;
   ----------------------------------------------------------------------------	 	
begin
	comprobar_comandos(namefile,Es_i);
	Leer_Fichero(namefile);
	if not Es_i then	
		WL.Max_Word(Lista,Word,Count);
	else 
		Seleccionar_Opciones(option,Lista);
	end if;	
	Ada.Text_IO.Put_Line("liberar memoria:  ");
	WL.Delete_List(Lista);
	WL.Print_All(Lista);
	exception
   	when Usage_Error =>
    	Ada.Text_IO.Put_Line("Usage:  ./ words  [-i]  <filename>");
    when WL.Word_List_Error=>
			null;
	when opciones =>
		ATIO.Put_Line("opcion incorrecta");
	when Constraint_Error =>
		Ada.Text_IO.Put_Line ("introduca opcion numerica");			
	when Except:others =>
		ATIO.Put_Line ("Excepcion imprevista: " & Ada.Exceptions.Exception_Name (Except) & " en: " & Ada.Exceptions.Exception_Message (Except));

end words;