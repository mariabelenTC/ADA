with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
procedure Server is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	use type CM.Message_Type;


	Usage_Error:exception;

---------------------------------------------------------------------------------------
	procedure comprobar_comandos(puerto:out Natural) is
	begin
		if ACL.Argument_Count = 1 then
			puerto:=Natural'Value(ACL.Argument(1));
		else
			raise Usage_Error;
		end if;
	end comprobar_comandos;
--------------------------------------------------------------------------------------
	procedure Crear_EP(Server_EP: out LLU.End_Point_Type; Puerto:Natural) is
		Maquina:ASU.Unbounded_String;
		Dir_IP:ASU.Unbounded_String;
	begin
		Maquina:=ASU.To_Unbounded_String(LLU.Get_Host_Name);
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build(ASU.To_String(Dir_IP) ,Puerto);
	end Crear_EP;
-------------------------------------------------------------------------------------
	Procedure Sacar_Tipo_y_Client_EP(P_Buffer: access LLU.Buffer_Type; Tipo_Mess: out CM.Message_Type;
								Client_EP: out LLU.End_Point_Type) is
	begin
		Tipo_Mess:=CM.Message_Type'Input(P_Buffer);
		Client_EP:=LLU.End_Point_Type'Input(P_Buffer);
	end Sacar_Tipo_y_Client_EP;
-------------------------------------------------------------------------------------
	Procedure Build_Menssage_Server(P_Buffer: access LLU.Buffer_Type; Nickname,Message: ASU.Unbounded_String) is
	begin
		CM.Message_Type'Output(P_Buffer,CM.Server);
		ASU.Unbounded_String'Output(P_Buffer,Nickname);
		ASU.Unbounded_String'Output(P_Buffer,Message);
	end Build_Menssage_Server;

-------------------------------------------------------------------------------------
	procedure Evaluar_Nickname(P_Buffer: access LLU.Buffer_Type;Nickname: in out ASU.Unbounded_String) is
		Message:ASU.Unbounded_String;
	begin
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		if ASU.To_String(Nickname)= "reader" then
			ATIO.Put_Line("Init received from reader");
		else
			ATIO.Put_Line("INIT received from " & ASU.To_String(nickname));
			Message:= ASU.To_Unbounded_String(ASU.To_String(Nickname) & " joins the chat");
			Build_Menssage_Server(P_Buffer,ASU.To_Unbounded_String("server"),Message);
		end if;
	end Evaluar_Nickname;
-------------------------------------------------------------------------------------
	procedure Evaluar_Tipo_Mess(P_Buffer: access LLU.Buffer_Type) is
		Tipo_Mess:CM.Message_Type;
		Client_EP: LLU.End_Point_Type;
		Message:ASU.Unbounded_String;
		Nickname:ASU.Unbounded_String;
	begin
		Sacar_Tipo_y_Client_EP(P_Buffer,Tipo_Mess,Client_EP);
		if Tipo_Mess = CM.Init then
			Evaluar_Nickname(P_Buffer,Nickname);
		elsif Tipo_Mess = CM.Writer then
			Message:=ASU.Unbounded_String'Input(P_Buffer);
			ATIO.Put("WRITER received from ");
			ATIO.Put(ASU.To_String(Message) & ": ");
			ATIO.Put_Line(ASU.To_String(Message));
			Build_Menssage_Server(P_Buffer,Nickname,Message);
		elsif Tipo_Mess = CM.Logout then
			ATIO.Put_Line("LOGOUT received from " & ASU.To_String(nickname));
			Nickname:=ASU.To_Unbounded_String("Server: ");
			Build_Menssage_Server(P_Buffer,Nickname,Message);
		end if;
	end Evaluar_Tipo_Mess;
-------------------------------------------------------------------------------------
	procedure Modo_Server(Server_EP:LLU.End_Point_Type; P_Buffer: access LLU.Buffer_Type) is

	Expired:Boolean;
	begin
		ATIO.New_Line;
		ATIO.Put_Line("-- Servidor Lanzado");
		loop
			LLU.Reset(P_Buffer.all);

			LLU.Receive(Server_EP, P_Buffer, 1000.0, Expired);

			if Expired then
				Ada.Text_IO.Put_Line ("Plazo expirado, vuelvo a intentarlo");
			else

ATIO.Put_Line("recibe el mensaje");

				Evaluar_Tipo_Mess(P_Buffer);

ATIO.Put_Line("evalua el si es init o writer");

			end if;
		end loop;

	end Modo_Server;
-------------------------------------------------------------------------------------
	Puerto:Natural;
	Server_EP: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
	begin
	comprobar_comandos(Puerto);
ATIO.Put_Line("comprobar comando funciona");
	Crear_EP(Server_EP,Puerto);
ATIO.Put_Line("Crear Server_EP y atarse funciona");
	-- se ata al End_Point para poder recibir en él
	LLU.Bind(Server_EP);
	-- bucle infinito
	Modo_Server(Server_EP,Buffer'access);
ATIO.Put_Line(" modo server funciona");
	-- nunca se alcanza este punto
	-- si se alcanzara, habría que llamar a LLU.Finalize;
	exception
	when Usage_Error =>
	  Ada.Text_IO.Put_Line("Usage:  ./server  <Puerto>");
	when Ex:others =>
	  Ada.Text_IO.Put_Line ("Excepción imprevista: " &
	                        Ada.Exceptions.Exception_Name(Ex) & " en: " &
	                        Ada.Exceptions.Exception_Message(Ex));
	  LLU.Finalize;

end Server;
