---Maria Belen Tualombo-----Practica 1---
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body word_lists is
	
package ATIO renames Ada.Text_IO;

procedure Free is new
		Ada.Unchecked_Deallocation(Cell, Word_List_type);
----------------------------------------------------------------------------------------------------		
procedure word_repetida(Lista: Word_List_Type; Palabra:ASU.Unbounded_String;
						repetido:out Boolean; P_Word:out Word_List_Type)  is
	P_Word_Ultimo:Word_List_Type;	
begin
	P_Word:=Lista;
	if lista = null then
		Repetido := False;
	else 
		while (P_Word /= null) and (not repetido) loop
	  		if ASU.To_String(Palabra)= ASU.To_String(P_Word.Word) then
				Repetido:=True;
			else
				P_Word_Ultimo:=P_Word; --guardo la posicion del ultimo.
				P_Word:=P_Word.Next;
			end if;
		end loop;	
		if not repetido then
			P_Word:=P_Word_Ultimo; 
		end if;	
	end if;							
end word_repetida;
----------------------------------------------------------------------------------------------------
procedure Delete_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
	P_Aux1:Word_List_Type;
	P_Aux2:Word_List_Type;	
	contador: Natural;
	encontrado: Boolean;
	Repetido:Boolean;
	P_Word:Word_List_Type;
begin
	P_Aux1:=List;
	P_Aux2:=List;
	contador:= 0;
	encontrado:= False;
	word_repetida(List,Word,Repetido,P_Word);
	if not repetido then
		raise Word_List_Error;
	end if;
	while(not encontrado) and List/=null loop		
		if contador = 0 then
			P_Aux2:= P_Aux2.Next;
			contador:= contador+1;
		else
			P_Aux1:= P_Aux1.Next;
			P_Aux2:= P_Aux2.Next;
		end if;
		if ASU.To_String(Word) = ASU.To_String(P_Aux1.word) then
			encontrado:=True;
			List:=List.Next;
			Free(P_Aux1);
		elsif ASU.To_String(Word) = ASU.To_String(P_Aux2.word) then 
			P_Aux2 := P_Aux2.Next;
			Free(P_Aux1.Next);
			P_Aux1.Next:= P_Aux2;			
			encontrado:= True;
		end if;
	end loop;	
end Delete_Word;
--------------------------------------------------------------------------------------------------------
procedure Delete_List(List:in out Word_List_Type) is
begin
	while List/= null loop
		Delete_Word(List,List.Word);
	end loop;
end Delete_List;
---------------------------------------------------------------------------------------------------------
procedure Add_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
	P_Word:Word_List_Type;		
	repetido:Boolean;
	P_New_Word:Word_List_Type;				
begin
	word_repetida(List,Word,Repetido,P_Word);
	if not repetido then
		P_New_Word:=new cell;
		P_New_Word.all.Word:=Word;
		P_New_Word.all.Count:=1;
		if List=Null then
			List:=P_New_Word;
		else
			P_Word.all.Next:=P_New_Word;
		end if;
	else 
		P_Word.all.Count := P_Word.all.Count + 1;
	end if;
end Add_Word;
-------------------------------------------------------------------------------------------------------------
procedure Search_Word (List: in Word_List_Type; Word: in ASU.Unbounded_String; Count: out Natural) is
	P_Word:Word_List_Type;		
	repetido:Boolean;
begin
	word_repetida(List,Word,repetido,P_Word);
	if repetido then
		Count:=P_Word.all.Count;
	else
		Count:=0;
	end if;
	ATIO.Put_Line(Integer'Image(Count));
end Search_Word;
----------------------------------------------------------------------------------------------------------------
procedure Max_Word (List: in Word_List_Type; Word: out ASU.Unbounded_String; Count: out Natural) is
	P_Word:Word_List_Type;
begin
	P_Word:=List;
	if P_Word=null then		
		raise Word_List_Error;
	end if;	
	Count := P_Word.Count;
	Word:= P_Word.Word;	
	while P_Word/=null loop		
		if P_Word.Count > Count then
			Count := P_Word.Count;
			Word:= P_Word.Word;
		end if;
			P_Word := P_Word.Next;			
	end loop;
	ATIO.Put("The most frequent word: ");
	ATIO.Put_Line("|" & ASU.To_String(Word) & "| -" & Integer'Image(Count));
end Max_Word;
----------------------------------------------------------------------------------------------------------------
procedure Print_All (List: in Word_List_Type) is
	P_Aux:Word_List_Type;
begin	
	P_Aux:=List;
	while P_Aux /= null loop
	  	ATIO.Put_Line("|"& ASU.To_String(P_Aux.Word) &	"|"	& "->" & Integer'Image(P_Aux.Count));
	   	P_Aux:=P_Aux.Next;
	end loop;
	if List=null then
		ATIO.Put_Line("Print_All: No word ");
	end if;
end Print_All;
----------------------------------------------------------------------------------------------------------------
end word_lists;