with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Client_Collections;

procedure Chat_Server is
    package LLU renames Lower_Layer_UDP;
    package ASU renames Ada.Strings.Unbounded;
	package CC renames Client_Collections;
	package CM renames Chat_Messages;
	package ACL renames Ada.Command_Line;

	use type ASU.Unbounded_String;
	use type CM.Message_Type;
	use type CC.Collection_Type;

    Server_EP: LLU.End_Point_Type;
    Client_EP: LLU.End_Point_Type;
	Admin_EP: LLU.End_Point_Type;
    Buffer:    aliased LLU.Buffer_Type(1024);
    Request: ASU.Unbounded_String;
	Nickname: ASU.Unbounded_String;
	Actual_Nickname: ASU.Unbounded_String;
	Mess_Type: CM.Message_Type;
    Expired : Boolean;
	Server_Port: Integer;
	Server_IP: ASU.Unbounded_String;
	Nick_To_Ban: ASU.Unbounded_String;
	Password_Suggested: ASU.Unbounded_String;
	Data: ASU.Unbounded_String;
	Admin_Password: ASU.Unbounded_String;

	Usage_Error: exception;
	Shutdown: exception;
	Nick_Not_Found: exception;
	Incorrect_Password_Collection: exception;

	Writers_List: CC.Collection_Type;
	Readers_List: CC.Collection_Type;
	Text: ASU.Unbounded_String;

	function Nickname_Repeated(Collection: in CC.Collection_Type; Nickname: in ASU.Unbounded_String) return Boolean is
		Repeated: Boolean;
		Pos: Natural;
	begin
		Repeated:= False;
		Pos:= 0;
		Pos:= ASU.Index(ASU.To_Unbounded_String(CC.Collection_Image(Collection)), ASU.To_String(Nickname));
		if Pos /= 0 then
			Repeated:= True;
		end if;
		return Repeated;
	end Nickname_Repeated;

