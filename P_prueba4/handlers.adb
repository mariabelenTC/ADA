with gnat.os_lib;
--Tabulador 3

package body Handlers is
--------------------------------------------------------------------------------
	function get_max_clients return Integer is
	begin
	   return Integer'Value(ACL.Argument(2));
	exception
		when others =>
			ATIO.Put_Line("Usage:  ./server  <Puerto> <Numero de clientes> <min_delay> <max_delay> <fault_pct>");
			ATIO.Put_Line("o");
			ATIO.Put_Line("Usage:  ./client  <Maquina>  <Puerto>  <Nickname>  <min_delay> <max_delay> <fault_pct> ");
	      gnat.os_lib.os_exit(0);
	end get_max_clients;
--------------------------------------------------------------------------------
	package Active_Clients is new Maps_G (Key_Type => ASU.Unbounded_String ,
											Value_Type => Valores_T,
											Max_Clients=> get_max_clients,
											"=" => ASU."=");

	package Inactive_Clients is new Maps_G (Key_Type => ASU.Unbounded_String ,
											Value_Type => AC.Time,
											Max_Clients=> 150,
											"=" => ASU."=");

--=============================CLIENTE HANDLERS===============================--
--============================================================================--

	procedure Client_Handler (	From: in LLU.End_Point_Type;
	 									To: in LLU.End_Point_Type;
										P_Buffer: access LLU.Buffer_Type) is
		Type_Mess: CM.Message_Type;
		Server_EP_Handler:LLU.End_Point_Type;
		Name,Text:ASU.Unbounded_String;

	begin
		Type_Mess:= CM.Message_Type'Input(P_Buffer);
		if Type_Mess = CM.Server then
			ATIO.New_Line;
			CM.Extract_Message_Server(P_Buffer,Name,Text);
			ATIO.Put(ASU.To_String(name) & ": ");
			ATIO.Put_Line(ASU.To_String(Text));
			ATIO.Put(">>");
		end if;
	end Client_Handler;

--=============================SERVER HANDLERS================================--
--============================================================================--

	procedure Print_Active_Clients (M : Active_Clients.Map) is
		C: Active_Clients.Cursor := Active_Clients.First(M);
		IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;
		Client_Time:AC.Time;
	begin
		ATIO.New_Line;
		ATIO.Put_Line("                   ACTIVE CLIENTS");
		ATIO.Put_Line("=================================================");
		while Active_Clients.Has_Element(C) loop
			EP_ASU:=ASU.To_Unbounded_String(LLU.Image(Active_Clients.Element(C).Value.EP));
			EP_Image:=G.Image_EP(EP_ASU);
			Client_Time:=Active_Clients.Element(C).Value.hora;

			ATIO.Put_Line (ASU.To_String(Active_Clients.Element(C).Key)
			 							& ASU.To_String(EP_Image) & " : " &
								 		G.Time_Image(Client_Time));
			Active_Clients.Next(C);
		end loop;
		ATIO.Put_Line("=================================================");
		ATIO.New_Line;
	end Print_Active_Clients;
--____________________________________________________________________________--

	procedure Print_Inactive_Clients (M : Inactive_Clients.Map) is
		C: Inactive_Clients.Cursor := Inactive_Clients.First(M);
		IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;
		Client_Time: AC.Time;
	begin
		ATIO.New_Line;
		ATIO.Put_Line("                    OLD CLIENTS");
		ATIO.Put_Line("=================================================");
		while Inactive_Clients.Has_Element(C) loop
			Client_Time:= Inactive_Clients.Element(C).Value;
			ATIO.Put_Line (ASU.To_String(Inactive_Clients.Element(C).Key) & ":  " &
								 		G.Time_Image(Client_Time));
			Inactive_Clients.Next(C);
		end loop;
		ATIO.Put_Line("=================================================");
		ATIO.New_Line;
	end Print_Inactive_Clients;
--____________________________________________________________________________--

	procedure Get_Old_User( M :  Active_Clients.Map;
									Key: out ASU.Unbounded_String;
									Value:out Valores_T) is
		use type Ada.Calendar.Time;
		C: Active_Clients.Cursor := Active_Clients.First(M);
		Hora_Inicio,Client_Time: AC.Time;
		Found_Old_Time:Boolean;
	begin
		Found_Old_Time:=False;
		Hora_Inicio := Active_Clients.Element(C).Value.Hora;
		Key:=Active_Clients.Element(C).Key;
		Value:=Active_Clients.Element(C).Value;

		while  Active_Clients.Has_Element(C) loop
			Client_Time:=Active_Clients.Element(C).Value.hora;
			if(Client_Time < Hora_Inicio) then
				Hora_Inicio:= Client_Time;
				Key:=Active_Clients.Element(C).Key;
				Value:=Active_Clients.Element(C).Value;
			end if;
			Active_Clients.Next(C);
		end loop;
	end Get_Old_User;
