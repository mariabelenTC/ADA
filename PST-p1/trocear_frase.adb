with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Strings.Maps;

procedure trocear_frase is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package AE renames Ada.Exceptions;
	package ACL renames Ada.Command_Line;
	package ASM renames Ada.Strings.Maps;
	Usage_Error: exception;

	procedure Trocear_F(Frase:in out ASU.Unbounded_String) is
		palabra:  ASU.Unbounded_String;
		P_Blanco:Integer;
		Length_F:Natural;	
	begin
		loop 
			Length_F:=ASU.Length(Frase);
			--ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));
			P_Blanco:=ASU.Index(Frase,ASM.To_Set("&|#@¬][*^<>$~%`',.-;:+-·=)1234567890(""¿?!¡_/ "));					 --Extension 1 			
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

	Frase:ASU.Unbounded_String;
	--Palabra:ASU.Unbounded_String;
begin
	
	Ada.Text_IO.Put("Introduce una frase: ");
	Frase:=ASU.To_Unbounded_String(ATIO.Get_Line);
	--ATIO.Put_Line("hola mundo");
	
		Trocear_F(Frase);
	
	
end trocear_frase;
