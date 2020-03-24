
package body chat_messages  is

--============== MENSAJES DEL CLIENTE AL SERVER Y VICEVERSA ==================--

	procedure Build_Message_Ack ( P_Buffer: access LLU.Buffer_Type;
											EP_H_ACKer: in LLU.End_Point_Type;
											N_Scn:in Seq_N_T) is
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Ack);
		LLU.End_Point_Type'Output(P_Buffer,EP_H_ACKer);
		Seq_N_T'Output(P_Buffer,N_Scn);
	end Build_Mess_Ack;

--================== MENSAJES DEL CLIENTE AL SERVER ==========================--

	Procedure Build_Message_Init(	P_Buffer: access  LLU.Buffer_Type;
											Client_EP_Receive: in LLU.End_Point_Type;
											Client_EP_Handler: in LLU.End_Point_Type;
											Nickname:in ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Init);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Receive);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(P_Buffer, Nickname);
	end Build_Message_Init;

--____________________________________________________________________________--

	Procedure Build_Message_Writer (	P_Buffer: access  LLU.Buffer_Type;
												Client_EP_Handler: LLU.End_Point_Type;
												Seq_N: Seq_N_T;
												Nickname,Comentario: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Writer);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		Handlers.Seq_N_T'Output(P_Buffer,Seq_N);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer, Comentario);
	end Build_Message_Writer;

--____________________________________________________________________________--

	Procedure Build_Message_Logout (	P_Buffer: access LLU.Buffer_Type;
												Client_EP_Handler: in LLU.End_Point_Type;
												Seq_N: in Seq_N_T;
												Nickname: in ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Logout);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		Handlers.Seq_N_T'Output(P_Buffer,Seq_N);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
	end Build_Message_Logout;

--===================MENSAJES DEL SERVER AL CLIENTE===========================--

	Procedure Build_Message_Welcome( P_Buffer: access LLU.Buffer_Type;
												Acogido: in Boolean) is
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Welcome);
		Boolean'Output(P_Buffer,Acogido);
	end Message_Welcome;

--__________________________________________________________________________--

	Procedure Build_Menssage_Server( P_Buffer: access LLU.Buffer_Type;
												Type_Mess:in Message_Type;
												N_Scn:in Seq_N_T;
												Nick: in ASU.Unbounded_String;
												Message:in out ASU.Unbounded_String) is
		Nick_Server:ASU.Unbounded_String;
	begin
		Nick_Server:=ASU.To_Unbounded_String("Server");
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Server);
		LLU.End_Point_Type'Output(P_Buffer,Server_EP_Handler);
		Seq_N_T'Output(P_Buffer,N_Scn);
		if Type_Mess = Init then
			Message:= ASU.To_Unbounded_String(ASU.To_String(Nick) & " joins the chat");
			ASU.Unbounded_String'Output(P_Buffer,Nick_Server);
			ASU.Unbounded_String'Output(P_Buffer,Message);
		elsif Type_Mess = Writer then
			ASU.Unbounded_String'Output(P_Buffer,Nick);
			ASU.Unbounded_String'Output(P_Buffer,Message);
		elsif Type_Mess = Logout then
			Message:=ASU.To_Unbounded_String(ASU.To_String(Nick) & " leaves the chat" );
			ASU.Unbounded_String'Output(P_Buffer,Nick_Server);
			ASU.Unbounded_String'Output(P_Buffer,Message);
		end if;

	end Build_Menssage_Server;

--____________________________________________________________________________--

	procedure Build_Menssage_Banned(	P_Buffer: access LLU.Buffer_Type;
												Old_Nick:in ASU.Unbounded_String ) is
		Message,Nick_Server:ASU.Unbounded_String;
	begin
		LLU.Reset(P_Buffer.all);
		Message_Type'Output(P_Buffer,Server);
		Nick_Server:=(ASU.To_Unbounded_String("Server"));
		Message:= ASU.To_Unbounded_String(ASU.To_String(Old_Nick)
														&" Banned for beging idle too long");
		ASU.Unbounded_String'Output(P_Buffer,Nick_Server);
		ASU.Unbounded_String'Output(P_Buffer,Message);
	end Build_Menssage_Banned;

--========================CLIENTE EXTRAE MENSAJE DEL SERVER===================--

	Procedure Extract_Message_Server(P_Buffer: access LLU.Buffer_Type;
												N_Scn:out Seq_N_T;
												Nickname,Text:out ASU.Unbounded_String) is

	begin
		Server_EP_Handler:=LLU.End_Point_Type'Input(P_Buffer);
		N_Scn:=Seq_N_T'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Text:=ASU.Unbounded_String'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Server;

--=======================SERVER EXTRAE MENSAJE DEL CLIENTE====================--

	procedure Extract_Message_Welcome ( P_Buffer: access  LLU.Buffer_Type;
													Acogido: out Boolean) is
		Type_Mess:Message_Type;
	begin
		Type_Mess:=Message_Type'Input(P_Buffer);
		Acogido:=Boolean'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Welcome;

--============================================================================--


end chat_messages;
