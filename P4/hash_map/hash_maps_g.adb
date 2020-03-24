-- Maria Belen Tualombo
-- Tabla de simbolo:  Tabla Hash
 
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Hash_Maps_G is

	procedure Free is new Ada.Unchecked_Deallocation (Cell, Cell_A);

--____________________________________________________________________________--

	procedure Get (M       : in out Map;
						Key     : in  Key_Type;
						Value   : out Value_Type;
						Success : out Boolean) is

		i:Hash_Range:=Hash(Key);
		P_Aux : Cell_A;
	begin
		P_Aux:= M.P_Array.all(i);
		Success := False;
		while not Success and P_Aux /= null Loop
		 if P_Aux.Key = Key then
			 Value := P_Aux.Value;
			 Success := True;
		 end if;
			P_Aux := P_Aux.Next;
		end loop;
	end Get;
--____________________________________________________________________________--

	procedure Put (M     : in out Map;
						Key   : Key_Type;
						Value : Value_Type) is

		Found,Full: Boolean;
		i:Hash_Range:=Hash(Key);
		P_Aux:Cell_A;
	begin
		-- Si ya existe Key, cambiamos su Value
		P_Aux:= M.P_Array.all(i);
		Found := False;
		Full:=False;

		while not Found  and P_Aux/= null  loop
			if P_Aux.Key = Key then
				P_Aux.Value := Value;
				Found := True;
			else
				P_Aux:= P_Aux.Next;
			end if;
		end loop;

		if M.Length = Max then
			Full:= True;
		end if;
		-- Si no hemos encontrado Key
		if  not found and not Full  then
			M.P_Array.all(i):= new Cell'(Key, Value, M.P_Array.all(i));
			M.Length:= M.Length+1;
		elsif not Found and Full then
			raise Full_Map;
		end if;
	end Put;
--____________________________________________________________________________--

	procedure Delete (M      : in out Map;
							Key     : in  Key_Type;
							Success : out Boolean) is

		i:Hash_Range:=Hash(Key);
		P_Current  : Cell_A;
		P_Previous : Cell_A;
	begin
		Success := False;
		P_Previous := null;
		P_Current  :=M.P_Array.all(i);
		while not Success and P_Current /= null  loop
			if P_Current.Key = Key then
				Success := True;
				M.Length := M.Length - 1;
				if P_Previous /= null then
					P_Previous.Next := P_Current.Next;
				end if;
				if M.P_Array.all(i) = P_Current then
					M.P_Array.all(i) := M.P_Array.all(i).Next;
				end if;
				Free (P_Current);
			else
				P_Previous := P_Current;
				P_Current := P_Current.Next;
			end if;
		end loop;

end Delete;

--============================================================================--
--=============================CURSOR=========================================--
--============================================================================--


   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

--____________________________________________________________________________--

   function First (M: Map) return Cursor is
		i:Hash_Range;
		Esta:Boolean;
		Vacio:Boolean;
   begin
		i:=0;
		Esta:=False;
		Vacio:=False;
		if M.Length=0  then
				Esta:=False;
				Vacio:=True;
		else
			Esta:=True;
		end if;

		while M.P_Array.all(i) = null and not Vacio loop
			i:= i + 1;
		end loop;

      return (M => M, Pos=> i , P_Element=> M.P_Array.all(i), Valido => Esta);
   end First;
--____________________________________________________________________________--

   procedure Next (C: in out Cursor) is
		Encontrado:Boolean;
   begin
		Encontrado:=False;

		if C.Valido and C.P_Element.Next /= Null then
			C.P_Element:= C.P_Element.Next;
		elsif C.Valido and C.P_Element.Next  = Null then
			while  C.Pos /= Hash_Range'Last and not Encontrado loop
					C.Pos:= C.Pos + 1;
				if C.M.P_Array.all(C.Pos) /= Null then
					C.P_Element:= C.M.P_Array.all(C.Pos);
					Encontrado:=True;
				end if;
			end loop;

			if not Encontrado then
				C.Valido := False;
			end if;

		end if;
   end Next;
--____________________________________________________________________________--

   function Element (C: Cursor) return Element_Type is
   begin
      if C.Valido  then
         return (Key   => C.P_Element.Key,
                 Value => C.P_Element.Value);
      else
         raise No_Element;
      end if;
   end Element;
--____________________________________________________________________________--

   function Has_Element (C: Cursor) return Boolean is
   begin
      return C.Valido;
   end Has_Element;

--____________________________________________________________________________--

end Hash_Maps_G;
