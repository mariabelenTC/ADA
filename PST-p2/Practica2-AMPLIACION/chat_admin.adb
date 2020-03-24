with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Exceptions;
with Lower_Layer_UDP;
with Chat_Messages;
with Client_Collections;


procedure Chat_Admin is

	package LLU renames Lower_Layer_UDP;
    package ASU renames Ada.Strings.Unbounded;
	package CC renames Client_Collections;
	package CM renames Chat_Messages;
	package ACL renames Ada.Command_Line;

	use type ASU.Unbounded_String;
	use type CM.Message_Type;
	use type CC.Collection_Type;

	Usage_Error: exception;
	End_Program: exception;
	Option: Integer;
	Server_Port: Integer;
	Expired: Boolean;
	Server_Hostname: ASU.Unbounded_String;
	Admin_Password: ASU.Unbounded_String;
	Data: ASU.Unbounded_String;
	Nick_To_Ban: ASU.Unbounded_String;
	Admin_EP: LLU.End_Point_Type;
	Server_EP: LLU.End_Point_Type;
	Mess_Type: CM.Message_Type;
	Buffer:    aliased LLU.Buffer_Type(1024);

	procedure Interactive_Menu is
	
	begin
		Ada.Text_IO.Put_Line("Options");
		Ada.Text_IO.Put_Line("1 Show writers collection");	
		Ada.Text_IO.Put_Line("2 Ban writer");	
		Ada.Text_IO.Put_Line("3 Shutdown server");
		Ada.Text_IO.Put_Line("4 Quit");
	end Interactive_Menu;

begin
	if ACL.Argument_Count /= 3 then
		raise Usage_Error;
	end if;

	Server_Hostname:= ASU.To_Unbounded_String(ACL.Argument(1));
	Server_Port:= Integer'Value(ACL.Argument(2));
	Admin_Password:= ASU.To_Unbounded_String(ACL.Argument(3));

	Server_EP := LLU.Build(LLU.To_IP(ASU.To_String(Server_Hostname)), Server_Port);
	LLU.Bind_Any(Admin_EP);

	loop
		Interactive_Menu;
		Ada.Text_IO.Put("Your option? ");
		Option:= Integer'Value(Ada.Text_IO.Get_Line);
		case Option is
			when 1 =>
				LLU.Reset (Buffer);
				CM.Message_Type'Output(Buffer'Access, CM.Collection_Request);
				LLU.End_Point_Type'Output(Buffer'Access, Admin_EP);
				ASU.Unbounded_String'Output(Buffer'Access, Admin_Password);
				LLU.Send(Server_EP, Buffer'Access);
				LLU.Reset (Buffer);
				LLU.Receive (Admin_EP, Buffer'Access, 5.0, Expired);
				if not Expired then
					Mess_Type:= CM.Message_Type'Input(Buffer'Access);
					Data:= ASU.Unbounded_String'Input(Buffer'Access);
					LLU.Reset (Buffer);
					Ada.Text_IO.Put_Line(ASU.To_String(Data));
				else
					Ada.Text_IO.Put_Line("Time expired");
				end if;
			when 2 =>
				LLU.Reset (Buffer);
				Ada.Text_IO.Put("Nick to ban? ");
				Nick_To_Ban:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
				CM.Message_Type'Output(Buffer'Access, CM.Ban);
				ASU.Unbounded_String'Output(Buffer'Access, Admin_Password);
				ASU.Unbounded_String'Output(Buffer'Access, Nick_To_Ban);
				LLU.Send(Server_EP, Buffer'Access);
				LLU.Reset (Buffer);
			when 3 =>
				LLU.Reset (Buffer);
				CM.Message_Type'Output(Buffer'Access, CM.Shutdown);
				ASU.Unbounded_String'Output(Buffer'Access, Admin_Password);
				LLU.Send(Server_EP, Buffer'Access);
				LLU.Reset (Buffer);
				Ada.Text_IO.Put_Line("Server shutdown sent");
			when 4 =>
				raise End_Program;
			when others =>
				Ada.Text_IO.Put_Line("There has been an error");
		end case;
	end loop;
exception
	when Usage_Error => 
		Ada.Text_IO.Put_Line("USAGE ERROR: Put three arguments (server hostname, server port and admin password)");
	    LLU.Finalize;
	
	when End_Program => 
	    LLU.Finalize;

    when Ex:others =>
    	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
      LLU.Finalize;
end Chat_Admin;
