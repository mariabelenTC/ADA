with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Client_Collections;

procedure chat_server is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CC renames Client_Collections;

	use type CM.Message_Type;
	Usage_Error:exception;
	Shutdown: exception;
---------------------------------------------------------------------------------------
	procedure Check_Command(Port:out Natural;Password_Server: out ASU.Unbounded_String) is
	begin
		if ACL.Argument_Count = 2 then
			Port:=Natural'Value(ACL.Argument(1));
			Password_Server:=ASU.To_Unbounded_String(ACL.Argument(2));
		else
			raise Usage_Error;
		end if;
	end Check_Command;
--------------------------------------------------------------------------------------
	procedure Build_EP(Server_EP: out LLU.End_Point_Type; Puerto:Natural) is
		Maquina:ASU.Unbounded_String;
		Dir_IP:ASU.Unbounded_String;
	begin
		Maquina:=ASU.To_Unbounded_String(LLU.Get_Host_Name);
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build(ASU.To_String(Dir_IP) ,Puerto);
	end Build_EP;
-------------------------------------------------------------------------------------
	Procedure Build_Menssage_Server(P_Buffer: access LLU.Buffer_Type; Nickname,Message: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Server);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer,Message);
	end Build_Menssage_Server;
-------------------------------------------------------------------------------------
	procedure Build_Message_Collection_Data(P_Buffer:access LLU.Buffer_Type;
													Data:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Collection_Data);
		ASU.Unbounded_String'Output(P_Buffer,Data);
	end Build_Message_Collection_Data;
--------------------------------------------------------------------------------
	procedure Build_Message_Welcome(P_Buffer:access LLU.Buffer_Type;
													Nick:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Welcome);
		ASU.Unbounded_String'Output(P_Buffer,Nick);
	end Build_Message_Welcome;
---------------------------------------------------------------------------------------
	procedure Evaluar_Nickname(P_Buffer: access LLU.Buffer_Type;Nickname: in ASU.Unbounded_String;
								EP:in LLU.End_Point_Type;
								L_Escritores,L_Lectores:out CC.Collection_Type) is
		Message:ASU.Unbounded_String;
	begin
		begin
			if ASU.To_String(Nickname)= "reader" then
				ATIO.Put_Line("Init received from reader");
				CC.Add_Client(L_Lectores,EP,Nickname,False);
			else
				CC.Add_Client(L_Escritores,EP,Nickname,True);
				ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname));
			----------Enviar mensaje de bienvenida al cliente escritor----------
				Build_Message_Welcome(P_Buffer,Nickname);
				LLU.send(EP,P_Buffer);
			--------------------------------------------------------------------
				Message:= ASU.To_Unbounded_String(ASU.To_String(Nickname) & " joins the chat");
				Build_Menssage_Server(P_Buffer,ASU.To_Unbounded_String("server"),Message);
				CC.Send_To_All(L_Lectores,P_Buffer);
			end if;
		exception
			when CC.Client_Collection_Error =>
					ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname)
													& ". IGNORED, nick already used");
		end;
	end Evaluar_Nickname;