--____________________________________________________________________________--

	procedure Send_To_All (	P_Buffer: access LLU.Buffer_Type;
									Type_Mess:CM.Message_Type;
									Clients: in Active_Clients.Map;
									Nickname: in ASU.Unbounded_String;
									Message:in out ASU.Unbounded_String) is
		C: Active_Clients.Cursor := Active_Clients.First(Clients);
		Nickname_Igual:ASU.Unbounded_String;
		Client_EP:LLU.End_Point_Type;
	begin
		LLU.Reset(P_Buffer.all);
		while Active_Clients.Has_Element(C) loop
			Nickname_Igual:=Active_Clients.Element(C).Key;
			if Nickname_Igual /= Nickname then
				CM.Build_Menssage_Server(P_Buffer,Type_Mess,Nickname,Message);
				Client_EP:=Active_Clients.Element(C).Value.EP;
				LLU.Send(Client_EP,P_Buffer);
			end if;
			Active_Clients.Next(C);
		end loop;
	end Send_To_All;
--____________________________________________________________________________--

	procedure Add_Client(Clients:in out Active_Clients.Map;
								EP_Receive,EP_Handler: LLU.End_Point_Type;
								P_Buffer: access LLU.Buffer_Type;
								Type_Mess: CM.Message_Type;
								Nickname:in out ASU.Unbounded_String) is
		Success:Boolean;
		Datos_Clientes: Valores_T;
		Message:ASU.Unbounded_String;
	begin
		Active_Clients.Get(Clients,Nickname,Datos_Clientes,Success);
		if not Success then
			CM.Build_Message_Welcome(P_Buffer,True);
			LLU.Send(EP_Receive,P_Buffer);
			ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname) & ": ACCEPTED");
			Datos_Clientes.EP:=EP_Handler;
			Datos_Clientes.Hora:=AC.Clock;
			Active_Clients.Put(Clients,Nickname,Datos_Clientes);

			Send_To_All(P_Buffer,Type_Mess,Clients,Nickname,Message);
		else
			CM.Build_Message_Welcome(P_Buffer,False);
			LLU.Send(EP_Receive,P_Buffer);
			ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname) &
				". IGNORED, nick already used");
		end if;
	end Add_Client;
--____________________________________________________________________________--

	procedure Procesar_Full_Map (	Clients:in out Active_Clients.Map;
											Old_Clients:in out Inactive_Clients.Map;
											P_Buffer: access LLU.Buffer_Type) is

		C: Active_Clients.Cursor := Active_Clients.First(Clients);
		Old_datos_Client: Valores_T;
		Old_Nick,Nickname_Igual:ASU.Unbounded_String;
		Client_EP:LLU.End_Point_Type;
		Success : Boolean;
	begin
		Get_Old_User(Clients,Old_Nick,Old_datos_Client);
		while Active_Clients.Has_Element(C) loop
			CM.Build_Menssage_Banned(P_Buffer,Old_Nick);
			Client_EP:=Active_Clients.Element(C).Value.EP;
			LLU.Send(Client_EP,P_Buffer);
			Active_Clients.Next(C);
		end loop;
		Active_Clients.Delete(Clients, Old_Nick, Success);
		begin
			Inactive_Clients.Put(Old_Clients,Old_Nick,Old_datos_Client.Hora);
		exception
			When Inactive_Clients.Full_Map=>
				null;
		end;
	end Procesar_Full_Map;
--____________________________________________________________________________--

	procedure Procesar_Init(P_Buffer: access LLU.Buffer_Type;
									Type_Mess:in CM.Message_Type;
									Clients:out Active_Clients.Map;
									Old_Clients:out Inactive_Clients.Map) is
		Datos_Clientes: Valores_T;
		EP_Receive,EP_Handler:LLU.End_Point_Type;
		Nickname: ASU.Unbounded_String;
	begin
		EP_Receive:=LLU.End_Point_Type'Input(P_Buffer);
		EP_Handler:=LLU.End_Point_Type'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		begin
			Add_Client(Clients,EP_Receive,EP_Handler,P_Buffer,Type_Mess,Nickname);
		exception
			when Active_Clients.Full_Map =>
				Procesar_Full_Map(Clients,Old_Clients,P_Buffer);
				Datos_Clientes.EP:=EP_Handler;
				Datos_Clientes.Hora:=AC.Clock;
				Active_Clients.Put(Clients,Nickname,Datos_Clientes);
		end;
	end Procesar_Init;