begin
	if ACL.Argument_Count /= 2 then
		raise Usage_Error;
	end if;

	Server_Port:= Integer'Value(Ada.Command_Line.Argument(1));
	--6123
	Admin_Password:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(2));
	Server_IP:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
	--Server_IP:= ASU.To_Unbounded_String("127.0.0.1");
    Server_EP := LLU.Build (ASU.To_String(Server_IP), Server_Port);
    LLU.Bind(Server_EP);

   -- bucle infinito
	loop
		LLU.Reset(Buffer);

      -- espera 1000.0 segundos a recibir algo dirigido al Server_EP
      --   . si llega antes, los datos recibidos van al Buffer
      --     y Expired queda a False
      --   . si pasados los 1000.0 segundos no ha llegado nada, se abandona
      --     la espera y Expired queda a True
		LLU.Receive (Server_EP, Buffer'Access, 1000.0, Expired);

     	if Expired then
			Ada.Text_IO.Put_Line ("Plazo expirado, vuelvo a intentarlo");
		else
         -- saca
		
			Mess_Type:= CM.Message_Type'Input(Buffer'Access);

			if Mess_Type = CM.Init then
				Client_EP := LLU.End_Point_Type'Input (Buffer'Access);
      			Nickname := ASU.Unbounded_String'Input (Buffer'Access);
				LLU.Reset (Buffer);

				if Nickname = ASU.To_Unbounded_String("reader") then
					Ada.Text_IO.Put_Line(CM.Message_Type'Image(Mess_Type) & " received from " & ASU.To_String(Nickname));
					CC.Add_Client(Readers_List, Client_EP, Nickname, True);
				else
					begin
					if Nickname_Repeated(Writers_List, Nickname) then
						raise CC.Client_Collection_Error;
					end if;
					Ada.Text_IO.Put_Line(CM.Message_Type'Image(Mess_Type) & " received from " & ASU.To_String(Nickname));
					CC.Add_Client(Writers_List, Client_EP, Nickname, True);
					Text:= ASU.To_Unbounded_String("server: " & ASU.To_String(Nickname) & " joins the chat");
					CM.Message_Type'Output(Buffer'Access, CM.Server);
					LLU.End_Point_Type'Output(Buffer'Access, Client_EP);
					ASU.Unbounded_String'Output(Buffer'Access, Text);
					CC.Send_To_All(Readers_List, Buffer'Access);

					exception
						when CC.Client_Collection_Error =>
							Ada.Text_IO.Put_Line("INIT received from " & ASU.To_String(Nickname) 
												 & ". IGNORED, nick already used");
						when Ex:others =>
							 Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
					end;
				end if;
			elsif Mess_Type = CM.Writer then
				begin
					Client_EP := LLU.End_Point_Type'Input (Buffer'Access);
					Text:= ASU.Unbounded_String'Input(Buffer'Access);
					Actual_Nickname:= CC.Search_Client(Writers_List, Client_EP);
					if Actual_Nickname = ASU.To_Unbounded_String("") then
						raise CC.Client_Collection_Error;
					end if;
						Ada.Text_IO.Put_Line(CM.Message_Type'Image(Mess_Type) & " received from " & ASU.To_String(Text));
						LLU.Reset (Buffer);
	
						CM.Message_Type'Output(Buffer'Access, CM.Server);
						LLU.End_Point_Type'Output(Buffer'Access, Client_EP);
						ASU.Unbounded_String'Output(Buffer'Access, Text);
						CC.Send_To_All(Readers_List, Buffer'Access);
				
				exception
					when CC.Client_Collection_Error =>
						Ada.Text_IO.Put_Line("WRITER received from unknown client. IGNORED");
					when Ex:others =>
						Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                   	 Ada.Exceptions.Exception_Name(Ex) & " en: " &
                   	 Ada.Exceptions.Exception_Message(Ex));
				end;
			elsif Mess_Type = CM.Collection_Request then
				Admin_EP:= LLU.End_Point_Type'Input (Buffer'Access);
				Password_Suggested:= ASU.Unbounded_String'Input(Buffer'Access);
				LLU.Reset (Buffer);

				begin
					if Password_Suggested /= Admin_Password then
						raise Incorrect_Password_Collection;
					end if;
					Data:= ASU.To_Unbounded_String(CC.Collection_Image(Writers_List));
					
					CM.Message_Type'Output(Buffer'Access, CM.Collection_Data);
					ASU.Unbounded_String'Output(Buffer'Access, Data);
					LLU.Send(Admin_EP, Buffer'Access);
					LLU.Reset (Buffer);
				exception
					when Incorrect_Password_Collection =>
						Ada.Text_IO.Put_Line("LIST_REQUEST received. IGNORED, incorrect password");
				end;
			elsif Mess_Type = CM.Shutdown then
				Password_Suggested:= ASU.Unbounded_String'Input(Buffer'Access);
				LLU.Reset (Buffer);
				begin
					if Password_Suggested /= Admin_Password then
						raise Incorrect_Password_Collection;
					end if;
					raise Shutdown;
				exception
					when Incorrect_Password_Collection =>
						Ada.Text_IO.Put_Line("SHUTDOWN received. IGNORED, incorrect password");
				end;
			else 
				Password_Suggested:= ASU.Unbounded_String'Input(Buffer'Access);
				begin
					if Password_Suggested /= Admin_Password then
						raise Incorrect_Password_Collection;
					end if;
					Nick_To_Ban:= ASU.Unbounded_String'Input(Buffer'Access);
					LLU.Reset (Buffer);
					if not Nickname_Repeated(Writers_List, Nick_To_Ban) then
						raise Nick_Not_Found;
					end if;
					CC.Delete_Client(Writers_List, Nick_To_Ban);
				exception
					when Incorrect_Password_Collection =>
						Ada.Text_IO.Put_Line("BAN received. IGNORED, incorrect password");	
					when Nick_Not_Found =>
						Ada.Text_IO.Put_Line("BAN received. IGNORED, nick not found");
				end;
			end if;
		end if;
	end loop;

   -- nunca se alcanza este punto
   -- si se alcanzara, habría que llamar a LLU.Finalize;

exception
	when Usage_Error => 
		Ada.Text_IO.Put_Line("USAGE ERROR: Put two arguments (port number and admin password)");
	    LLU.Finalize;

	when Shutdown =>
		LLU.Finalize;
    when Ex:others =>
    	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
      LLU.Finalize;

end Chat_Server;
