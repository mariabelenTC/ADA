with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Client_Collections is

	use type ASU.Unbounded_String;
	use type LLU.End_Point_Type;

	procedure Free is new
		Ada.Unchecked_Deallocation(Cell, Cell_A);

	procedure Add_Values(P_Values: in out Cell_A;
						 EP: in LLU.End_Point_Type;
                    	 Nick: in ASU.Unbounded_String) is

	begin
		P_Values:= new Cell;
		P_Values.Client_EP:= EP;
		P_Values.Nick:= Nick;
		P_Values.Next:= null;
	end Add_Values;

	procedure Add_Client(Collection: in out Collection_Type;
                    	 EP: in LLU.End_Point_Type;
                    	 Nick: in ASU.Unbounded_String;
                    	 Unique: in Boolean) is

		P_Aux: Cell_A;
		Node_Aux: Cell;
	begin
		if Collection.Total /= 0 then
			Add_Values(P_Aux, EP, Nick);
			P_Aux.all.Next:= Collection.P_First;
			Collection.P_First:= P_Aux;
		else
			Add_Values(Collection.P_First, EP, Nick);
		end if;
		Collection.Total:= Collection.Total + 1;

	end Add_Client;

	procedure Delete_Client (Collection: in out Collection_Type;
                            Nick: in ASU.Unbounded_String) is
		P_Aux, P_Ant: Cell_A;
		Encontrado, Fin: Boolean;
	begin
		P_Aux:= Collection.P_First.all.Next;
		P_Ant:= Collection.P_First;
		Encontrado:= False;
		Fin:= False;
		loop
			if P_Ant.all.Nick = Nick then
				Encontrado:= True;
				Collection.P_First:= P_Aux;
				if P_Aux = null then
					Fin:= True;
				end if;
				Free(P_Ant);		
			elsif P_Aux.all.Nick = Nick then
				Encontrado:= True;
				P_Ant.all.Next:= P_Aux.all.Next;
				if P_Aux.all.Next = null then
					Fin:= True;
				end if;
				Free(P_Aux);
			end if;
			if not Encontrado then
				P_Ant:= P_Aux;
				P_Aux:= P_Aux.all.Next;
			end if;
			exit when Encontrado or Fin;
		end loop;
	end Delete_Client;

	function Search_Client (Collection: in Collection_Type;
                             EP: in LLU.End_Point_Type)
                           return ASU.Unbounded_String is
		Encontrado: Boolean;
		P_Aux: Cell_A;
		Nick_Searched: ASU.Unbounded_String:= ASU.To_Unbounded_String("");

	begin
		P_Aux:= Collection.P_first;
		Encontrado:= False;
		if Collection.Total /= 0 then
			loop
				if P_Aux.all.Client_EP = EP then
					Encontrado:= True;
					Nick_Searched:= P_Aux.all.Nick;
				end if;
				P_Aux:= P_Aux.all.Next;
				exit when Encontrado or P_Aux = null;
			end loop;
			return Nick_Searched;

		else
			return ASU.To_Unbounded_String("");
		end if;
	end Search_Client;

	function Image_Got(EP: in LLU.End_Point_Type; Nick: ASU.Unbounded_String) return ASU.Unbounded_String is
		Aux, IP, Port: ASU.Unbounded_String;
		Length, IP_Pos, Coma_Pos, Port_Pos: Natural;
	begin
		Length:= ASU.Length(ASU.To_Unbounded_String(LLU.Image(EP)));
		IP_Pos:= ASU.Index(ASU.To_Unbounded_String(LLU.Image(EP)), ":");
		Aux:= ASU.Tail(ASU.To_Unbounded_String(LLU.Image(EP)), Length-(IP_Pos+1));
		Coma_Pos:= ASU.Index(Aux, ",");
		IP:= ASU.Head(Aux, Coma_Pos-1);
		Port_Pos:= ASU.Index(ASU.To_Unbounded_String(LLU.Image(EP)), "Port:  ") + 6;
		Port:= ASU.Tail(ASU.To_Unbounded_String(LLU.Image(EP)), Length-Port_Pos) ;
--		Ada.Text_IO.Put_Line(ASU.To_String(Port));
		return ASU.To_Unbounded_String(ASU.To_String(IP) & ":" & ASU.To_String(Port) & " " & ASU.To_String(Nick));

	end Image_Got;

	function Collection_Image(Collection: in Collection_Type) return String is
		Image: ASU.Unbounded_String;
		P_Aux: Cell_A;
	begin
		Image:= ASU.To_Unbounded_String("");
		P_Aux:= Collection.P_First;
		if Collection.Total /= 0 then
			loop  
				Image:= Image & Image_Got(P_Aux.all.Client_EP, P_Aux.all.Nick) & ASCII.LF;
				P_Aux:= P_Aux.all.Next;
				exit when P_Aux = null;
			end loop;
		end if;
		return (ASU.To_String(Image));
	end Collection_Image;

	procedure Send_To_All(Collection: in Collection_Type;
                         P_Buffer: access LLU.Buffer_Type) is
		P_Aux: Cell_A;
	begin
		P_Aux:= Collection.P_First;
		if Collection.Total /= 0 then
			loop
				LLU.Send(P_Aux.all.Client_EP, P_Buffer);
				P_Aux:= P_Aux.all.Next;
				exit when P_Aux = null;
			end loop;
		end if;
	end Send_To_All;

end Client_Collections;
