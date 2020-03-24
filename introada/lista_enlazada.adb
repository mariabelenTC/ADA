with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

-- Crear lista enlazada --

procedure Lista_Enlazada is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	
	type Celda;
	type Ptr_Celda is access Celda;
	type Celda is record
		word:ASU.Unbounded_String;
		siguiente: Ptr_Celda;
	end record;
	Puntero:Ptr_Celda;
	Puntero_Aux:Ptr_Celda;
	
	procedure Delete is new Ada.Unchecked_Deallocation(celda,Ptr_Celda);
	
	function Lista_Vacia(Lista: Ptr_Celda) return boolean is
	begin
		return Lista = null;
	end Lista_Vacia;
	
	-----------------------------------------------------------------------
	procedure Insertar_word(Lista: in out Ptr_Celda;word:ASU.Unbounded_String ) is 
		pnodo: Ptr_Celda;
	begin
		
		pnodo:=new Celda;
		pnodo.Word:= Word;
		Lista:=pnodo;
		Puntero_Aux.siguiente:=pnodo;
		Puntero_Aux:=pnodo;
		
		
		--Puntero_Aux:=pnodo;
		
		
	end Insertar_word;
	---------------------------------------------------------------------
	procedure Print_Lista(Lista:Ptr_Celda) is
		
		pnodo:Ptr_Celda;
	begin
		pnodo:=Lista;

		while not Lista_Vacia(pnodo) loop
			ATIO.Put_Line(ASU.To_String(pnodo.word));
			pnodo:=pnodo.siguiente;
			
		end loop;

		
	end Print_Lista;
	--------------------------------------------------------------------
--	procedure EliminarCabeza(Lista: in out Ptr_Celda) is
--		
--		pnodo:Ptr_Celda;
--	begin
--		if not Lista_Vacia(Lista) then
--			pnodo:= Lista;
--			Lista:=Lista.siguiente;
--			Delete(pnodo);
--			
--		end if;
--	end EliminarCabeza;
	--------------------------------------------------------------------
--	procedure Extraer_cola(lista: in out Ptr_Celda; word: out ASU.Unbounded_String) is
--		pnodo: Ptr_Celda;
--		panterior: Ptr_Celda;
--		ultimo: Boolean;
--	begin
--		if not Lista_Vacia(lista) then 
--			pnodo:= lista;
--			if Lista_Vacia(lista.siguiente) then
--				word:=Lista.word;
--				lista:=null;
--			else
--				pAnterior:=null;
---				ultimo:=False;
--			loop
--				
--					if not ultimo then 
--						pAnterior:= pnodo;
--						pnodo:= pnodo.Siguiente;
--					end if;
--				end loop;
--				panterior.siguiente:= null;
--				word:= pnodo.word;
--			end if;
--			Delete(pnodo);
--		end if;
--	end Extraer_Cola;
	
	--------------------------------------------------------------------
	
begin
	
	for k in 1..4 loop
	Insertar_word(puntero,ASU.To_Unbounded_String(ATIO.Get_Line));
	end loop;
	ATIO.Put_Line("Mi lista enlazada");
	Print_Lista(puntero);
--	ATIO.Put_Line("elimino cabeza");
--	Eliminarcabeza(puntero);
--	Print_lista(puntero);
--	ATIO.Put_Line("Extraer cola");
--	Extraer_Cola(Puntero, puntero.word);
--	Print_lista(puntero);
end Lista_Enlazada;
