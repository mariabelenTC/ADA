with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Ordered_Maps_G is

	procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
		I_Inicial: Integer;
		I_Final: Integer;
		I_Medio: Integer;
	begin
		
		I_Inicial:= 1;
		I_Final:= M.Length;
		I_Medio:= I_Inicial + (((I_Final-I_Inicial)/2));
		while ((I_Final-I_Inicial) > 2) loop
			if(Key < M.P_Array.all(I_Medio).Key) then
				I_Final:= I_Medio-1;
			else
				I_Inicial:= I_Medio;
			end if;
			I_Medio:= I_Inicial + (((I_Final-I_Inicial)/2));

		end loop;

		I_Medio:= I_Inicial + ((I_Final-I_Inicial)/2);

		if (Key = M.P_Array.all(I_Inicial).Key) then
			Value:= M.P_Array.all(I_Inicial).Value;
			Success:= True;
		elsif (Key = M.P_Array.all(I_Final).Key) then
			Value:= M.P_Array.all(I_Final).Value;
			Success:= True;	
		elsif (Key = M.P_Array.all(I_Medio).Key) then
			Value:= M.P_Array.all(I_Medio).Value;
			Success:= True;	
		else
			Success:= False;
		end if;

	end Get;



	procedure Desplazar_Array_Derecha(M: in out Map; I_Inicial: in Integer; I_Final: in Integer) is
		I_Aux: Integer;
		Key_Aux1: Key_Type;
		Value_Aux1: Value_Type;
		Key_Aux2: Key_Type;
		Value_Aux2: Value_Type;
	begin

		I_Aux:= I_Inicial;
		
		
		Key_Aux1:= M.P_Array.all(I_Aux+1).Key;
		Value_Aux1:= M.P_Array.all(I_Aux+1).Value;

		M.P_Array.all(I_Aux+1).Key:= M.P_Array.all(I_Aux).Key;
		M.P_Array.all(I_Aux+1).Value:= M.P_Array.all(I_Aux).Value;
		I_Aux:= I_Aux+1;



		if(I_Aux = I_Final) then
			
			M.P_Array.all(I_Aux+1).Key:= Key_Aux1;
			M.P_Array.all(I_Aux+1).Value:= Value_Aux1;

		else
			while (I_Aux < I_Final) loop
	
	
				Key_Aux2:= M.P_Array.all(I_Aux+1).Key;
				Value_Aux2:= M.P_Array.all(I_Aux+1).Value;
	
				M.P_Array.all(I_Aux+1).Key:= Key_Aux1;
				M.P_Array.all(I_Aux+1).Value:= Value_Aux1;
			
				I_Aux:= I_Aux+1;
	
				Key_Aux1:= M.P_Array.all(I_Aux+1).Key;
				Value_Aux1:= M.P_Array.all(I_Aux+1).Value;
	
				M.P_Array.all(I_Aux+1).Key:= Key_Aux2;
				M.P_Array.all(I_Aux+1).Value:= Value_Aux2;
			
				I_Aux:= I_Aux+1;
	
	
			end loop;
		end if;
	end Desplazar_Array_Derecha;


	procedure Desplazar_Array_Izquierda(M: in out Map; I_Inicial: Integer) is
		I_Aux: Integer;
		I_Final: Integer;
	begin
		I_Aux:= I_Inicial;
		I_Final:= M.Length;
		while(I_Aux <= I_Final) loop
			M.P_Array.all(I_Aux-1).Key:= M.P_Array.all(I_Aux).Key;
			M.P_Array.all(I_Aux-1).Value:= M.P_Array.all(I_Aux).Value;	
			I_Aux:= I_Aux+1;
		end loop;
	end Desplazar_Array_Izquierda;


	procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
		I_Inicial: Integer;
		I_Final: Integer;
		I_Medio: Integer;
	begin	
		I_Inicial:= 1;
		I_Final:= M.Length;
		I_Medio:= I_Inicial + ((I_Final-I_Inicial)/2);
	
		if (M.Length = 0) then	

			M.P_Array.all(1).Key:= Key;
			M.P_Array.all(1).Value:= Value;
			M.P_Array.all(1).Full:= True;
			M.Length:= M.Length+1;		

		elsif (M.P_Array.all(I_Final).Key < Key) then

			M.P_Array.all(I_Final+1).Key:= Key;
			M.P_Array.all(I_Final+1).Value:= Value;
			M.P_Array.all(I_Final+1).Full:= True;
			M.Length:= M.Length+1;	

		elsif (Key < M.P_Array.all(I_Inicial).Key) then 
		
			Desplazar_Array_Derecha(M, I_Inicial, M.Length); --Incluímos el primero que queremos desplazar
			M.P_Array.all(I_Inicial).Key:= Key;
			M.P_Array.all(I_Inicial).Value:= Value;
			M.Length:= M.Length+1;
			M.P_Array.all(M.Length).Full:= True;

		else 

			while ((I_Final-I_Inicial) > 1) loop

				if(Key < M.P_Array.all(I_Medio).Key) then
					I_Final:= I_Medio-1;
				else
					I_Inicial:= I_Medio;
				end if;
				I_Medio:= I_Inicial + ((I_Final-I_Inicial)/2);
	
			end loop; 
		
			if (M.P_Array.all(I_Inicial).Key = Key) then
			
				M.P_Array.all(I_Inicial).Value:= Value;
				M.P_Array.all(I_Inicial).Full:= True;
	
			elsif (M.P_Array.all(I_Final).Key = Key) then
	
				M.P_Array.all(I_Final).Value:= Value;
				M.P_Array.all(I_Final).Full:= True;

			else

				Desplazar_Array_Derecha(M, I_Final, M.Length);
				M.P_Array.all(I_Final).Key:= Key;
				M.P_Array.all(I_Final).Value:= Value;
				M.Length:= M.Length+1;
				M.P_Array.all(M.Length).Full:= True;
			end if;
		
		end if;
	end Put;


	procedure Delete (M      : in out Map;
                      Key     : in  Key_Type;
                      Success : out Boolean) is
		I_Inicial: Integer;
		I_Final: Integer;
		I_Aux: Integer;
		Encontrado: Boolean;
	begin

		I_Inicial:= 1;	
		I_Final:= M.Length;	
		Success:= False;

		if(M.Length = 0) then

			Success:= False;

		elsif(M.Length = 1) then
		
			if(M.P_Array.all(1).Key= Key) then
				M.P_Array.all(1).Key:= M.P_Array.all(I_Final+1).Key ;
				M.P_Array.all(1).Full:= False;
				M.Length:= M.Length-1;
				Success:= True;
			end if;

		elsif(M.P_Array.all(I_Inicial).Key = Key) then
			Desplazar_Array_Izquierda(M, I_Inicial+1);
			M.P_Array.all(M.Length).Full:= False;
			M.Length:= M.Length-1;
			Success:= True;

		elsif(M.P_Array.all(I_Final).Key = Key) then
			M.P_Array.all(M.Length).Full:= False;
			M.Length:= M.Length-1;
			Success:= True;

		else
			I_Aux:= 1;
			Encontrado:= False;
			while(I_Aux <= I_Final and not Encontrado) loop
	
				if (M.P_Array.all(I_Aux).Key = Key)	then
					Encontrado:= True;
				else
					I_Aux:= I_Aux+1;
				end if;

			end loop;
			if(Encontrado) then
				Desplazar_Array_Izquierda(M, I_Aux+1);	
				M.P_Array.all(M.Length).Full:= False;
				M.Length:= M.Length-1;
				Success:= True;	
			end if;	
		end if;
	
	
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
	begin
		C.Index:= C.Index+1;
		C.Celda:= C.M.P_Array.all(C.Index);
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



end Ordered_Maps_G;
