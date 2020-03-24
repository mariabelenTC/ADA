with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Client_Collections;
with handlers;
procedure chat_server_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CC renames Client_Collections;

	use type CM.Message_Type;
	use type ASU.Unbounded_String;
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
--------------------------------------------------------------------------------------
	Puerto:Natural;
	Server_EP: LLU.End_Point_Type;
	C:Character;

begin
	comprobar_comandos(Puerto);
	Crear_EP(Server_EP,Puerto);

	LLU.Bind(Server_EP,handlers.Server_Handler'Access);	-- se ata al End_Point para poder recibir en él

	ATIO.New_Line;
	ATIO.Put_Line("========Servidor Lanzado========");

	loop

		ATIO.Get_Immediate(C);
		if C = 'l' or C ='L' then
			ATIO.Put_Line("ACTIVE CLIENTS");
			ATIO.Put_Line("==============");

		elsif C = 'o' or C= 'O' then
			ATIO.Put_Line("OLD CLIENTS");
			ATIO.Put_Line("===========");
		else
			ATIO.Put_Line ("Para terminar este proceso pulse [ctrl + C]");
		end if;
	end loop;

	exception
	when Usage_Error =>
	  Ada.Text_IO.Put_Line("Usage:  ./server  <Puerto>");
	when Ex:others =>
	  Ada.Text_IO.Put_Line ("Excepción imprevista: " &
	                        Ada.Exceptions.Exception_Name(Ex) & " en: " &
	                        Ada.Exceptions.Exception_Message(Ex));
	  LLU.Finalize;

end chat_server_2;
