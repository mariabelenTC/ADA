package body handlers is
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	Procedure Extract_Message_Server(P_Buffer: access  LLU.Buffer_Type;
									Type_Mess:out CM.Message_Type;
									Nickname,Text:out ASU.Unbounded_String) is
	begin
		Type_Mess:= CM.Message_Type'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Text:=ASU.Unbounded_String'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Server;
	----------------------------------------------------------------------------
	procedure Client_Handler(From: in LLU.End_Point_Type; To: in LLU.End_Point_Type;
												P_Buffer: access LLU.Buffer_Type) is
		Type_Mess: CM.Message_Type;
		Name:ASU.Unbounded_String;
		Text: ASU.Unbounded_String;
	begin
		Extract_Message_Server(P_Buffer,Type_Mess,name,Text);
		ATIO.Put(ASU.To_String(name) & ": ");
		ATIO.Put_Line(ASU.To_String(Text));
		ATIO.Put(">>");

	end Client_Handler;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	Procedure Sacar_Tipo_y_Client_EP(P_Buffer: access LLU.Buffer_Type; Tipo_Mess: out CM.Message_Type;
																Client_EP: out LLU.End_Point_Type) is
	begin
		Tipo_Mess:=CM.Message_Type'Input(P_Buffer);
		Client_EP:=LLU.End_Point_Type'Input(P_Buffer);
	end Sacar_Tipo_y_Client_EP;
	------------------------------------------------------------------------------------------------------------
	Procedure Build_Menssage_Server(P_Buffer: access LLU.Buffer_Type; Nickname,Message: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Server);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer,Message);
	end Build_Menssage_Server;
	------------------------------------------------------------------------------------------------------------
	procedure Evaluar_Init(P_Buffer: access LLU.Buffer_Type;Nickname: out ASU.Unbounded_String;
								EP:in LLU.End_Point_Type;
								L_Escritores:out CC.Collection_Type) is
		Message:ASU.Unbounded_String;
	begin
		begin
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		CC.Add_Client(L_Escritores,EP,Nickname,True);
		ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname));
		Message:= ASU.To_Unbounded_String(ASU.To_String(Nickname) & " joins the chat");
		Build_Menssage_Server(P_Buffer,ASU.To_Unbounded_String("server "),Message);
		CC.Send_To_All(L_Escritores,P_Buffer);
		exception
			when CC.Client_Collection_Error =>
					ATIO.Put_Line("INIT received from " & ASU.To_String(Nickname) &
						". IGNORED, nick already used");
		end;
	end Evaluar_Init;
	------------------------------------------------------------------------------------------------------------
	procedure Evaluar_Writer(P_Buffer: access LLU.Buffer_Type;Nickname:out ASU.Unbounded_String;
								EP:in LLU.End_Point_Type;
								L_Escritores:in CC.Collection_Type) is
		Message:ASU.Unbounded_String;
	begin
		begin
		Nickname:=CC.Search_Client(L_Escritores,EP);
		Message:=ASU.Unbounded_String'Input(P_Buffer);
		ATIO.Put_Line("WRITER received from "& ASU.To_String(Nickname) & ": "& ASU.To_String(Message));
		Build_Menssage_Server(P_Buffer,Nickname,Message);
		CC.Send_To_All(L_Escritores,P_Buffer);
		exception
			when CC.Client_Collection_Error =>
					ATIO.Put_Line("WRITER received from unknown client. IGNORED ");
		end;
	end Evaluar_Writer;
	------------------------------------------------------------------------------------------------------------
	procedure Evaluar_Logout(P_Buffer: access LLU.Buffer_Type;Nickname:out ASU.Unbounded_String;
								EP:in LLU.End_Point_Type;
								L_Escritores:in out CC.Collection_Type) is
		Message:ASU.Unbounded_String;
	begin
		begin
		Nickname:=CC.Search_Client(L_Escritores,EP);
		CC.Delete_Client(L_Escritores,Nickname);
		ATIO.Put_Line("LOGOUT received from " & ASU.To_String(nickname));
		Message:=ASU.To_Unbounded_String(ASU.To_String(Nickname) & " leaves the chat" );
		Nickname:=ASU.To_Unbounded_String("Server: ");
		Build_Menssage_Server(P_Buffer,Nickname,Message);
		CC.Send_To_All(L_Escritores,P_Buffer);
		exception
			when CC.Client_Collection_Error =>
					ATIO.Put_Line("LOGOUT received from unknown client. IGNORED ");
		end;
	end Evaluar_Logout;
	------------------------------------------------------------------------------------------------------------------
	procedure Evaluar_Tipo_Mess(P_Buffer: access LLU.Buffer_Type;L_Escritores:in out CC.Collection_Type) is
		Tipo_Mess:CM.Message_Type;
		Client_EP: LLU.End_Point_Type;
		Message,Nickname:ASU.Unbounded_String;
	begin
		Sacar_Tipo_y_Client_EP(P_Buffer,Tipo_Mess,Client_EP);
		if Tipo_Mess = CM.Init then
			Evaluar_Init(P_Buffer,Nickname,Client_EP,L_Escritores);
		elsif Tipo_Mess = CM.Writer then
			Evaluar_Writer(P_Buffer,Nickname,Client_EP,L_Escritores);
		elsif Tipo_Mess = CM.Logout then
			Evaluar_Logout(P_Buffer,Nickname,Client_EP,L_Escritores);
		end if;

	end Evaluar_Tipo_Mess;
	L_Escritores:CC.Collection_Type;
	------------------------------------------------------------------------------------------------------------
	procedure Server_Handler(From: in LLU.End_Point_Type; To: in LLU.End_Point_Type;
													P_Buffer: access LLU.Buffer_Type) is

	begin
		Evaluar_Tipo_Mess(P_Buffer,L_Escritores);

	end Server_Handler;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

end handlers;
