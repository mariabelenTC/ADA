with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Ordered_Maps_G is

--____________________________________________________________________________--

	procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
      Fin:Boolean;
      i_inicial,i_final,i_medio:Integer;
	begin
      i_inicial:=1;
      i_final:=M.Length;
		Success:=False;
      fin:=False;

      while not Success and not Fin and M.Length/=0 loop
         I_Medio:= i_inicial + ((i_final-i_inicial)/2);
         if i_final < i_inicial then
            fin:=True;
         end if;
         if M.P_Array.all(i_medio).key = Key then
              Value := M.P_Array.All(i).Value;
              Success := True;
      	elsif Key < M.P_Array.all(i_medio).key then
            i_final:= I_Medio-1;
            if i_final = 0 or i_medio=M.Length then
               Fin:=True;
            end if;
			else
				i_inicial:= i_medio+1;
            if i_inicial > M.Length then
               Fin:=True;
            end if;
			end if;
		end loop;
	end Get;

--____________________________________________________________________________--

   procedure Build_Cell(i:Integer;
                        M: in out Map;
                        Key   : Key_Type;
                        Value : Value_Type) is
   begin
   	M.P_Array.all(i).Key:= Key;
   	M.P_Array.all(i).Value:= Value;
   	M.P_Array.all(i).Full:= True;
   end Build_Cell;

--____________________________________________________________________________--

   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
      Fin,Menor,Found,Full: Boolean;
		i,h: Integer:=1;--Posicion
      i_medio:Integer;
      i_inicial:Integer;
		i_final:Integer;
      M_Aux: Cell;
   begin
      i_inicial:=1;
      i_final:=M.Length;
      Menor:=False;
      Found:=False;
      Fin:=False;
		if M.Length = Max_Clients then
			Full:= True;
		else
			Full:=False;
		end if;

		-- Si ya existe Key, cambiamos su Value

      while M.Length/=0 and not Found and not Fin  loop
         Ada.Text_IO.Put_Line(" entra aqui en el bucle de buscar porque hay elementos");
         I_Medio:= i_inicial + ((i_final-i_inicial)/2);
         if i_final < i_inicial then
            fin:=True;
            i:=i_final;
         end if;
         if M.P_Array.all(i_medio).key=Key then
              i:=i_medio;
              Found:=True;
              M.P_Array.all(i_medio).Value:=Value;
      	elsif Key < M.P_Array.all(i_medio).key then
   Ada.Text_IO.Put_Line(" entro y comparo si mi key es menor que el que esta");

            i:=i_medio;
            i_final:= I_Medio-1;

            if i_final = 0 or i_medio=M.Length then
               Fin:=True;
            else
               i:=I_Medio;
            end if;
            Menor:=True;
			else
   Ada.Text_IO.Put_Line(" entro y comparo si mi key es Mayor que el que esta");

				i_inicial:= I_Medio+1;
            i:=i_inicial;
            if i_inicial > M.Length then
               Fin:=True;
            else
               i:=i_inicial + 1;
            end if;
			end if;
		end loop;



      Ada.Text_IO.Put_Line("Hola Posicion:  " & Integer'Image(i));
      ---- Si el Key no existe, tenemos la i donde deberia ir y si
      ---- Menor = True desplazamos.

      if M.Length = 0  then
         Ada.Text_IO.Put_Line(" entra aqui para añadir porque no hay elementos");
         Build_Cell(1,M,Key,Value);  --i:=1;
         M.Length:= M.Length+1;
      elsif not found and not Full and not Menor then
         Ada.Text_IO.Put_Line(Integer'Image(i) & " aqui añado la nueva que no esta");
         Build_Cell(i,M,Key,Value);
			M.Length:= M.Length+1;
      elsif not found and not Full and  Menor then
         Ada.Text_IO.Put_Line(Integer'Image(i) & " aqui añado la nueva que no esta y luego tengo q");

         --M_Aux:=M;
         --M_Aux.P_Array.all(i).Key:= Key;
         --M_Aux.P_Array.all(i).Value:= Value;
         --M_Aux.P_Array.all(i).Full:= True;

         for k in  M.Length ..i loop
            M_Aux.Key:=M.P_Array.all(k).Key;
            M_Aux.Value:=M.P_Array.all(k).Value;

            M.P_Array.all(k+1).Key:= M_Aux.Key;
            M.P_Array.all(k+1).Value:= M_Aux.Value;
            M.P_Array.all(k+1).Full:= True;

         end loop;

         M.P_Array.all(i).Key:= Key;
         M.P_Array.all(i).Value:= Value;
         M.P_Array.all(i).Full:= True;

         M.Length:= M.Length+1;

		elsif not Found and Full then
			raise Full_Map;
		end if;
      Ada.Text_IO.Put_Line("Salgo y tendria que salir");
   end Put;
--____________________________________________________________________________--

   procedure Delete (M      : in out Map;
   						Key     : in  Key_Type;
   						Success : out Boolean) is
      i:Integer;
      Menor,Fin:Boolean;

      M_Aux:Cell;
      i_inicial,i_final,i_medio:Integer;
	begin
		i:=1;
      i_inicial:=1;
      i_final:=M.Length;
		Success:=False;
      Menor:=False;
      Fin:=False;

      while M.Length/=0 and not Success and not Fin  loop
         Ada.Text_IO.Put_Line(" entra aqui en el bucle de buscar porque hay elementos");
         I_Medio:= i_inicial + ((i_final-i_inicial)/2);
         if i_final < i_inicial then
            fin:=True;
            i:=i_final;
         end if;
         if M.P_Array.all(i_medio).key=Key then
              i:=i_medio;
              Success:=True;
         elsif Key < M.P_Array.all(i_medio).key then
   Ada.Text_IO.Put_Line(" entro y comparo si mi key es menor que el que esta");

            i:=i_medio;
            i_final:= I_Medio-1;

            if i_final = 0 or i_medio=M.Length then
               Fin:=True;
            else
               i:=I_Medio;
            end if;
            Menor:=True;
         else
   Ada.Text_IO.Put_Line(" entro y comparo si mi key es Mayor que el que esta");

            i_inicial:= I_Medio+1;
            i:=i_inicial;
            if i_inicial > M.Length then
               Fin:=True;
            else
               i:=i_inicial + 1;
            end if;
         end if;
      end loop;

      if Success then
         for k in  i .. M.Length loop
            M.P_Array.all(k).Key:= M.P_Array.all(k+1).Key;
            M.P_Array.all(k).Value:= M.P_Array.all(k+1).Value;
            M.P_Array.all(k).Full:= True;
         end loop;
         M.Length:= M.Length-1;

   	end if;
   end Delete;
--____________________________________________________________________________--

   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

--=============================CURSOR=========================================--

   function First (M: Map) return Cursor is
		Esta:Boolean;
	begin
		if M.Length/=0 then
			Esta:=True;
		else
			Esta:=False	;
		end if;

      return (M => M, Pos =>1, Valido => Esta);
   end First;
--____________________________________________________________________________--

   procedure Next (C: in out Cursor) is
	begin
      Ada.Text_IO.Put_Line(Integer'Image(C.Pos));


      if C.Pos >= C.M.Length then
         C.Valido:=False;
      else
         C.Pos:=C.Pos+1;
         Ada.Text_IO.Put_Line(Integer'Image(C.Pos));
      end if;

   end Next;
--____________________________________________________________________________--

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
--____________________________________________________________________________--

   function Has_Element (C: Cursor) return Boolean is
   begin
      return C.Valido;
   end Has_Element;
--____________________________________________________________________________--

end Ordered_Maps_G;
