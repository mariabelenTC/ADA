with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Handlers;
with Ada.Calendar;

procedure Chat_Client_2 is

    package LLU renames Lower_Layer_UDP;
    package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package CM renames Chat_Messages;

	use type ASU.Unbounded_String;
	use type CM.Message_Type;

	type Tipo_Datos is record
		EP: LLU.End_Point_Type;
		Time: Ada.Calendar.Time;
	end record;

	Server_Port: Natural;
	Client_Handler_Port: Natural;
	Expired: Boolean;
	Acogido: Boolean;
	Server_IP: ASU.Unbounded_String;
	Client_IP: ASU.Unbounded_String;
	Server_Hostname: ASU.Unbounded_String;
	Client_Nickname: ASU.Unbounded_String;
	Comentario: ASU.Unbounded_String;
	Server_EP: LLU.End_Point_Type;
	Client_EP_Receive: LLU.End_Point_Type;
	Client_EP_Handler: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
	Mess_Type: CM.Message_Type;
	Usage_Error: exception;
	Shutdown: exception;

	Datos_Client_Handler: Tipo_Datos;

	procedure Mandar_Init(Server_EP: in LLU.End_Point_Type; 
						  Client_EP_Receive: in LLU.End_Point_Type;
						  Datos_Client_Handler: in Tipo_Datos;
						  Client_Nickname: in ASU.Unbounded_String) is

	begin
		LLU.Reset(Buffer);

    	CM.Message_Type'Output(Buffer'Access, CM.Init);
		LLU.End_Point_Type'Output(Buffer'Access, Client_EP_Receive);
		LLU.End_Point_Type'Output(Buffer'Access, Datos_Client_Handler.EP);
		ASU.Unbounded_String'Output(Buffer'Access, Client_Nickname);

		LLU.Send(Server_EP, Buffer'Access);
		LLU.Reset(Buffer);

	end Mandar_Init;

begin
	if ACL.Argument_Count /= 3 then
		raise Usage_Error;
	end if;

	Server_Hostname:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(1));
	Server_Port:= Natural'Value(Ada.Command_Line.Argument(2));
	Client_Nickname:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(3));

	Server_IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Server_Hostname)));
    Server_EP:= LLU.Build (ASU.To_String(Server_IP), Server_Port);
    LLU.Bind_Any(Client_EP_Receive);
	LLU.Bind_Any(Client_EP_Handler, Handlers.Client_Handler'Access);
	Datos_Client_Handler.EP:= Client_EP_Handler;
	Datos_Client_Handler.Time:= Ada.Calendar.Clock;
	Mandar_Init(Server_EP, Client_EP_Receive, Datos_Client_Handler, Client_Nickname);
	LLU.Reset(Buffer);
	LLU.Receive (Client_EP_Receive, Buffer'Access, 5.0, Expired);
	if Expired then
		Ada.Text_IO.Put_Line ("Server unreacheable");
	else
		Mess_Type:= CM.Message_Type'Input(Buffer'Access);
		Acogido:= Boolean'Input(Buffer'Access);
		if(Mess_Type = CM.Welcome and Acogido) then
			Ada.Text_IO.Put_Line("Mini-Chat v2.0: Welcome " & ASU.To_String(Client_Nickname));
			while True loop
				Ada.Text_IO.Put(">> ");
				Comentario:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
				LLU.Reset(Buffer);

				if(Comentario /= ASU.To_Unbounded_String(".quit")) then
					CM.Message_Type'Output(Buffer'Access, CM.Writer);
					LLU.End_Point_Type'Output(Buffer'Access, Client_EP_Handler);
					ASU.Unbounded_String'Output(Buffer'Access, Client_Nickname);
					ASU.Unbounded_String'Output(Buffer'Access, Comentario);
					LLU.Send(Server_EP, Buffer'Access);
					LLU.Reset(Buffer);
				else
					CM.Message_Type'Output(Buffer'Access, CM.Logout);
					LLU.End_Point_Type'Output(Buffer'Access, Client_EP_Handler);
					ASU.Unbounded_String'Output(Buffer'Access, Client_Nickname);
					LLU.Send(Server_EP, Buffer'Access);
					LLU.Reset(Buffer);
					raise Shutdown;
				end if;
				
			end loop;
		elsif (Mess_Type = CM.Welcome and Acogido = False) then
			raise Shutdown;
		else
			Ada.Text_IO.Put_Line("HA HABIDO UN ERROR RARO");
			raise Shutdown;
		end if;
	end if;

exception
	when Usage_Error => 
		Ada.Text_IO.Put_Line("USAGE ERROR: Put three arguments (server hostname, server port and client nickname)");
	    LLU.Finalize;

	when Shutdown =>
		LLU.Finalize;

    when Ex:others =>
    	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
      LLU.Finalize;

end Chat_Client_2;
