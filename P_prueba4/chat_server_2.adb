with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Handlers;
with Maps_G;
with Ada.Calendar;
with Protocolo_Perdidas;

procedure chat_server_2 is

	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package H renames Handlers;
	package CM renames Chat_Messages;
	Package PP renames Protocolo_Perdidas;

	use type CM.Message_Type;
	use type ASU.Unbounded_String;

	Usage_Error:exception;
	Max_Clients_Error:exception;
	Fault_pct_Error:exception;
	Max_delay_Error:exception;
--____________________________________________________________________________--

	procedure comprobar_comandos(puerto,Max_Clients,min_delay,max_delay,fault_pct:out Natural) is
	begin
		if ACL.Argument_Count = 5 then
			puerto:=Natural'Value(ACL.Argument(1));
			Max_Clients:=Natural'Value(ACL.Argument(2));
			if(Max_Clients < 2 or Max_Clients > 50) then
				raise Max_Clients_Error;
			end if;
			min_delay:=Natural'Value(ACL.Argument(3));
			max_delay:=Natural'Value(ACL.Argument(4));
			if (max_delay < min_delay) then
				raise Max_delay_Error;
			end if;
			fault_pct:=Natural'Value(ACL.Argument(5));
			if (fault_pct< 0 or fault_pct > 100) then
				raise Fault_pct_Error;
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

	Puerto,Max_Clients_Activos,Min_delay,Max_delay,Fault_pct:Natural;
	Plazo_Retrasmision:Duration;
	C:Character;
	Max_R:Natural

begin
	comprobar_comandos(Puerto,Max_Clients_Activos,Min_delay,Max_delay,Fault_pct);
	PP.Provocar_Perdida_Mess(Max_delay,Fault_pct);

	Crear_EP(H.Server_EP_Handler,Puerto);

	LLU.Bind(H.Server_EP_Handler,H.Server_Handler'Access);

	ATIO.New_Line;
	ATIO.Put_Line("========Servidor Lanzado========");

	loop
		ATIO.Get_Immediate(C);
		if C = 'l' or C ='L' then
			H.Print_Map(ASU.To_Unbounded_String("Lista Clientes Activos"));
		elsif C = 'o' or C= 'O' then
			H.Print_Map(ASU.To_Unbounded_String("Lista Clientes Inactivos"));
		else
			ATIO.Put_Line ("Para terminar este proceso pulse [ctrl + C]");
		end if;
	end loop;
--------------------------------------------------------------------------------
	exception
	when Usage_Error =>
		ATIO.Put_Line("Usage:  ./server  <Puerto> <Numero de clientes> <min_delay> <max_delay> <fault_pct>");
		LLU.Finalize;
	when Max_Clients_Error =>
		ATIO.Put_Line("El numero de clientes debe ser entre 2 y 50");
		LLU.Finalize;
	when Max_delay_Error=>
		ATIO.Put_Line("El retardo maximo debe ser mayor o igual al retardo minimo");
		LLU.Finalize;
	when Fault_pct_Error=>
		ATIO.Put_Line("el procentaje de error debe ser entre 0 y 100");
		LLU.Finalize;
	when Ex:others =>
		ATIO.Put_Line ("Excepción imprevista: " &
							Ada.Exceptions.Exception_Name(Ex) & " en: " &
							Ada.Exceptions.Exception_Message(Ex));
		LLU.Finalize;

end chat_server_2;