--------------------------------------------------------------------------------
	procedure Evaluar_Tipo_Mess(P_Buffer: access LLU.Buffer_Type;
								L_Escritores,L_Lectores:out CC.Collection_Type;
										Password_Server:ASU.Unbounded_String) is
		Tipo_Mess:CM.Message_Type;
		Client_EP,Admin_EP: LLU.End_Point_Type;
		Message,Nickname,Password_Admin,Nick_To_Ban,Data:ASU.Unbounded_String;
	begin
		Tipo_Mess:=CM.Message_Type'Input(P_Buffer);
		if Tipo_Mess = CM.Init then
			Client_EP := LLU.End_Point_Type'Input(P_Buffer);
			Nickname:=ASU.Unbounded_String'Input(P_Buffer);

			Evaluar_Nickname(P_Buffer,Nickname,Client_EP,L_Escritores,L_Lectores);
		elsif Tipo_Mess = CM.Writer then
			begin
				Client_EP := LLU.End_Point_Type'Input(P_Buffer);
				Nickname:=CC.Search_Client(L_Escritores,Client_EP);
				Message:=ASU.Unbounded_String'Input(P_Buffer);

				ATIO.Put_Line("WRITER received from "& ASU.To_String(Nickname)
				 					& ": "& ASU.To_String(Message));

				Build_Menssage_Server(P_Buffer,Nickname,Message);
				CC.Send_To_All(L_Lectores,P_Buffer);
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("WRITER received from unknown client. IGNORED ");
			end;
		elsif Tipo_Mess = CM.Logout then
			begin
				Client_EP:= LLU.End_Point_Type'Input(P_Buffer);
				Nickname:=CC.Search_Client(L_Escritores,Client_EP);
				CC.Delete_Client(L_Escritores,Nickname);
				ATIO.Put_Line("LOGOUT received from " & ASU.To_String(nickname));
				Message:=ASU.To_Unbounded_String(ASU.To_String(Nickname) & " leaves the chat" );
				Nickname:=ASU.To_Unbounded_String("Server");
				Build_Menssage_Server(P_Buffer,Nickname,Message);
				CC.Send_To_All(L_Lectores,P_Buffer);
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("LOGOUT received from unknown client. IGNORED ");
			end;
		elsif Tipo_Mess = CM.Collection_Request then

			Admin_EP:= LLU.End_Point_Type'Input (P_Buffer);
			Password_Admin:= ASU.Unbounded_String'Input(P_Buffer);

			if ASU.To_String(Password_Admin)/=ASU.To_String(Password_Server) then
				ATIO.Put_Line("LIST_REQUEST received. IGNORED, incorrect password");
			else
				ATIO.Put_Line("LIST_REQUEST received");
				Data:= ASU.To_Unbounded_String(CC.Collection_Image(L_Escritores));
				Build_Message_Collection_Data(P_Buffer,Data);
				LLU.Send(Admin_EP,P_Buffer);
			end if;
		elsif Tipo_Mess = CM.Shutdown then

			Password_Admin:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset (P_Buffer.all);
			if ASU.To_String(Password_Admin)/=ASU.To_String(Password_Server) then
				ATIO.Put_Line("SHUTDOWN received. IGNORED, incorrect password");
			else
				ATIO.Put_Line("SHUTDOWN received");
				Message:=ASU.To_Unbounded_String(ASU.To_String(Nickname) & "removed by admin" );
				Nickname:=ASU.To_Unbounded_String("Server ");
				Build_Menssage_Server(P_Buffer,Nickname,Message);
				CC.Send_To_All(L_Lectores,P_Buffer);
				raise shutdown;
			end if;
		elsif Tipo_Mess = CM.Ban then
			Password_Admin:= ASU.Unbounded_String'Input(P_Buffer);
			Nick_To_Ban:= ASU.Unbounded_String'Input(P_Buffer);
			begin
				if ASU.To_String(Password_Admin)/=ASU.To_String(Password_Server) then
					ATIO.Put_Line("BAN received. IGNORED, incorrect password");
				else
					ATIO.Put_Line("BAN received from " & ASU.To_String(Nick_To_Ban));
					CC.Delete_Client(L_Escritores,Nick_To_Ban);
					Message:=ASU.To_Unbounded_String(ASU.To_String(Nick_To_Ban) & " removed from chat" );
					Nickname:=ASU.To_Unbounded_String("Admin");
					Build_Menssage_Server(P_Buffer,Nickname,Message);
					CC.Send_To_All(L_Lectores,P_Buffer);
				end if;
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("BAN received. IGNORED, nick not found");
			end;
		end if;
	end Evaluar_Tipo_Mess;
-------------------------------------------------------------------------------------
	procedure Modo_Server(Server_EP:LLU.End_Point_Type;P_Buffer:access LLU.Buffer_Type;Password_Server:ASU.Unbounded_String) is
		Expired:Boolean;
		L_Escritores,L_Lectores:CC.Collection_Type;
	begin
		ATIO.New_Line;
		ATIO.Put_Line("-- Servidor Lanzado");
		loop
			LLU.Reset(P_Buffer.all);
			LLU.Receive(Server_EP, P_Buffer, 1000.0, Expired);
			if Expired then
				ATIO.Put_Line ("Plazo expirado, vuelvo a intentarlo");
			else
				Evaluar_Tipo_Mess(P_Buffer,L_Escritores,L_Lectores,Password_Server);
			end if;
		end loop;

	end Modo_Server;
-------------------------------------------------------------------------------------
	Puerto:Natural;
	Password_Server:ASU.Unbounded_String;
	Server_EP: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
begin
	Check_Command(Puerto,Password_Server);
	Build_EP(Server_EP,Puerto);
	LLU.Bind(Server_EP);	-- se ata al End_Point para poder recibir en él
	-- bucle infinito
	Modo_Server(Server_EP,Buffer'Access,Password_Server);
	-- nunca se alcanza este punto
	-- si se alcanzara, habría que llamar a LLU.Finalize;
	exception
	when Usage_Error =>
		ATIO.Put_Line("Usage:  ./server  <Puerto>");
		LLU.Finalize;
	when shutdown =>
 		LLU.Finalize;
	when Ex:others =>
		ATIO.Put_Line ("Excepción imprevista: " &
	                        Ada.Exceptions.Exception_Name(Ex) & " en: " &
	                        Ada.Exceptions.Exception_Message(Ex));
		LLU.Finalize;
end chat_server;
