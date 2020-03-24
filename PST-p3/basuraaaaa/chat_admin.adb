with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Exceptions;
with Chat_Messages;
with client_collections;

procedure chat_admin is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CC renames Client_Collections;

	Usage_Error:exception;
	Incorrect_password:exception;
	Quit:exception;
--------------------------------------------------------------------------------
	procedure Check_Command(machine,Password_Admin:out ASU.Unbounded_String;
														port:out Natural) is
	begin
		if ACL.Argument_Count = 3 then
			machine:=ASU.To_Unbounded_String(ACL.Argument(1));
			port:=Natural'Value(ACL.Argument(2));
			Password_Admin:=ASU.To_Unbounded_String(ACL.Argument(3));
		else
			raise Usage_Error;
		end if;
	end Check_Command;
--------------------------------------------------------------------------------
	procedure Crear_EP(Server_EP: out LLU.End_Point_Type;
	 									Machine:ASU.Unbounded_String; Port:Natural) is
		Dir_IP:ASU.Unbounded_String;
	begin
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Machine)));
		Server_EP := LLU.Build (ASU.To_String(Dir_IP) ,Port);
	end Crear_EP;
--------------------------------------------------------------------------------
	procedure Select_Option(option: out Natural) is
	begin
		ATIO.Put_Line("1 Show Writers Collection");
		ATIO.Put_Line("2 Ban writer");
		ATIO.Put_Line("3 Shutdown server");
		ATIO.Put_Line("4 Quit");
		ATIO.Put("Your option? ");
		option:= Natural'Value(ATIO.Get_Line);
	end Select_Option;
--------------------------------------------------------------------------------
	procedure Build_Message_Collection_Request(P_Buffer: access LLU.Buffer_Type;
					Admin_EP: LLU.End_Point_Type; Password:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Collection_Request);
		LLU.End_Point_Type'Output(P_Buffer,Admin_EP);
		ASU.Unbounded_String'Output(P_Buffer,Password);
	end Build_Message_Collection_Request;
--------------------------------------------------------------------------------
	procedure Build_Message_Ban(P_Buffer: access LLU.Buffer_Type;
											Password,Nick:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Ban);
		ASU.Unbounded_String'Output(P_Buffer,Password);
		ASU.Unbounded_String'Output(P_Buffer,Nick);
	end Build_Message_Ban;
--------------------------------------------------------------------------------
	Procedure Build_Message_Shutdown(P_Buffer: access LLU.Buffer_Type;
												Password:ASU.Unbounded_String)is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Shutdown);
		ASU.Unbounded_String'Output(P_Buffer,Password);
	end Build_Message_Shutdown;
--------------------------------------------------------------------------------
	procedure Extract_Message_Server(P_Buffer: access LLU.Buffer_Type;
			Type_Mess:out CM.Message_Type; Data: out ASU.Unbounded_String) is
	begin
		Type_Mess:= CM.Message_Type'Input(P_Buffer);
		Data:= ASU.Unbounded_String'Input(P_Buffer);
		LLU.Reset(P_Buffer.all);
	end Extract_Message_Server;
--------------------------------------------------------------------------------
	procedure Evaluate_Option(option:Natural;Password:ASU.Unbounded_String;
										Server_EP,Admin_EP: LLU.End_Point_Type) is
		Buffer:aliased LLU.Buffer_Type(1024);
		Nick:ASU.Unbounded_String;
		Type_Mess:CM.Message_Type;
		Data: ASU.Unbounded_String;
		Expired:Boolean;
	begin
		case Option is
			when 1 =>
				Build_Message_Collection_Request(Buffer'Access,Admin_EP,Password);
				LLU.Send(Server_EP,Buffer'Access);
				LLU.Reset(Buffer);
				LLU.Receive(Admin_EP, Buffer'Access, 5.0, Expired);
				if  Expired then
					raise Incorrect_password;
				else
					Extract_Message_Server(Buffer'Access,Type_Mess,Data);
					ATIO.Put_Line(ASU.To_String(Data));
				end if;
			when 2 =>
				ATIO.Put("Nick to ban? ");
				Nick:= ASU.To_Unbounded_String(ATIO.Get_Line);
				Build_Message_Ban(Buffer'Access,Password,Nick);
				LLU.Send(Server_EP, Buffer'Access);
			when 3=>
				Build_Message_Shutdown(Buffer'Access,Password);
				LLU.Send(Server_EP, Buffer'Access);
				ATIO.Put_Line("Server shutdown sent");
			when 4=>
				raise Quit;
			when others =>
				ATIO.Put_Line("There has been an error");
		end case;
	end Evaluate_Option;
--------------------------------------------------------------------------------
	Machine:ASU.Unbounded_String;
	Port:Natural;
	Password_Admin:ASU.Unbounded_String;
	Server_EP,Admin_EP: LLU.End_Point_Type;
	Option: Natural;
begin
	Check_Command(Machine,Password_Admin,Port);
	Crear_EP(Server_EP,Machine,Port);
	LLU.Bind_Any(Admin_EP);
	loop
		Select_Option(Option);
		Evaluate_Option(Option,Password_Admin,Server_EP,Admin_EP);
	end Loop;
	LLU.Finalize;
	exception
		When Quit =>
			LLU.Finalize;
		when Incorrect_password=>
			ATIO.Put_Line("Incorrect password");
			LLU.Finalize;
		when Usage_Error =>
			ATIO.Put_Line("Usage:  ./chat_admin  <Maquina>  <Puerto>  <Password> ");
			LLU.Finalize;
end chat_admin;
