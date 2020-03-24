with Ada.Text_IO;
with Ada.Strings.Maps;
with Ada.Unchecked_Deallocation;

package body Client_Collections is
	package ATIO renames Ada.Text_IO;
	package ASM renames Ada.Strings.Maps;
--------------------------------------------------------------------------------
	function Nick_Encontrado(Collection: Collection_Type;
										Nick:ASU.Unbounded_String)  return Boolean is
		P_Nick:Cell_A;
		Encontrado:Boolean;
	begin
		Encontrado:=false;
		P_Nick:=Collection.P_First;
		if P_Nick = null then
			Encontrado:=False;
		end if;
		while (P_Nick/= null)and not Encontrado loop
			if ASU.To_String(Nick)= ASU.To_String(P_Nick.Nick) then
				Encontrado:=True;
			else
				P_Nick:=P_Nick.Next;
			end if;
		end loop;
		return Encontrado;
	end Nick_Encontrado;
--------------------------------------------------------------------------------
	procedure Build_Cell(Collection:in out Collection_Type;
							EP: in LLU.End_Point_Type;Nick: in  ASU.Unbounded_String) is
		P_New_Nick:Cell_A;
	begin
		-- guardar tipo Pila
		P_New_Nick:=new cell'(EP,Nick,null);
		P_New_Nick.Next:=Collection.P_First;
		Collection.P_First:=P_New_Nick;
		Collection.Total:= Collection.Total + 1;

	end Build_Cell;
--------------------------------------------------------------------------------
	procedure Add_Client(Collection:in out Collection_Type;
		EP:in LLU.End_Point_Type;Nick:in ASU.Unbounded_String;Unique:in Boolean) is
	begin
		if Nick_Encontrado(Collection,Nick)and Unique = True then
			ATIO.Put_Line(ASU.To_String(Nick)& ": nombre no disponible");
		else
			Build_Cell(Collection,EP,Nick);
		end if;
	end Add_Client;
--------------------------------------------------------------------------------
	function EP_Encontrado(Collection: Collection_Type;
									EP: LLU.End_Point_Type) return ASU.Unbounded_String is
		use type LLU.End_Point_Type;
		P_EP:Cell_A;
		Nick: ASU.Unbounded_String;
		Encontrado:Boolean;
	begin
		P_EP:=Collection.P_First;
		Encontrado:=False;
		if P_EP = null then
			raise Client_Collection_Error;
		end if;
		while (P_EP/= null)and (not Encontrado) loop
			if(EP= P_EP.Client_EP) then
				Encontrado:=True;
				Nick:=P_EP.Nick;
			else
				P_EP:=P_EP.Next;
			end if;
		end loop;
		return nick;
	end EP_Encontrado;
--------------------------------------------------------------------------------
	function Search_Client (Collection: in Collection_Type;
								EP: in LLU.End_Point_Type) return ASU.Unbounded_String is
		Nick: ASU.Unbounded_String;
		Encontrado:Boolean;
	begin
		Nick:=EP_Encontrado(Collection,EP);
		Encontrado:=Nick_Encontrado(Collection,Nick);
		if not Encontrado then
			--raise Client_Collection_Error;
			ATIO.Put_Line("EP no encontrada");
		end if;
		return Nick;
	end Search_Client;
--------------------------------------------------------------------------------
	procedure Free is new Ada.Unchecked_Deallocation(Cell, Cell_A);
	procedure Delete_Client (Collection: in out Collection_Type;
										Nick:in ASU.Unbounded_String) is
		P_Aux1,P_Aux2:Cell_A;
		contador: Natural;
		Encontrado: Boolean;
	begin
		P_Aux1:=Collection.P_First;
		P_Aux2:=Collection.P_First;
		contador:= 0;
		--Encontrado:=Nick_Encontrado(Collection,Nick);

		Encontrado:=False;
		while Collection.P_First/=null and (not Encontrado) loop
			if contador = 0 then
				P_Aux2:= P_Aux2.Next;
				contador:= contador+1;
			else
				P_Aux1:= P_Aux1.Next;
				P_Aux2:= P_Aux2.Next;
			end if;
			if ASU.To_String(Nick) = ASU.To_String(P_Aux1.Nick) then
				Encontrado:=True;
				Collection.P_First:=Collection.P_First.Next;
				Collection.Total:=Collection.Total - 1;
				Free(P_Aux1);
			elsif ASU.To_String(Nick) = ASU.To_String(P_Aux2.Nick) then
				P_Aux2 := P_Aux2.Next;
				Collection.Total:=Collection.Total - 1;
				Free(P_Aux1.Next);
				P_Aux1.Next:= P_Aux2;
				Encontrado:= True;
			end if;

		end loop;
		if not Encontrado then
			--raise Word_Collection.P_First_Error;
			ATIO.Put_Line("nick no Encontrado");
		end if;

	end Delete_Client;
