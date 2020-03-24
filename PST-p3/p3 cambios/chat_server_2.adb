with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with handlers;
with Maps_G;
with Ada.Calendar;

procedure chat_server_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	use type CM.Message_Type;
	use type ASU.Unbounded_String;
	Usage_Error:exception;
	Max_Clients_Error:exception;
--____________________________________________________________________________--
	procedure comprobar_comandos(puerto,Max_Clients:out Natural) is
	begin
		if ACL.Argument_Count = 2 then
			puerto:=Natural'Value(ACL.Argument(1));
			Max_Clients:=Natural'Value(ACL.Argument(2));
			if(Max_Clients < 2 or Max_Clients > 50) then
				raise Max_Clients_Error;
			end if;
		else
			raise Usage_Error;
		end if;
	end comprobar_comandos;
--____________________________________________________________________________--
	procedure Crear_EP(Server_EP: out LLU.End_Point_Type; Puerto:Natural) is
		Maquina:ASU.Unbounded_String;
		Dir_IP:ASU.Unbounded_String;
	begin
		Maquina:=ASU.To_Unbounded_String(LLU.Get_Host_Name);
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build(ASU.To_String(Dir_IP) ,Puerto);
	end Crear_EP;
--____________________________________________________________________________--
	Puerto,Max_Clients_Activos:Natural;
	Server_EP: LLU.End_Point_Type;
	C:Character;

begin
	comprobar_comandos(Puerto,Max_Clients_Activos);
	Crear_EP(Server_EP,Puerto);
	LLU.Bind(Server_EP,Handlers.Server_Handler'Access);

	ATIO.New_Line;
	ATIO.Put_Line("========Servidor Lanzado========");

	loop
		ATIO.Get_Immediate(C);
		if C = 'l' or C ='L' then
			Handlers.Print_Map(ASU.To_Unbounded_String("Lista Clientes Activos"));
		elsif C = 'o' or C= 'O' then
			Handlers.Print_Map(ASU.To_Unbounded_String("Lista Clientes Inactivos"));
		else
			ATIO.Put_Line ("Para terminar este proceso pulse [ctrl + C]");
		end if;
	end loop;
--------------------------------------------------------------------------------
	exception
	when Usage_Error =>
		ATIO.Put_Line("Usage:  ./server  <Puerto> <Numero de clientes>");
		LLU.Finalize;
	when Max_Clients_Error =>
		ATIO.Put_Line("El numero de clientes debe ser entre 2 y 50");
		LLU.Finalize;
	when Ex:others =>
		ATIO.Put_Line ("Excepción imprevista: " &
							Ada.Exceptions.Exception_Name(Ex) & " en: " &
							Ada.Exceptions.Exception_Message(Ex));
		LLU.Finalize;
end chat_server_2;
