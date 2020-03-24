with Ada.Text_IO;
with Word_Lists;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;



procedure Word_Lists_Test is

	package ASU renames Ada.Strings.Unbounded;
	package ACH renames Ada.Characters.Handling;
	package WL renames Word_Lists;

	mi_lista: wl.word_list_type;
	mi_lista_pila:wl.word_list_type;
	mi_lista_cola:wl.word_list_type;
	palabra:asu.unbounded_string;
	contador:Natural;
	Frase:ASU.Unbounded_String;
	procedure Trocear_F(Frase:in out ASU.Unbounded_String) is
		palabra:  ASU.Unbounded_String;
		P_Blanco:Integer;
		Length_F:Natural;	
	begin
		loop 
			Length_F:=ASU.Length(Frase);
			--ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));
			P_Blanco:=ASU.Index(Frase," ");					 --Extension 1 			
			--ATIO.Put_Line("poscion de un espacio: " & Integer'Image(P_Blanco));		
			if P_Blanco = 1 then
				Frase:= ASU.Tail(Frase,Length_F-P_Blanco);	
			elsif P_Blanco/= 0 then
				Palabra:= ASU.Head(Frase,P_Blanco -1);
				--ATIO.Put_Line(ASU.To_String(Palabra));
				WL.Add_Word (Mi_Lista,Palabra);
				WL.Add_Word_Pila(Mi_Lista_Pila,Palabra);
				WL.Add_Word_Cola(Mi_Lista_Cola,Palabra);
				Frase:=ASU.Tail(Frase,Length_F-P_Blanco);
			elsif P_Blanco=0  and Length_F/=0 then 
				Frase:=ASU.Tail(Frase,Length_F);
				WL.Add_Word (Mi_Lista,Frase);
				--ATIO.Put_Line(ASU.To_String(Frase));
				WL.Add_Word_Pila(Mi_Lista_Pila,Frase);
				WL.Add_Word_Cola(Mi_Lista_Cola,Frase);
			end if;			
		exit when P_Blanco = 0; -- para que no se salga de mi rango
		end loop;
	end Trocear_F;
	
begin
	Mi_Lista:=null;
	--for k in 0..3 loop
		--WL.Add_Word (Mi_Lista, ASU.To_Unbounded_String(ACH.To_Lower(Ada.Text_IO.Get_Line)));
	Frase:=ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
	Trocear_F(Frase);
	--end loop;
	WL.Print_All(Mi_Lista);
	Ada.Text_IO.Put_Line("lista inversa");
	WL.Print_All(Mi_Lista_Pila);
	Ada.Text_IO.Put_Line("lista tipo cola con repetciones");
	WL.Print_All(Mi_Lista_Cola);

	WL.Search_Word(Mi_Lista,ASU.To_Unbounded_String("hola"),contador);
	Ada.Text_IO.Put_Line(Integer'Image(contador));

	WL.Max_word(Mi_Lista,palabra,contador);

	WL.Delete_Word(Mi_Lista, ASU.To_Unbounded_String("belen"));
	Ada.Text_IO.Put_Line("nueva lista:           ");
	WL.Print_All(Mi_Lista);


	Ada.Text_IO.Put_Line("borro lista:           ");
	WL.Delete_List(Mi_Lista);
	WL.Print_All(Mi_Lista);

	Exception
		when WL.Word_List_Error=>
			Ada.Text_IO.Put_Line("no words");

end Word_Lists_Test;