with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with handlers;
procedure chat_client_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	Usage_Error: exception;

	use type CM.Message_Type;
----------------------------------------------------------------------------------------------------------
	procedure comprobar_comandos(maquina:out ASU.Unbounded_String; puerto:out Natural;
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
----------------------------------------------------------------------------------------------------------
	procedure Crear_EP(Server_EP: out LLU.End_Point_Type; Maquina:ASU.Unbounded_String; Puerto:Natural) is
		Dir_IP:ASU.Unbounded_String;
	begin
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build (ASU.To_String(Dir_IP) ,Puerto);
	end Crear_EP;
---------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Init(P_Buffer: access  LLU.Buffer_Type;
									Client_EP: LLU.End_Point_Type; Nickname:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Init);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
		ASU.Unbounded_String'Output(P_Buffer, Nickname);
	end Build_Message_Init;
--------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Writer(P_Buffer: access  LLU.Buffer_Type;
									Client_EP: LLU.End_Point_Type; Comentario: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Writer);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
		ASU.Unbounded_String'Output(P_Buffer, Comentario);
	end Build_Message_Writer;
---------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Logout (P_Buffer: access LLU.Buffer_Type;Client_EP: LLU.End_Point_Type) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Logout);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
	end Build_Message_Logout;
---------------------------------------------------------------------------------------------------------
	procedure Modo_Escritor(Client_EP,Server_EP: in LLU.End_Point_Type;Nickname:in ASU.Unbounded_String; P_Buffer: access LLU.Buffer_Type) is
		Comentario:ASU.Unbounded_String;

	begin
		Build_Message_Init(P_Buffer,Client_EP,Nickname);
		LLU.send(Server_EP,P_Buffer);
		Loop
			Comentario:=ASU.To_Unbounded_String(ATIO.Get_Line);
			if ASU.To_String(Comentario) /=".quit" then
				Build_Message_Writer(P_Buffer,Client_EP,Comentario);
				LLU.send(Server_EP,P_Buffer);
			else
				Build_Message_Logout(P_Buffer,Client_EP);
				LLU.send(Server_EP,P_Buffer);
			end if;
			exit when ASU.To_String(Comentario)=".quit" ;
		end loop;
	end Modo_Escritor;
--------------------------------------------------------------------------------
	Maquina:ASU.Unbounded_String;
	Puerto:Natural;
	Server_EP: LLU.End_Point_Type;
	Nickname: ASU.Unbounded_String;
	Client_EP: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);

begin
	comprobar_comandos(Maquina,Puerto,Nickname);
	Crear_EP(Server_EP,Maquina,Puerto);
	LLU.Bind_Any(Client_EP,handlers.Client_Handler'Access);

	Modo_Escritor(Client_EP,Server_EP,Nickname,Buffer'Access);

	LLU.Finalize;

	----------------------------------------------------------------------------
	exception
	when Usage_Error =>
	Ada.Text_IO.Put_Line("Usage:  ./client  <Maquina>  <Puerto>  <Nickname> ");
	LLU.Finalize;
	when Ex:others =>
	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
	Ada.Exceptions.Exception_Name(Ex) & " en: " &
	Ada.Exceptions.Exception_Message(Ex));
	LLU.Finalize;

end chat_client_2;
