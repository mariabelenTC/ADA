with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Maps_G is

	procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
		i:Integer;
	begin
		i:= 1;
		Success:=False;
		while not Success and i<= Max_Clients  Loop
			if M.P_Array.All(i).Key = Key and M.P_Array.All(i).Full then
				Value := M.P_Array.All(i).Value;
				Success := True;
			else
				i:= i+1;
			end if;
		end loop;
	end Get;
----------------------------------------------------------------------------------
   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
		Found,Full : Boolean;
		i: Integer;
		i_Vacio:Integer:=0;
   begin
      -- Si ya existe Key, cambiamos su Value
		i:= 1;
      Found := False;
		Full:=False;
      while not Found  and i<=Max_Clients loop
         if M.P_Array.all(i).Key = Key and M.P_Array.all(i).Full  then
            M.P_Array.all(i).Value := Value;
            Found := True;
			else
				if not M.P_Array.all(i).Full  and i_Vacio = 0 then
					i_Vacio:=i;
				end if;
				i:= i+1;
			end if;
      end loop;
		if M.Length = Max_Clients then
			Full:= True;
		end if;
      -- Si no hemos encontrado Key
      if not found and not Full  then
			M.P_Array.all(i_Vacio).Key:= Key;
			M.P_Array.all(i_Vacio).Value:= Value;
			M.P_Array.all(i_Vacio).Full:= True;
			M.Length:= M.Length+1;
		elsif not Found and Full then
			raise Full_Map;
		end if;
   end Put;
--------------------------------------------------------------------------------
procedure Delete (M      : in out Map;
						Key     : in  Key_Type;
						Success : out Boolean) is
	i:Integer;
begin
	i:=1;
	Success := False;
	while not Success and i<= Max_Clients loop
		if M.P_Array.all(i).Key = Key and M.P_Array.All(i).Full then
			Success := True;
			M.P_Array.all(i).Full:= False;
			M.Length := M.Length - 1;
		else
			i:=i+1;
		end if;
	end loop;
end Delete;
--------------------------------------------------------------------------------
   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;
--------------------------------------------------------------------------------
   function First (M: Map) return Cursor is
		i:integer;
		Esta:Boolean;
	begin
		--i:=1;
		--if M.Length/= 0  then
		--	if not M.P_Array.all(i).Full then
		--		loop
		--			i:=i + 1;
		--			exit when M.P_Array.all(i).Full= True;
		--		end loop;
		--	end if;
		--	Esta:=True;
		--else
		--	Esta:=False;
		--end if;

		i:=1;
		if M.P_Array.all(i).Full then
			Esta:=True;
		else
			Esta:=False	;
		end if;
		while M.Length/=0 and then not M.P_Array.all(i).Full  loop
			i:=i + 1;
			Esta:=True;
		end loop;

      return (M => M, Pos =>i, Valido => Esta);
   end First;
--------------------------------------------------------------------------------
   procedure Next (C: in out Cursor) is
	begin
		--if C.Pos < Max_Clients  then
		--	if C.Valido then
		--		C.Pos:=C.Pos+1;
		--		while not C.M.P_Array.all(C.Pos).Full and C.Pos <Max_Clients loop
		--			C.Pos:=C.Pos +1;
		--		end loop;
		--		if not C.M.P_Array.all(C.Pos).Full  then
		--			C.Valido :=False;
		--		end if;
		--	end if;
		--else
		--	C.Valido:=False;
		--end if;
		...........................................................................................

		if C.Pos < Max_Clients and C.Valido then
			C.Pos:=C.Pos+1;
			while not C.M.P_Array.all(C.Pos).Full and C.Pos <Max_Clients loop
				C.Pos:=C.Pos +1;
			end loop;
			if not C.M.P_Array.all(C.Pos).Full  then
				C.Valido :=False;
			end if;
		else
			C.Valido:=False;
		end if;
   end Next;
--------------------------------------------------------------------------------
   function Element (C: Cursor) return Element_Type is
		Tipo_Elemento:Element_Type;
	begin
      if C.Valido then
         Tipo_Elemento.Key :=C.M.P_Array.all(C.Pos).Key;
         Tipo_Elemento.Value := C.M.P_Array.all(C.Pos).Value;
      else
			raise No_Element;
		end if;
		return Tipo_Elemento;

	end Element;

--------------------------------------------------------------------------------
   function Has_Element (C: Cursor) return Boolean is
   begin
      if C.Valido then
         return True;
      else
         return False;
      end if;
   end Has_Element;
--------------------------------------------------------------------------------
end Maps_G;
