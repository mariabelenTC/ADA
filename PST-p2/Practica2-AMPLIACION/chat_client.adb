with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;

procedure Chat_Client is
    package LLU renames Lower_Layer_UDP;
    package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;
	package ACL renames Ada.Command_Line;

	use type ASU.Unbounded_String;
	use type CM.Message_Type;

    Server_EP: LLU.End_Point_Type;
    Client_EP: LLU.End_Point_Type;
	Writer_EP: LLU.End_Point_Type;
    Buffer: aliased LLU.Buffer_Type(1024);
    Request: ASU.Unbounded_String;
    Text: ASU.Unbounded_String;
	Comment: ASU.Unbounded_String;
    Expired : Boolean;
	Server_Hostname: ASU.Unbounded_String;
	Server_Port: Integer;
	Client_Nickname: ASU.Unbounded_String;
	Usage_Error: exception;
	End_Program: Exception;
	Mess_Type: CM.Message_Type;
	Nick: ASU.Unbounded_String;
	Encontrado, Fin: Boolean:= False;

	procedure Mandar_Init(Server_EP: in LLU.End_Point_Type; 
						  Client_EP: in LLU.End_Point_Type;
						  Client_Nickname: in ASU.Unbounded_String) is

	begin
		-- reinicializa el buffer para empezar a utilizarlo
		LLU.Reset(Buffer);

    	CM.Message_Type'Output(Buffer'Access, CM.Init);
		LLU.End_Point_Type'Output(Buffer'Access, Client_EP);
		ASU.Unbounded_String'Output(Buffer'Access, Client_Nickname);

		-- envía el contenido del Buffer
		LLU.Send(Server_EP, Buffer'Access);

	end Mandar_Init;	
	
begin
	if ACL.Argument_Count /= 3 then
		raise Usage_Error;
	end if;	

	Server_Hostname:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(1));
	Server_Port:= Integer'Value(Ada.Command_Line.Argument(2));
	Client_Nickname:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(3));

   -- Construye el End_Point en el que está atado el servidor
	Server_EP := LLU.Build(LLU.To_IP(ASU.To_String(Server_Hostname)), Server_Port);
   -- Construye un End_Point libre cualquiera y se ata a él

	LLU.Bind_Any(Client_EP);

	Mandar_Init(Server_EP, Client_EP, Client_Nickname);

	if Client_Nickname = ASU.To_Unbounded_String("reader") then	
	--Si es un reader
		loop
			-- reinicializa (vacía) el buffer para ahora recibir en él
			LLU.Reset(Buffer);
			LLU.Receive(Client_EP, Buffer'Access, 1000.0, Expired);
			if Expired then
				Ada.Text_IO.Put_Line ("Plazo expirado");
			else
				Mess_Type:= CM.Message_Type'Input(Buffer'Access);
				Writer_EP:= LLU.End_Point_Type'Input(Buffer'Access);
				Comment:= ASU.Unbounded_String'Input(Buffer'Access);
				Ada.Text_IO.Put_Line(ASU.To_String(Comment));
			end if;
		end loop;
	else 
	--Si es un writer
		loop
			LLU.Reset(Buffer);
			Ada.Text_IO.Put("Message: ");
			Comment:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
			Text:= Client_Nickname & ": " & Comment;
			
			if Comment = (ASU.To_Unbounded_String(".quit")) then
				Fin:= True;
			else
				CM.Message_Type'Output(Buffer'Access, CM.Writer);
 		  		LLU.End_Point_Type'Output(Buffer'Access, Client_EP);
				ASU.Unbounded_String'Output(Buffer'Access, Text);
				LLU.Send(Server_EP, Buffer'Access);

			end if;
			exit when Fin;
		end loop;
	end if;
	
   -- termina Lower_Layer_UDP
   LLU.Finalize;

exception
	when Usage_Error => 
		Ada.Text_IO.Put_Line("USAGE ERROR: Put three arguments (server hostname, server port and client nickname)");
		LLU.Finalize;
	when End_Program =>
		LLU.Finalize;	

    when Ex:others =>
        Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
        LLU.Finalize;

end Chat_Client;
