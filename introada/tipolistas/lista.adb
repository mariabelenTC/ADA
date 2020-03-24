
with Ada.Text_IO;


package body lista is
	
package ATIO renames Ada.Text_IO;
-- procedure word_repetida(Lista: Word_List_Type; Palabra:ASU.Unbounded_String; repetido:out Boolean;
-- 						nextwordmayor:out Boolean; P_Word:out Word_List_Type)  is
-- 	P_Word_Ultimo:Word_List_Type;
	
-- begin
-- 	P_Word:=Lista;
	
-- 	if lista = null then
-- 		Repetido := False;
-- 		nextwordmayor:=False;
-- 	else 
-- 	while (P_Word /= null) and (not repetido) and (not nextwordmayor) loop
-- 	  	if ASU.To_String(Palabra)= ASU.To_String(P_Word.Word) 
-- 	  	and ASU.To_String(Palabra)> ASU.To_String(P_Word.Word)then

-- 			Repetido:=True;
-- 			nextwordmayor:=True;
-- 			P_Word:=P_Word.next;
-- 			P_Word_Ultimo:=P_Word;
-- 		else
-- 			 -- me guardo en P_Word_Ultimo la posicion del P_Word ultimo.
-- 			P_Word:=P_Word.Next;

-- 		end if;
-- 	end loop;
	
-- 	if not repetido and not nextwordmayor then
-- 		P_Word:=P_Word_Ultimo; -- guardo en P_Word la posicion de la ultima palabra  que habia guardado en P_Word_Ultimo
-- 	end if;	
-- 		end if;					-- porque sino seria P_Word:=P_Word.Next que al terminar el bucle quedaria a null;				
-- end word_repetida
---------------------------------------------------------------------------------------------------------------------------------------
-- procedure buscar_word_mayor(Lista:in Word_List_Type; Word: in  ASU.Unbounded_String;
-- 							hay_word_mayor: out Boolean;
-- 							P_Word_Mayor:out Word_List_Type;
-- 							P_word_anterior:out Word_List_Type)  is
	
-- begin
	
-- 	P_Word_Mayor:=Lista;
-- 	--P_word_anterior:=P_Word_Mayor;
-- 	if lista = null then
-- 		hay_word_mayor:= False;
-- 	else
-- 		while (P_Word_Mayor /= null) and  not hay_word_mayor loop
-- 	  		if ASU.To_String(Word)<ASU.To_String(P_Word_Mayor.Word) then
-- 				hay_word_mayor:=True;

-- 			else
-- 				P_word_anterior:=P_Word_Mayor; --guardo la posicion del ultimo.
-- 				P_Word_Mayor:=P_Word_Mayor.Next;
-- 			end if;
-- 		end loop;	
-- 		if not hay_word_mayor then
-- 			P_Word_Mayor:=P_word_anterior; 
-- 		end if;	
-- 	end if;		
-- end buscar_word_mayor;
-- -----------------------------------------------------------------------------------------------
-- 	procedure Add_Word_alfabeto(List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
-- 	P_Word_mayor:Word_List_Type;
-- 	P_word_anterior:Word_List_Type;		
-- 	hay_word_mayor:Boolean;
-- 	P_New_Word:Word_List_Type;			
-- begin

-- 	ATIO.Put_Line("word  |" & ASU.To_String(Word) & "| added");
-- 	buscar_word_mayor(List,Word,hay_word_mayor,P_Word_mayor,P_word_anterior);
	
-- 	P_New_Word:=new cell;
-- 	P_New_Word.all.Word:=Word;
	
-- 	if not hay_word_mayor then
-- 		List:=P_New_Word;
-- 	else
-- 		if  P_word_anterior =null and P_Word_Mayor/= null then
-- 		P_word_anterior:=List;
-- 		P_word_anterior.next:=P_New_Word;
-- 		P_New_Word.Next:=P_Word_Mayor;
-- 		List:=P_word_anterior;
-- 		else

-- 		P_word_anterior.next:=P_New_Word;
-- 		P_New_Word.next:=P_Word_Mayor;
-- 		end if;

-- 		-- si la palabra no es mayor, 
-- 		--creo una nueva celda en la que guardar la palabra
-- 		-- y  a su contador lo inicializo a uno
		

-- 		--si la lista = null  es el caso cuando no tengo nada en mi lista 
-- 			--y quiero que empiece apuntando a P_New_Word ( la nueva que acabo de crear arriba)
		
 
-- 		-- si la palabra esta repetida 
-- 		-- como a P_Word le paso la posicion del puntero que me da el procedure word_repetida
-- 		 --sumar repeticiones
-- 	end if;
-- 	end Add_Word_alfabeto;



	
		

-----------------------------------------------------------------------------------------------
	procedure Add_Word_alfabeto(List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
	P_Aux1:Word_List_Type;
	P_Aux2:Word_List_Type;	
	contador: Natural;
	encontrado: Boolean;
	hay_word_mayor:Boolean;				
begin
	P_Word_Mayor:=List;
	ATIO.Put_Line("word  |" & ASU.To_String(Word) & "| added");
	P_New_Word:=new cell;
	P_New_Word.all.Word:=Word;


	--P_word_anterior:=P_Word_Mayor;
	if list = null then
		hay_word_mayor:= False;
	else
		while (P_Word_Mayor /= null) and  not hay_word_mayor loop
	  		if ASU.To_String(Word)<ASU.To_String(P_Word_Mayor.Word) then
				hay_word_mayor:=True;

			else
				P_word_anterior:=P_Word_Mayor; --guardo la posicion del ultimo.
				P_Word_Mayor:=P_Word_Mayor.Next;
			end if;
		end loop;	
		if not hay_word_mayor then
			P_Word_Mayor:=P_word_anterior; 
		end if;	
	end if;		
	
	
	if not hay_word_mayor then
		List:=P_New_Word;
	else
		if  P_word_anterior =null and P_Word_Mayor/= null then
		P_word_anterior:=List;
		P_word_anterior.next:=P_New_Word;
		P_New_Word.Next:=P_Word_Mayor;
		List:=P_word_anterior;
		else

		P_word_anterior.next:=P_New_Word;
		P_New_Word.next:=P_Word_Mayor;
		end if;

		while(not hay_word_mayor) and List/=null loop		
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

		-- si la palabra no es mayor, 
		--creo una nueva celda en la que guardar la palabra
		-- y  a su contador lo inicializo a uno
		

		--si la lista = null  es el caso cuando no tengo nada en mi lista 
			--y quiero que empiece apuntando a P_New_Word ( la nueva que acabo de crear arriba)
		
 
		-- si la palabra esta repetida 
		-- como a P_Word le paso la posicion del puntero que me da el procedure word_repetida
		 --sumar repeticiones
	end if;
	end Add_Word_alfabeto;
-- -------------------------------------------------------------------------------------------------
procedure Print_All (List: in Word_List_Type) is
	P_Aux:Word_List_Type;
begin	
	P_Aux:=List;
	while P_Aux /= null loop
	  	ATIO.Put_Line("|"& ASU.To_String(P_Aux.Word) &	"|"	);
	   	P_Aux:=P_Aux.Next;
	end loop;
	if List=null then
		ATIO.Put_Line("Print_All: No word ");
	end if;
end Print_All;
-----------------------------------------------------------------------------------------------
end lista;