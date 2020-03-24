with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;

with Client_Collections;
with Handlers;
procedure chat_server_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;

	package CC renames Client_Collections;


	Usage_Error:exception;

---------------------------------------------------------------------------------------
	procedure Check_Command(Port:out Natural;Password_Server: out ASU.Unbounded_String) is
	begin
		if ACL.Argument_Count = 2 then
			Port:=Natural'Value(ACL.Argument(1));
			Password_Server:=ASU.To_Unbounded_String(ACL.Argument(2));
		else
			raise Usage_Error;
		end if;
	end Check_Command;
--------------------------------------------------------------------------------------
	procedure Build_EP(Server_EP: out LLU.End_Point_Type; Puerto:Natural) is
		Maquina:ASU.Unbounded_String;
		Dir_IP:ASU.Unbounded_String;
	begin
		Maquina:=ASU.To_Unbounded_String(LLU.Get_Host_Name);
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build(ASU.To_String(Dir_IP) ,Puerto);
	end Build_EP;
-------------------------------------------------------------------------------------
	--procedure Build_Message_Welcome(P_Buffer: access LLU.Buffer_Type; Nickname: ASU.Unbounded_String; Aceptado:Boolean) is
	--begin
	--	LLU.Reset(P_Buffer.all);
	--	CM.Message_Type'Output(P_Buffer,CM.Welcome);
	--	ASU.Unbounded_String'Output(P_Buffer,Nickname);
	--	Boolean'Output(P_Buffer,Aceptado);
	--end Build_Message_Welcome;

-------------------------------------------------------------------------------------
	Puerto:Natural;
	Password_Server:ASU.Unbounded_String;
	Server_EP: LLU.End_Point_Type;
	C:Character;


begin
	Check_Command(Puerto,Password_Server);
	Build_EP(Server_EP,Puerto);
 loop
	LLU.Bind(Server_EP,Handlers.Server_Handler'Access);	-- se ata al End_Point para poder recibir en él

	C:=ATIO.Get_Immediate;
	if C = 'l' or C ='L' then
		ATIO.Put_Line("ACTIVE CLIENTS");
		ATIO.Put_Line("==============");

	elsif C = 'o'' or C= 'O' then
		ATIO.Put_Line("OLD CLIENTS");
		ATIO.Put_Line("===========");
	else
		ATIO.Put_Line ("Para terminar este proceso pulse [ctrl + C]");
	end if;

end loop;
	exception
	when Usage_Error =>
		Ada.Text_IO.Put_Line("Usage:  ./server  <Puerto> < Password>");
		LLU.Finalize;

	when Ex:others =>
		Ada.Text_IO.Put_Line ("Excepción imprevista: " &
	                        Ada.Exceptions.Exception_Name(Ex) & " en: " &
	                        Ada.Exceptions.Exception_Message(Ex));

		LLU.Finalize;


end chat_server_2;
