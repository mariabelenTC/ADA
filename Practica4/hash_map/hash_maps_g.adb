with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Hash_Maps_G is

	procedure Get (M     : in out Map;
				   Key   : in Key_Type;
				   Value : out Value_Type;
				   Success: out Boolean)  is

		Fin: Boolean;
		i: Hash_Range;
		P_Guia: Cell_A:= new Cell;

	begin
		Fin:= False;
		Success:= False;
		i:= Hash(Key);		
		P_Guia.all:= M.P_Array.all(i);
		P_Guia.all.Next:= M.P_Array.all(i).Next;
		
		while (not Fin and not Success) loop
		
			if (P_Guia.all.Next = null) then
				Fin:= True;
			end if;

			if (P_Guia.all.Key = Key) then
				Success:= True;
				Value:= P_Guia.all.Value;

			end if;

			P_Guia:= P_Guia.all.Next;
		end loop;

	end Get;




	procedure Put (M     : in out Map;
                   Key   : Key_Type;
                   Value : Value_Type) is

		i: Hash_Range;
		Counter: Natural;
		Encontrado: Boolean;
		Fin: Boolean;
		P_Guia: Cell_A:= new Cell;
		P_Guia_Anterior: Cell_A:= new Cell;

	begin
		Counter:= 0;
		Encontrado:= False;
		Fin:= False;
		i:= Hash(Key);		
		P_Guia.all:= M.P_Array.all(i);
		P_Guia.all.Next:= M.P_Array.all(i).Next;
		P_Guia_Anterior.all:= M.P_Array.all(i);
		P_Guia_Anterior.all.Next:= M.P_Array.all(i).Next;

		while (not Fin and not Encontrado) loop
		
			if (P_Guia.all.Next = null) then
				Fin:= True;
			end if;

			if (P_Guia.all.Key = Key) then

				Encontrado:= True;
				if (Counter = 0) then
					M.P_Array.all(i).Value:= Value;
				else
					P_Guia.all.Value:= Value;
				end if;
					
			end if;

			if(Counter=1) then
				P_Guia_Anterior:= M.P_Array.all(i).Next;
			elsif (Counter>1) then
				P_Guia_Anterior:= P_Guia_Anterior.all.Next;
			end if;

			P_Guia:= P_Guia.all.Next;
			Counter:= Counter+1;

		end loop;

		if (not Encontrado) then
		
			if (Counter = 1 and M.P_Array.all(i).N_Elem = 0) then
				M.P_Array.all(i).Key:= Key;
				M.P_Array.all(i).Value:= Value;
				M.P_Array.all(i).N_Elem:= M.P_Array.all(i).N_Elem+1;
			else
				P_Guia:= new Cell;
				P_Guia.all.Key:= Key;
				P_Guia.all.Value:= Value;
				if (M.P_Array.all(i).N_Elem = 1) then
					M.P_Array.all(i).Next:= P_Guia;
				else
					P_Guia_Anterior.all.Next:= P_Guia;
				end if;
				M.P_Array.all(i).N_Elem:= M.P_Array.all(i).N_Elem+1;
			end if;
		end if;
	end Put;



	procedure Delete (M: in out Map;
				 	  Key: in Key_Type;
				 	  Success : out Boolean) is
		Fin: Boolean;
		Counter: Natural;
		i: Hash_Range;
		P_Guia: Cell_A:= new Cell;
		P_Guia_Anterior: Cell_A:= new Cell;


	begin

		Counter:= 0;
		Fin:= False;
		Success:= False;
		i:= Hash(Key);		
		P_Guia.all:= M.P_Array.all(i);
		P_Guia.all.Next:= M.P_Array.all(i).Next;
		P_Guia_Anterior.all:= M.P_Array.all(i);
		P_Guia_Anterior.all.Next:= M.P_Array.all(i).Next;

		
		while (not Fin and not Success) loop
		
			if (P_Guia.all.Next = null) then
				Fin:= True;
			end if;

			if (P_Guia.all.Key = Key) then
				Success:= True;

				if (M.P_Array.all(i).N_Elem = 1) then
					M.P_Array.all(i).Key:= M.P_Array.all(i+1).Key;
					M.P_Array.all(i).Value:= M.P_Array.all(i+1).Value;
					M.P_Array.all(i).N_Elem:= 0;
				elsif ( (P_Guia.all.Next = null) and (M.P_Array.all(i).N_Elem = 2) ) then
					M.P_Array.all(i).Next:= null;
				elsif (P_Guia.all.Next = null and (M.P_Array.all(i).N_Elem > 2) ) then
					P_Guia_Anterior.all.Next:= null;
				elsif (Counter = 1) then
					M.P_Array.all(i).Next:= P_Guia.all.Next;
				else
					P_Guia_Anterior.all.Next:= P_Guia.all.Next;
				end if;

			end if;


			if(Counter=1) then
				P_Guia_Anterior:= M.P_Array.all(i).Next;
			elsif (Counter>1) then
				P_Guia_Anterior:= P_Guia_Anterior.all.Next;
			end if;

			P_Guia:= P_Guia.all.Next;
			Counter:= Counter+1;

		end loop;

	end Delete;


	function Map_Length (M : Map) return Natural is
		Count: Natural;
		i: Hash_Range;
	begin
		Count:= 0;
		loop
			Count:= Count + M.P_Array.all(i).N_Elem;
			i:= i+1;
			exit when (i=0);
		end loop;
		return Count;
	end Map_Length;

	function First (M: Map) return Cursor is
	begin
		return (M => M, Celda => M.P_Array.all(0), I_Array => 0, I_List => 1);
	end First;


	function Has_Element (C: Cursor) return Boolean is
	begin
		if (C.Celda.N_Elem = 0) then
			return False;
		else 
			return True;
		end if;
	end Has_Element;


end Hash_Maps_G;
