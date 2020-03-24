with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Maps_G is

   procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
      Celda_Aux : Cell;
	  i: Integer;
   begin
	  i:= 1;
      Celda_Aux := M.P_Array.all(i);
      Success := False;
      while (not Success and Celda_Aux.Full) loop
         if (Celda_Aux.Key = Key) then
            Value := Celda_Aux.Value;
            Success := True;
         end if;
		 i:= i+1;
         Celda_Aux:= M.P_Array.all(i);
      end loop;
   end Get;


   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
      Celda_Aux : Cell;
      Found : Boolean;
	  i: Integer;
   begin
      -- Si ya existe Key, cambiamos su Value
	  i:= 1;
      Celda_Aux := M.P_Array.all(i);
      Found := False;
      while(not Found and Celda_Aux.Full) loop
         if(Celda_Aux.Full and then Celda_Aux.Key = Key) then
            Celda_Aux.Value := Value;
            Found := True;		
		 else
			i:= i+1;
         	Celda_Aux := M.P_Array.all(i);
		end if;
      end loop;

      -- Si no hemos encontrado Key 
      if(not Found) then
		i:=1;
		Celda_Aux:= M.P_Array.all(i);
		while(Celda_Aux.Full) loop
			i:= i+1;
			Celda_Aux:= M.P_Array.all(i);
		end loop;
		M.Length:= M.Length+1;
		M.P_Array.all(i).Key:= Key;
		M.P_Array.all(i).Value:= Value;
		M.P_Array.all(i).Full:= True;
      end if;
   end Put;


   procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean) is
      Ultima_Celda : Cell;
	  i: Integer;
	  Celda_Aux: Cell;
   begin
      Success := False;
	  i:= 1;
      Celda_Aux := M.P_Array.all(i);
      while (not Success and Celda_Aux.Full)  loop
         if (Celda_Aux.Key = Key) then
            Success := True;
			M.P_Array.all(i):=M.P_Array.all(M.Length);
			M.P_Array.all(M.Length).Full:= False;	
			M.Length := M.Length - 1;
         else
			i:= i+1;
            Celda_Aux := M.P_Array.all(i);
         end if;
      end loop;
   end Delete;


   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;



   function First (M: Map) return Cursor is
   begin
      return (M => M, Celda => M.P_Array.all(1), Index => 1);
   end First;


   procedure Next (C: in out Cursor) is
		M_Aux: Map;
   begin
		M_Aux:= C.M; 
		C.Index:= C.Index+1;
		C.Celda:= C.M.P_Array.all(C.Index);
		C.M:= M_Aux;
   end Next;

   function Element (C: Cursor) return Element_Type is
   begin
      if (C.Celda.Full) then
         return (Key   => C.Celda.Key,
                 Value => C.Celda.Value);
      else
         raise No_Element;
      end if;
   end Element;

   function Has_Element (C: Cursor) return Boolean is
   begin
      if (C.Celda.Full) then
         return True;
      else
         return False;
      end if;
   end Has_Element;

end Maps_G;
