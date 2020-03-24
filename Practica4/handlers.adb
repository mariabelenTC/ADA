package body Handlers is

	Max_Old_List: Integer:= 2;

	package Maps is new Ordered_Maps_G (Key_Type   => ASU.Unbounded_String,
                                Value_Type => Tipo_Datos,
								Max        => Integer'Value(Ada.Command_Line.Argument(2)),
								"<"        => Comparador_Array.Menor,
                                "="        => ASU."=");


	package Maps_Old is new Ordered_Maps_G (Key_Type  => ASU.Unbounded_String,
                               		Value_Type => Ada.Calendar.Time,
									Max => Max_Old_List,
									"<"        => Comparador_Array.Menor,
                                	"="        => ASU."=");

	use type Maps.Element_Type;
	use type Maps.Map;

	Key: ASU.Unbounded_String;
	Value: ASU.Unbounded_String;
	Success: Boolean;

	Clients_Map: Maps.Map;
	Old_Clients: Maps_Old.Map;

	function Imagen_EP(EP: in LLU.End_Point_Type) return ASU.Unbounded_String is
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
		return ASU.To_Unbounded_String(ASU.To_String(IP) & ":" & ASU.To_String(Port));

	end Imagen_EP;

	function Time_Image(T: Ada.Calendar.Time) return String is
	begin
		return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
	end Time_Image;

	procedure Mostrar_Mapa(lista: in ASU.Unbounded_String) is
		C_Actual: Maps.Cursor:= Maps.First(Clients_Map);
		C_Viejo: Maps_Old.Cursor:= Maps_Old.First(Old_Clients);
		Nick: ASU.Unbounded_String;
		Counter: Natural;
		Client_EP: LLU.End_Point_Type;
		Client_Time: Ada.Calendar.Time;
	begin
		if(lista = ASU.To_Unbounded_String("actual")) then
			while Maps.Has_Element(C_Actual) loop
				Nick:= Maps.Element(C_Actual).Key;
				Client_EP:= Maps.Element(C_Actual).Value.EP;
				Client_Time:= Maps.Element(C_Actual).Value.Time;
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " (" & ASU.To_String(Imagen_EP(Client_EP)) & "): "
									 & Time_Image(Client_Time));
				Maps.Next(C_Actual);
			end loop;
		else
			Counter:= 0;
			while (Maps_Old.Has_Element(C_Viejo) and (Counter < Max_Old_List)) loop
				Nick:= Maps_Old.Element(C_Viejo).Key;
				Client_Time:= Maps_Old.Element(C_Viejo).Value;
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & ": " & Time_Image(Client_Time));
				Maps_Old.Next(C_Viejo);
				Counter:= Counter+1;
			end loop;
		end if;
	end Mostrar_Mapa;

	procedure Crear_Comentario_Server(P_Buffer: access LLU.Buffer_Type; Nick: ASU.Unbounded_String; Comentario: ASU.Unbounded_String) is
		
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer, CM.Server);
		ASU.Unbounded_String'Output(P_Buffer, Nick);
		ASU.Unbounded_String'Output(P_Buffer, Comentario);
	end Crear_Comentario_Server;


	procedure Reenviar_Writer_Atodos(P_Buffer: access LLU.Buffer_Type;
									 Clients_Map: in Maps.Map; 
									 Nick_Escribe: ASU.Unbounded_String;
									 Nick_Nuevo: ASU.Unbounded_String;
									 Comentario: ASU.Unbounded_String) is
		C: Maps.Cursor:= Maps.First(Clients_Map);
		Nick: ASU.Unbounded_String;
		Client: LLU.End_Point_Type;

	begin
		while Maps.Has_Element(C) loop
			Nick:= Maps.Element(C).Key;
			if(Nick /= Nick_Escribe) then
				Crear_Comentario_Server(P_Buffer, Nick_Nuevo, Comentario);
				Client:= Maps.Element(C).Value.EP;
				LLU.Send(Client, P_Buffer);
			end if;
			Maps.Next(C);
		end loop;
		LLU.Reset(P_Buffer.all);
	end Reenviar_Writer_Atodos;

	procedure Responder_Init(P_Buffer: access LLU.Buffer_Type; 
							 Clients_Map: in out Maps.Map) is
		Acogido: Boolean;
		Long_Antes: Integer;
		Long_Despues: Integer;
		Client_Nickname: ASU.Unbounded_String;
		Client_EP_Receive: LLU.End_Point_Type;
		Client_EP_Handler: LLU.End_Point_Type;
		Datos_Client_Handler: Tipo_Datos;
		Nick_Nuevo: ASU.Unbounded_String;
		Comentario: ASU.Unbounded_String;
		Long: Natural;
		Nick_Viejo: ASU.Unbounded_String;
		Nick_Aux: ASU.Unbounded_String;
		Datos_Client_Viejo: Tipo_Datos;
		Datos_Client_Aux: Tipo_Datos;
		Success: Boolean;
			
		procedure darusuarioviejo(M     : in out Maps.Map;
                  				  Key   : in out ASU.Unbounded_String;
                  		   		  Value : in out Tipo_Datos) is
				C: Maps.Cursor:= Maps.First(M);
				Key_Guia: ASU.Unbounded_String;
				Value_Guia: Tipo_Datos;
				Time_Guia: Ada.Calendar.Time;
				Client_Time: Ada.Calendar.Time;
				Counter: Natural;
				Fin: Boolean;
		begin
				Counter:= 1;
				Fin:= False;
				Key_Guia:= Maps.Element(C).Key;
				Value_Guia:= Maps.Element(C).Value;
				Time_Guia:= Maps.Element(C).Value.Time;

				while(Maps.Has_Element(C) and (not Fin)) loop

					Client_Time:= Maps.Element(C).Value.Time;
					if(Client_Time < Time_Guia) then
						Time_Guia:= Client_Time;
						Key_Guia:= Maps.Element(C).Key;
						Value_Guia:= Maps.Element(C).Value;	
					end if;
					if(Counter < Maps.Map_Length(M)) then
						Maps.Next(C);
					else 
						Fin:= True;
					end if;

				end loop;

				Key:= Key_Guia;
				Value:= Value_Guia;

		end darusuarioviejo;


		procedure darusuarioantiguo(M     : in out Maps_Old.Map;
                  				  Key   : in out ASU.Unbounded_String;
                  		   		  Value : in out Ada.Calendar.Time) is
				C: Maps_Old.Cursor:= Maps_Old.First(M);
				Key_Guia: ASU.Unbounded_String;
				Time_Guia: Ada.Calendar.Time;
				Client_Time: Ada.Calendar.Time;
				Counter: Natural;
				Fin: Boolean;
		begin
				Counter:= 1;
				Fin:= False;
				Key_Guia:= Maps_Old.Element(C).Key;
				Time_Guia:= Maps_Old.Element(C).Value;

				while(Maps_Old.Has_Element(C) and (not Fin)) loop

					Client_Time:= Maps_Old.Element(C).Value;
					if(Client_Time < Time_Guia) then
						Time_Guia:= Client_Time;
						Key_Guia:= Maps_Old.Element(C).Key;	
					end if;
					if(Counter < Maps_Old.Map_Length(M)) then
						Maps_Old.Next(C);
					else 
						Fin:= True;
					end if;

				end loop;

				Key:= Key_Guia;
				Value:= Time_Guia;

		end darusuarioantiguo;

	begin
		Client_EP_Receive:= LLU.End_Point_Type'Input(P_Buffer);
		Client_EP_Handler:= LLU.End_Point_Type'Input(P_Buffer);
		Client_Nickname:= ASU.Unbounded_String'Input(P_Buffer);
		Datos_Client_Handler.EP:= Client_EP_Handler;
		Datos_Client_Handler.Time:= Ada.Calendar.Clock;
		LLU.Reset(P_Buffer.all);

		Long:= Maps.Map_Length(Clients_Map);

		if(Long = Integer'Value(Ada.Command_Line.Argument(2))) then			

			darusuarioviejo(Clients_Map, Nick_Viejo, Datos_Client_Viejo);
			Maps.Get(Clients_Map, Nick_Viejo, Datos_Client_Viejo, Success);
			Maps.Delete(Clients_Map, Nick_Viejo, Success);
			if Success  then 
				Maps.Put(Clients_Map, Client_Nickname, Datos_Client_Handler);
				Long:= Maps_Old.Map_Length(Old_Clients);
				if(Long = Max_Old_List) then
					Nick_Aux:= Nick_Viejo;
					Datos_Client_Aux:= Datos_Client_Viejo;
					darusuarioantiguo(Old_Clients, Nick_Viejo, Datos_Client_Viejo.Time);
					Maps_Old.Delete(Old_Clients, Nick_Viejo, Success);

					Datos_Client_Aux.Time:= Ada.Calendar.Clock;
					Maps_Old.Put(Old_Clients, Nick_Aux, Datos_Client_Aux.Time);
				else
					Datos_Client_Viejo.Time:= Ada.Calendar.Clock;
					Maps_Old.Put(Old_Clients, Nick_Viejo, Datos_Client_Viejo.Time);
				end if;
				Acogido:= True;
				Ada.Text_IO.Put_Line("INIT received from " & ": " & ASU.To_String(Client_Nickname) & " ACCEPTED");
			end if;

		else
			Long_Antes:= Maps.Map_Length(Clients_Map);
			Maps.Put(Clients_Map, Client_Nickname, Datos_Client_Handler);
			Long_Despues:= Maps.Map_Length(Clients_Map);
			if(Long_Antes = Long_Despues) then
				Acogido:= False;
				Ada.Text_IO.Put_Line("INIT received from " & ": " & ASU.To_String(Client_Nickname) & " IGNORED");
			else
				Acogido:= True;
				Ada.Text_IO.Put_Line("INIT received from " & ": " & ASU.To_String(Client_Nickname) & " ACCEPTED");
			end if;
		end if;

		CM.Message_Type'Output(P_Buffer, CM.Welcome);
		Boolean'Output(P_Buffer, Acogido);
		LLU.Send(Client_EP_Receive, P_Buffer);
		LLU.Reset (P_Buffer.all);		

		
		Comentario:= Client_Nickname & ASU.To_Unbounded_String(" joins the chat");
		Nick_Nuevo:= ASU.To_Unbounded_String("server");
		Reenviar_Writer_Atodos(P_Buffer, Clients_Map, Client_Nickname, Nick_Nuevo, Comentario);	

	end Responder_Init;


	procedure Server_Handler (From: in LLU.End_Point_Type; 
							  To: in LLU.End_Point_Type; 
							  P_Buffer: access LLU.Buffer_Type) is

		Nick_Escribe: ASU.Unbounded_String;
		Nick_Nuevo: ASU.Unbounded_String;
		Request: ASU.Unbounded_String;
		Reply: ASU.Unbounded_String;
		Comentario: ASU.Unbounded_String;
		Client_EP_Handler: LLU.End_Point_Type;
		Mess_Type: CM.Message_Type;
		Success: Boolean;
		Datos_Client_Escribe: Tipo_Datos;
	begin
--		Nick_Escribe:= ASU.To_Unbounded_String("");		
		Mess_Type:= CM.Message_Type'Input(P_Buffer);

		if (Mess_Type = CM.Init) then
			Responder_Init(P_Buffer, Clients_Map);


		elsif(Mess_Type = CM.Writer) then

			Client_EP_Handler:= LLU.End_Point_Type'Input(P_Buffer);	
			Nick_Escribe:= ASU.Unbounded_String'Input(P_Buffer);
			Comentario:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Maps.Get(Clients_Map, Nick_Escribe, Datos_Client_Escribe, Success);

			if(Success and Datos_Client_Escribe.EP = Client_EP_Handler) then
				Datos_Client_Escribe.Time:= Ada.Calendar.Clock;
				Maps.Put(Clients_Map, Nick_Escribe, Datos_Client_Escribe);
				Ada.Text_IO.Put_Line("WRITER received from " & ASU.To_String(Nick_Escribe) & ": " & ASU.To_String(Comentario));
				Reenviar_Writer_Atodos(P_Buffer, Clients_Map, Nick_Escribe, Nick_Escribe, Comentario);
			else
				Ada.Text_IO.Put_Line("WRITER received from unknown client " & "IGNORED");
			end if;


		elsif(Mess_Type = CM.Logout) then

			Client_EP_Handler:= LLU.End_Point_Type'Input(P_Buffer);
			Nick_Escribe:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);

			Maps.Get(Clients_Map, Nick_Escribe, Datos_Client_Escribe, Success);
			if(Success and (Datos_Client_Escribe.EP = Client_EP_Handler) ) then
				Maps.Delete(Clients_Map, Nick_Escribe, Success);
				Ada.Text_IO.Put_Line("LOGOUT received from " & ASU.To_String(Nick_Escribe));
				Comentario:= Nick_Escribe & ASU.To_Unbounded_String(" leaves the chat");
				Nick_Nuevo:= ASU.To_Unbounded_String("server");
				Reenviar_Writer_Atodos(P_Buffer, Clients_Map, Nick_Nuevo, Nick_Nuevo, Comentario);

				Datos_Client_Escribe.Time:= Ada.Calendar.Clock;
				Maps_Old.Put(Old_Clients, Nick_Escribe, Datos_Client_Escribe.Time);
			else
				Ada.Text_IO.Put_Line ("Get: NO hay una entrada para la clave");
			end if;
		end if;

    end Server_Handler;




	procedure Client_Handler (From    : in     LLU.End_Point_Type;
                             To      : in     LLU.End_Point_Type;
                             P_Buffer: access LLU.Buffer_Type) is
	
		Nick: ASU.Unbounded_String;
		Comentario: ASU.Unbounded_String;
		Mess_Type: CM.Message_Type;
	begin

		Mess_Type:= CM.Message_Type'Input(P_Buffer);
		Nick:= ASU.Unbounded_String'Input(P_Buffer);
		Comentario:= ASU.Unbounded_String'Input(P_Buffer);
		if(Mess_Type = CM.Server) then
			Ada.Text_IO.New_Line;
			Ada.Text_IO.Put(ASU.To_String(Nick));
			Ada.Text_IO.Put(": ");
			Ada.Text_IO.Put_Line(ASU.To_String(Comentario));	
			Ada.Text_IO.Put(">> ");	
		end if;
	

	end Client_Handler;

end Handlers;

