with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

package chat_messages is

	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;

	type Message_Type is (Init,Welcome,Writer,Server,Logout,Ack);
	type Seq_N_T is mod Integer'Last;

--===================MENSAJES DEL CLIENTE AL SERVER Y VICEVERSA =========================--

	procedure Build_Message_Ack ( P_Buffer: access LLU.Buffer_Type;
											EP_H_ACKer: in LLU.End_Point_Type;
											N_Scn:in Seq_N_T);

--===================MENSAJES DEL CLIENTE AL SERVER ==========================--

	Procedure Build_Message_Init (P_Buffer: access  LLU.Buffer_Type;
											Client_EP_Receive:in LLU.End_Point_Type;
											Client_EP_Handler:in LLU.End_Point_Type;
											Nickname:in ASU.Unbounded_String);

	Procedure Build_Message_Writer (	P_Buffer: access  LLU.Buffer_Type;
												Client_EP_Handler: LLU.End_Point_Type;
												Seq_N:Handlers.Seq_N_T;
												Nickname,Comentario: ASU.Unbounded_String);

	Procedure Build_Message_Logout (	P_Buffer: access LLU.Buffer_Type;
												Client_EP_Handler: LLU.End_Point_Type;
												Seq_N: Handlers.Seq_N_T;
												Nickname: ASU.Unbounded_String);

--===================MENSAJES DEL SERVER AL CLIENTE===========================--

	Procedure Build_Message_Welcome( P_Buffer: access LLU.Buffer_Type;
												Acogido: in Boolean);

	Procedure Build_Menssage_Server( P_Buffer: access LLU.Buffer_Type;
												Type_Mess:in Message_Type;
												N_Scn:in Seq_N_T;
												Nick: in ASU.Unbounded_String;
												Message:in out ASU.Unbounded_String);

	procedure Build_Menssage_Banned(	P_Buffer: access LLU.Buffer_Type;
												Old_Nick: in ASU.Unbounded_String );

--========================CLIENTE EXTRAE MENSAJE DEL SERVER===================--

	Procedure Extract_Message_Server(P_Buffer: access LLU.Buffer_Type;
												N_Scn: out Seq_N_T;
												Nickname,Text:out ASU.Unbounded_String);

--=======================SERVER EXTRAE MENSAJE DEL CLIENTE====================--

	procedure Extract_Message_Welcome (	P_Buffer: access  LLU.Buffer_Type;
													Acogido: out Boolean);


--============================================================================--
end chat_messages;