--____________________________________________________________________________--

	procedure Procesar_Writer( P_Buffer: access LLU.Buffer_Type;
										Type_Mess:in CM.Message_Type;
										Clients:in out Active_Clients.Map) is
		Success:Boolean;
		Datos_Clientes:Valores_T;
		EP_Handler:LLU.End_Point_Type;
		N_Scn:Seq_N_T
		Nickname:ASU.Unbounded_String;
		Message:ASU.Unbounded_String;
	begin
		EP_Handler:=LLU.End_Point_Type'Input(P_Buffer);
		N_Scn:=Seq_N_T'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Active_Clients.Get(Clients,Nickname,Datos_Clientes,Success);
		if Success and EP_Handler = Datos_Clientes.EP then
			Datos_Clientes.Hora:=AC.Clock;
			Active_Clients.Put(Clients,Nickname,Datos_Clientes);
			Message:=ASU.Unbounded_String'Input(P_Buffer);

			-- Guardar datos del mensaje Writer

			ATIO.Put_Line("WRITER received from "& ASU.To_String(Nickname)
			 													& ": "& ASU.To_String(Message));
			Send_To_All(P_Buffer,Type_Mess,Clients,Nickname,Message);
			LLU.Reset(P_Buffer.all);
		else
			ATIO.Put_Line("WRITER received from unknown client. IGNORED ");
		end if;
	end Procesar_Writer;
----____________________________________________________________________________--

	procedure Procesar_Logout( P_Buffer: access LLU.Buffer_Type;
										Type_Mess:in CM.Message_Type;
										Clients:in out Active_Clients.Map;
										Old_Clients:in out Inactive_Clients.Map) is
		EP_Handler: LLU.End_Point_Type;
		Nickname: ASU.Unbounded_String;
		Message:ASU.Unbounded_String;
		Success:Boolean;
		Datos_Clientes:Valores_T;
		N_Scn:Seq_N_T;
	begin
		EP_Handler:=LLU.End_Point_Type'Input(P_Buffer);
		N_Scn:= Seq_N_T'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Active_Clients.Get(Clients,Nickname,Datos_Clientes,Success);
		if Success and EP_Handler = Datos_Clientes.EP then
			Datos_Clientes.Hora:=AC.Clock;

			--Guardar datos del mensaje Logout

			Active_Clients.Put(Clients,Nickname,Datos_Clientes);
			ATIO.Put_Line("LOGOUT received from " & ASU.To_String(nickname));
			Send_To_All(P_Buffer,Type_Mess,Clients,Nickname,Message);
			Active_Clients.Delete(Clients,Nickname, Success);
			Inactive_Clients.Put(Old_Clients,Nickname,Datos_Clientes.Hora);
		else
			ATIO.Put_Line("LOGOUT received from unknown client. IGNORED ");
		end if;
	end Procesar_Logout;
--____________________________________________________________________________--

	Clients:Active_Clients.Map;
	Old_Clients:Inactive_Clients.Map;

--____________________________________________________________________________--

	procedure Print_Map(Lista:ASU.Unbounded_String) is
	begin
		if ASU.To_String(Lista) = "Lista Clientes Activos" then
			Print_Active_Clients(Clients);
		elsif ASU.To_String(Lista) = "Lista Clientes Inactivos" then
			Print_Inactive_Clients(Old_Clients);
		end if;
	end Print_Map;
--____________________________________________________________________________--

	procedure Server_Handler ( From: in LLU.End_Point_Type;
										To: in LLU.End_Point_Type;
										P_Buffer: access LLU.Buffer_Type) is
		Type_Mess:CM.Message_Type;
	begin
		Type_Mess:=CM.Message_Type'Input(P_Buffer);
		if Type_Mess = CM.Init then
			Procesar_Init(P_Buffer,Type_Mess,Clients,Old_Clients);
		elsif Type_Mess = CM.Writer then
			Procesar_Writer(P_Buffer,Type_Mess,Clients);
		elsif Type_Mess = CM.Logout then
			Procesar_Logout(P_Buffer,Type_Mess,Clients,Old_Clients);
		end if;

	end Server_Handler;
--============================================================================--

end Handlers;
