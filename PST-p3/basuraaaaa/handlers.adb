
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Client_Collections;

package body Handlers is


	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CC renames Client_Collections;
	use type CM.Message_Type;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	Procedure Extract_Message_Server(P_Buffer: access LLU.Buffer_Type; Tipo:out CM.Message_Type; Nickname,Text:out ASU.Unbounded_String) is
	begin
		Tipo:= CM.Message_Type'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Text:=ASU.Unbounded_String'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Server;
	----------------------------------------------------------------------------
	procedure Client_Handler (From    : in     LLU.End_Point_Type;
	                         To      : in     LLU.End_Point_Type;
	                         P_Buffer: access LLU.Buffer_Type) is

		Type_Mess: CM.Message_Type;
		Nickname,Text : ASU.Unbounded_String;
	begin
		-- saca lo recibido en el buffer P_Buffer.all
		Extract_Message_Server(P_Buffer,Type_Mess,Nickname,Text);

		ATIO.Put_Line(ASU.To_String(Nickname) & ": " & ASU.To_String(Text));
		ATIO.Put_Line(">>");
	end Client_Handler;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
	Procedure Build_Menssage_Server(P_Buffer: access LLU.Buffer_Type; Nickname,Message: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Server);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer,Message);
	end Build_Menssage_Server;
	----------------------------------------------------------------------------
	procedure Build_Message_Collection_Data(P_Buffer:access LLU.Buffer_Type;
													Data:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Collection_Data);
		ASU.Unbounded_String'Output(P_Buffer,Data);
	end Build_Message_Collection_Data;
	----------------------------------------------------------------------------
	procedure Evaluar_Type_Mess(P_Buffer: access LLU.Buffer_Type;
								L_Escritores:out CC.Collection_Type;
								Password_Server:ASU.Unbounded_String) is
		Type_Mess:CM.Message_Type;
		Client_EP,Admin_EP: LLU.End_Point_Type;
		Message,Nickname,Password_Admin,Nick_To_Ban,Data:ASU.Unbounded_String;
	begin
		Type_Mess:=CM.Message_Type'Input(P_Buffer);
		if Type_Mess = CM.Init then
			begin
			Client_EP := LLU.End_Point_Type'Input(P_Buffer);
			ATIO.Put_Line(LLU.Image(Client_EP));
			Nickname:=ASU.Unbounded_String'Input(P_Buffer);
			ATIO.Put_Line(ASU.To_String(Nickname));

			CC.Add_Client(L_Escritores,Client_EP,Nickname,True);

			ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname));
			----------------------------------------------------------------------
			--Build_Message_Welcome(P_Buffer,Nickname,True);
			--LLU.Send(EP,P_Buffer);
			----------------------------------------------------------------------
			Message:= ASU.To_Unbounded_String(ASU.To_String(Nickname) & " joins the chat");
			Build_Menssage_Server(P_Buffer,ASU.To_Unbounded_String("server "),Message);
			CC.Send_To_All(L_Escritores,P_Buffer);

			exception
				when CC.Client_Collection_Error =>
						ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname) &
							". IGNORED, nick already used");
						--Build_Message_Welcome(P_Buffer,Nickname,False);
						--LLU.Send(EP,P_Buffer);
			end;

		elsif Type_Mess = CM.Writer then
			begin
			Client_EP := LLU.End_Point_Type'Input(P_Buffer);
			ATIO.Put_Line(LLU.Image(Client_EP));
			Nickname:=CC.Search_Client(L_Escritores,Client_EP);
			ATIO.Put_Line(ASU.To_String(Nickname));

			Message:=ASU.Unbounded_String'Input(P_Buffer);
			ATIO.Put_Line(ASU.To_String(Message));

			ATIO.Put_Line("WRITER received from "& ASU.To_String(Nickname) & ": "& ASU.To_String(Message));

			Build_Menssage_Server(P_Buffer,Nickname,Message);
			CC.Send_To_All(L_Escritores,P_Buffer);
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("WRITER received from unknown client. IGNORED ");
			end;
		elsif Type_Mess = CM.Logout then
			begin
			Client_EP:= LLU.End_Point_Type'Input(P_Buffer);
			Nickname:=CC.Search_Client(L_Escritores,Client_EP);
			CC.Delete_Client(L_Escritores,Nickname);
			ATIO.Put_Line("LOGOUT received from " & ASU.To_String(nickname));
			Message:=ASU.To_Unbounded_String(ASU.To_String(Nickname) & " leaves the chat" );
			Nickname:=ASU.To_Unbounded_String("Server ");
			Build_Menssage_Server(P_Buffer,Nickname,Message);
			CC.Send_To_All(L_Escritores,P_Buffer);
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("LOGOUT received from unknown client. IGNORED ");
			end;
		elsif Type_Mess = CM.Collection_Request then

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
		elsif Type_Mess = CM.Shutdown then

			Password_Admin:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset (P_Buffer.all);
			if ASU.To_String(Password_Admin)/=ASU.To_String(Password_Server) then
				ATIO.Put_Line("SHUTDOWN received. IGNORED, incorrect password");
			else
				ATIO.Put_Line("SHUTDOWN received");
				Message:=ASU.To_Unbounded_String(ASU.To_String(Nickname) & "removed by admin" );
				Nickname:=ASU.To_Unbounded_String("Server ");
				Build_Menssage_Server(P_Buffer,Nickname,Message);
				CC.Send_To_All(L_Escritores,P_Buffer);
			end if;
		elsif Type_Mess = CM.Ban then
			Password_Admin:= ASU.Unbounded_String'Input(P_Buffer);
			Nick_To_Ban:= ASU.Unbounded_String'Input(P_Buffer);
			begin
				if ASU.To_String(Password_Admin)/=ASU.To_String(Password_Server)then
					ATIO.Put_Line("BAN received. IGNORED, incorrect password");
				else
					ATIO.Put_Line("BAN received from " & ASU.To_String(nickname));
					CC.Delete_Client(L_Escritores,Nick_To_Ban);
					Message:=ASU.To_Unbounded_String(ASU.To_String(Nick_To_Ban) & " removed from chat" );
					Nickname:=ASU.To_Unbounded_String("Admin ");
					Build_Menssage_Server(P_Buffer,Nickname,Message);
					CC.Send_To_All(L_Escritores,P_Buffer);
				end if;
			exception
				when CC.Client_Collection_Error =>
					ATIO.Put_Line("BAN received. IGNORED, nick not found");
			end;
		end if;
	end Evaluar_Type_Mess;
	----------------------------------------------------------------------------

   procedure Server_Handler (From    : in     LLU.End_Point_Type;
                             To      : in     LLU.End_Point_Type;
                             P_Buffer: access LLU.Buffer_Type) is

	L_Escritores:CC.Collection_Type;
	Password_Server:ASU.Unbounded_String;
   begin
      -- saca del Buffer P_Buffer.all un Unbounded_String

		Evaluar_Type_Mess(P_Buffer,L_Escritores,Password_Server);

   end Server_Handler;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

end Handlers;