--------------------------------------------------------------------------------
	procedure Send_To_All(Collection: in Collection_Type;
											P_Buffer: access LLU.Buffer_Type) is
		P_Aux: Cell_A;
	begin
		P_Aux:=Collection.P_First;
		if P_Aux = null then
			--raise Client_Collection_Error;
			ATIO.Put_Line("lista vacia");
		end if;
		while P_Aux /= null loop
			LLU.send(P_Aux.Client_EP,P_Buffer);
			P_Aux:=P_Aux.Next;
		end loop;

	end Send_To_All;
--------------------------------------------------------------------------------
	function Total(Collection:in Collection_Type)return Natural is
		Total:Natural;
	begin
		Total:=Collection.Total;
		return Total;
	end Total;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	procedure Trocear_EP(EP_Image:in ASU.Unbounded_String;
										IP,Puerto: out ASU.Unbounded_String) is
		P_Delimitador:Integer;
		Length_F:Natural;
		Frase:ASU.Unbounded_String;
	begin
		Frase:=EP_Image;
		Length_F:=ASU.Length(Frase);
		P_Delimitador:= ASU.Index(Frase,"IP: ");
		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+3));
		Length_F:=ASU.Length(Frase);
		P_Delimitador := ASU.Index(Frase,", Port:  ");
		IP := ASU.Head(Frase,P_Delimitador-1);
		Length_F:=ASU.Length(Frase);
		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+8));
		Puerto := Frase;
	end Trocear_EP;
---------------------------------------------------------------------------------
	function print_EP_y_Nick (List:Cell_A) return String is
		IP,Puerto:ASU.Unbounded_String;
		EP_ASU,EP_y_Nick:ASU.Unbounded_String;
	begin
		EP_ASU:=ASU.To_Unbounded_String(LLU.Image(List.Client_EP));
		Trocear_EP(EP_ASU,IP,Puerto);
		EP_y_Nick:=ASU.To_Unbounded_String(ASU.To_String(IP) & ":"
					& ASU.To_String(Puerto) &
					" " & ASU.To_String(List.Nick));
		return ASU.To_String(EP_y_Nick);
	end print_EP_y_Nick;
--------------------------------------------------------------------------------
	function Build_Image(Nick,IP,Puerto:ASU.Unbounded_String) return String is
		Image:ASU.Unbounded_String;
	begin
		Image:=ASU.To_Unbounded_String(ASU.To_String(IP) & ":"
					& ASU.To_String(Puerto) &
					" " & ASU.To_String(Nick));
		return ASU.To_String(Image);

	end Build_Image;


	function Collection_Image(Collection: in Collection_Type)return String is
		P_Aux:Cell_A;
		IP,Puerto,Image,EP_ASU:ASU.Unbounded_String;
	begin
		Image:= ASU.To_Unbounded_String("");
		P_Aux:=Collection.P_First;
		if Collection.Total/=0 then
			while P_Aux /= null loop
				EP_ASU:=ASU.To_Unbounded_String(LLU.Image(P_Aux.Client_EP));
				Trocear_EP(EP_ASU,IP,Puerto);
				Image:= ASU.To_Unbounded_String(ASU.To_String(Image) & Build_Image(P_Aux.Nick,IP,Puerto) & ASCII.LF);
				P_Aux:= P_Aux.Next;
			end loop;
		end if;
		return ASU.To_String(Image);
	end Collection_Image;
--------------------------------------------------------------------------------
procedure Print_All(Collection: in Collection_Type) is
	P_Aux:Cell_A;
	IP,Puerto:ASU.Unbounded_String;
	EP_ASU:ASU.Unbounded_String;
begin
	P_Aux:=Collection.P_First;
	if P_Aux=null then
		ATIO.Put_Line("");
	end if;
	while P_Aux /= null loop
		EP_ASU:=ASU.To_Unbounded_String(LLU.Image(P_Aux.Client_EP));

		Trocear_EP(EP_ASU,IP,Puerto);
		--ATIO.Put_Line(print_EP_y_Nick(P_Aux));
		ATIO.Put_Line(ASU.To_String(IP)& " :" & ASU.To_String(Puerto) & " " & ASU.To_String(P_Aux.Nick));
		P_Aux:=P_Aux.Next;

	end loop;
end Print_All;

--------------------------------------------------------------------------------


end Client_Collections;
