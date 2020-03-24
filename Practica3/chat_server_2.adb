with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Handlers;
with Maps_G;
with Ada.Calendar;

procedure Chat_Server_2 is

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
	Server_IP: ASU.Unbounded_String;
	Max_Clients: Natural;
	C: Character;
	Server_EP: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
	Usage_Error: exception;
	Shutdown: exception;
	List_Too_Big_Error: exception;

	Key: ASU.Unbounded_String;
	Value: ASU.Unbounded_String;
	Success: Boolean;

	Finish: Boolean;

begin

	if ACL.Argument_Count /= 2 then
		raise Usage_Error;
	end if;

	Server_Port:= Natural'Value(Ada.Command_Line.Argument(1));
	Max_Clients:= Natural'Value(Ada.Command_Line.Argument(2));
	if(Max_Clients < 2 or Max_Clients > 50) then
		raise List_Too_Big_Error;
	end if;
	Server_IP:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP := LLU.Build (ASU.To_String(Server_IP), Server_Port);
    LLU.Bind(Server_EP, Handlers.Server_Handler'Access);

	Finish := False;
	while(not Finish) loop
		Ada.Text_IO.Get_Immediate (C);
		if(C = 'L' or C = 'l') then
			Ada.Text_IO.Put_Line("ACTIVE CLIENTS");
			Ada.Text_IO.Put_Line("==============");
			Handlers.Mostrar_Mapa(ASU.To_Unbounded_String("actual"));
		elsif(C = 'O' or C  = 'o' ) then
			Ada.Text_IO.Put_Line("OLD CLIENTS");
			Ada.Text_IO.Put_Line("==============");
			Handlers.Mostrar_Mapa(ASU.To_Unbounded_String("viejo"));
		else
         Ada.Text_IO.Put_Line ("Para terminar este proceso pulse [ctrl + C]");
      end if;
   end loop;




exception
	when Usage_Error =>
		Ada.Text_IO.Put_Line("USAGE ERROR: Put two arguments (server port and maximum number of clients)");
	    LLU.Finalize;

	when Shutdown =>
		LLU.Finalize;

	when List_Too_Big_Error =>
		Ada.Text_IO.Put_Line("List's size is too big. List's size must be a value between 2 and 50");
		LLU.Finalize;

    when Ex:others =>
    	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex));
      LLU.Finalize;

end Chat_Server_2;
