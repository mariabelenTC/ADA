with Ada.Strings.Maps;
with Ada.Text_IO;
with Word_Lists;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;



procedure add_trocear_word is

	package ASU renames Ada.Strings.Unbounded;
	package ACH renames Ada.Characters.Handling;
	package ASM renames Ada.Strings.Maps;
	package ATIO renames Ada.Text_IO;
	Mi_Lista: Word_Lists.Word_List_Type;
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
				--ATIO.Put_Line(ASU.To_String(Palabra));
				Word_Lists.Add_Word (Mi_Lista,Palabra);
				Frase:=ASU.Tail(Frase,Length_F-P_Blanco);
			elsif P_Blanco=0  and Length_F/=0 then 
				Frase:=ASU.Tail(Frase,Length_F);
				--ATIO.Put_Line(ASU.To_String(Frase));
				Word_Lists.Add_Word (Mi_Lista,Frase);
			end if;			
		exit when P_Blanco = 0; -- para que no se salga de mi rango
		end loop;
	end Trocear_F;

	palabra:ASU.Unbounded_String;
	
begin
	Mi_Lista:=null;
	for k in 0..3 loop
		palabra:=ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line));
		Trocear_F(Palabra);
		
	end loop;
	Word_Lists.Print_All(Mi_Lista);

	

	Exception
		when Word_Lists.Word_List_Error=>
			Ada.Text_IO.Put_Line("no words");

end add_trocear_word;