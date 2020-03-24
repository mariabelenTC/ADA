with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Handlers;
procedure chat_client_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	Usage_Error:exception;
	Ignored:exception;
	Shutdown:exception;

	use type CM.Message_Type;
--____________________________________________________________________________--
	procedure comprobar_comandos (maquina:out ASU.Unbounded_String;
	 										puerto:out Natural;
											nickname: out ASU.Unbounded_String) is
	begin
		if ACL.Argument_Count = 3 then
			maquina:=ASU.To_Unbounded_String(ACL.Argument(1));
			puerto:=Natural'Value(ACL.Argument(2));
			nickname:=ASU.To_Unbounded_String(ACL.Argument(3));
		else
			raise Usage_Error;
		end if;
	end comprobar_comandos;
--____________________________________________________________________________--
	procedure Crear_EP (	Server_EP: out LLU.End_Point_Type;
								Maquina:ASU.Unbounded_String;
								Puerto:Natural) is
		Dir_IP:ASU.Unbounded_String;
	begin
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build (ASU.To_String(Dir_IP),Puerto);
	end Crear_EP;
--____________________________________________________________________________--
	Procedure Build_Message_Init(P_Buffer: access  LLU.Buffer_Type;
											Client_EP_Receive: LLU.End_Point_Type;
											Client_EP_Handler: LLU.End_Point_Type;
											Nickname:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Init);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Receive);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(P_Buffer, Nickname);
	end Build_Message_Init;
--____________________________________________________________________________--
	Procedure Build_Message_Writer (	P_Buffer: access  LLU.Buffer_Type;
												Client_EP_Handler: LLU.End_Point_Type;
												Nickname,Comentario: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Writer);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer, Comentario);
	end Build_Message_Writer;
--____________________________________________________________________________--
	Procedure Build_Message_Logout (	P_Buffer: access LLU.Buffer_Type;
												Client_EP_Handler: LLU.End_Point_Type;
												Nickname: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Logout);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
	end Build_Message_Logout;
--____________________________________________________________________________--
	procedure Extract_Message_Welcome ( P_Buffer: access  LLU.Buffer_Type;
													Acogido: out Boolean) is
		Type_Mess:CM.Message_Type;
	begin
		Type_Mess:=CM.Message_Type'Input(P_Buffer);
		Acogido:=Boolean'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Welcome;
--____________________________________________________________________________--
	procedure Modo_Escritor_Lector(Client_EP_Receive:in LLU.End_Point_Type;
									Client_EP_Handler:in LLU.End_Point_Type;
									Server_EP: in LLU.End_Point_Type;
									Nickname:in ASU.Unbounded_String;
									P_Buffer: access LLU.Buffer_Type) is

		Comentario:ASU.Unbounded_String;
	begin
		ATIO.Put(">>");
		ATIO.New_Line;
		Loop
			ATIO.Put(">>");
			Comentario:=ASU.To_Unbounded_String(ATIO.Get_Line);
			if ASU.To_String(Comentario) /=".quit" then
				Build_Message_Writer(P_Buffer,Client_EP_Handler,Nickname,Comentario);
				LLU.send(Server_EP,P_Buffer);
			else
				Build_Message_Logout(P_Buffer,Client_EP_Handler,Nickname);
				LLU.send(Server_EP,P_Buffer);
			end if;
			exit when ASU.To_String(Comentario)=".quit" ;
		end loop;
	end Modo_Escritor_Lector;
--____________________________________________________________________________--
	Maquina:ASU.Unbounded_String;
	Puerto:Natural;
	Server_EP: LLU.End_Point_Type;
	Nickname: ASU.Unbounded_String;
	Client_EP_Receive,Client_EP_Handler: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
	Acogido,Expired:Boolean;

begin
	comprobar_comandos(Maquina,Puerto,Nickname);
	Crear_EP(Server_EP,Maquina,Puerto);

	LLU.Bind_Any(Client_EP_Receive);
	LLU.Bind_Any(Client_EP_Handler,Handlers.Client_Handler'Access);

	Build_Message_Init(Buffer'Access,Client_EP_Receive,Client_EP_Handler,Nickname);
	LLU.send(Server_EP,Buffer'Access);

	LLU.Reset(Buffer);
	LLU.Receive(Client_EP_Receive,Buffer'Access, 10.0, Expired);
	if Expired then
		raise Shutdown;
	else
		Extract_Message_Welcome(Buffer'Access,Acogido);
		if Acogido then
			ATIO.Put_Line("Mini-Chat_2 v2.0: Welcome " & ASU.To_String(Nickname));
			Modo_Escritor_Lector(Client_EP_Receive,Client_EP_Handler,Server_EP,Nickname,Buffer'Access);
			ATIO.New_Line;
		else
			ATIO.Put_Line("Mini-Chat_2 v2.0: IGNORED new user "
										& ASU.To_String(Nickname) & ", nick already used");
			raise Ignored;
		end if;
	end if;
	LLU.Finalize;
--------------------------------------------------------------------------------
	exception
	when Usage_Error =>
		ATIO.Put_Line("Usage:  ./client  <Maquina>  <Puerto>  <Nickname> ");
		LLU.Finalize;
	When Shutdown =>
		ATIO.Put_Line("Server unreachable");
		LLU.Finalize;
	When Ignored =>
		LLU.Finalize;
	when Ex:others =>
		ATIO.Put_Line ("Excepción imprevista: " &
		Ada.Exceptions.Exception_Name(Ex) & " en: " &
		Ada.Exceptions.Exception_Message(Ex));
		LLU.Finalize;
end chat_client_2;
