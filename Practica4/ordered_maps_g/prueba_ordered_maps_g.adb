with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
--with Chat_Messages;
--with Handlers;
with Ordered_Maps_G;
with Ada.Calendar;
with Comparador_Array;
with Gnat.Calendar.Time_IO;

procedure Prueba_Ordered_Maps_G is

	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
--	package CM renames Chat_Messages;

--	use type CM.Message_Type;
	use type ASU.Unbounded_String;
	use type Ada.Calendar.Time;
	use type LLU.End_Point_Type;


	type Tipo_Datos is record
		EP: LLU.End_Point_Type;
		Time: Ada.Calendar.Time;
	end record;

	package Maps is new Ordered_Maps_G(	Key_Type   => ASU.Unbounded_String,
			                              Value_Type => Tipo_Datos,
													Max        => 2,
													"<"        => Comparador_Array.Menor,
													"="        => ASU."=");

--	package Maps_Old is new Ordered_Maps_G (Key_Type  => ASU.Unbounded_String,
--                               			Value_Type => Ada.Calendar.Time,
--														Max => 150,
--                                			"="        => ASU."=");

--	use type Maps.Element_Type;

	use type Maps.Map;

	Key: ASU.Unbounded_String;
	Value: ASU.Unbounded_String;
	Success: Boolean;

	Clients_Map: Maps.Map;
--	Old_Clients: Maps_Old.Map;

-------------------------------------------------------

	Datos_Server: Tipo_Datos;
	Server_Port: Natural;
	Server_IP: ASU.Unbounded_String;
    Server_EP: LLU.End_Point_Type;
	Datos_Server2: Tipo_Datos;
	Server_Port2: Natural;
	Server_IP2: ASU.Unbounded_String;
    Server_EP2: LLU.End_Point_Type;
	Datos_Server3: Tipo_Datos;
	Server_Port3: Natural;
	Server_IP3: ASU.Unbounded_String;
    Server_EP3: LLU.End_Point_Type;
	Datos_Server4: Tipo_Datos;
	Server_Port4: Natural;
	Server_IP4: ASU.Unbounded_String;
    Server_EP4: LLU.End_Point_Type;
	Datos_Server5: Tipo_Datos;
	Server_Port5: Natural;
	Server_IP5: ASU.Unbounded_String;
    Server_EP5: LLU.End_Point_Type;
	Nick_Para_Buscar: ASU.Unbounded_String;
	Datos_Buscados: Tipo_Datos;
	Datos_Buscados2: Tipo_Datos;
	Datos_Buscados3: Tipo_Datos;
	Datos_Buscados4: Tipo_Datos;
	Datos_Buscados5: Tipo_Datos;


	function Imagen_EP(EP: in LLU.End_Point_Type) return ASU.Unbounded_String is
		Aux, IP, Port: ASU.Unbounded_String;
		Length, IP_Pos, Coma_Pos, Port_Pos: Natural;
	begin
		Length:= ASU.Length(ASU.To_Unbounded_String(LLU.Image(EP)));
		IP_Pos:= ASU.Index(ASU.To_Unbounded_String(LLU.Image(EP)), ":");
		Aux:= ASU.Tail(ASU.To_Unbounded_String(LLU.Image(EP)), Length-(IP_Pos+1));
		Coma_Pos:= ASU.Index(Aux, ",");
		IP:= ASU.Head(Aux, Coma_Pos-1);
		Port_Pos:= ASU.Index(ASU.To_Unbounded_String(LLU.Image(EP)), "Port:  ") + 6;
		Port:= ASU.Tail(ASU.To_Unbounded_String(LLU.Image(EP)), Length-Port_Pos) ;
		return ASU.To_Unbounded_String(ASU.To_String(IP) & ":" & ASU.To_String(Port));

	end Imagen_EP;

	function Time_Image(T: Ada.Calendar.Time) return String is
	begin
		return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
	end Time_Image;


	procedure Mostrar_Mapa is
		C_Actual: Maps.Cursor:= Maps.First(Clients_Map);
		Nick: ASU.Unbounded_String;
		Client_EP: LLU.End_Point_Type;
		Client_Time: Ada.Calendar.Time;
	begin
			while Maps.Has_Element(C_Actual) loop
				Nick:= Maps.Element(C_Actual).Key;
				Client_EP:= Maps.Element(C_Actual).Value.EP;
				Client_Time:= Maps.Element(C_Actual).Value.Time;
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " (" & ASU.To_String(Imagen_EP(Client_EP)) & "): "
									 & Time_Image(Client_Time));
				Maps.Next(C_Actual);
			end loop;
	end Mostrar_Mapa;



begin

	Server_Port:= Natural'Value(Ada.Command_Line.Argument(1));
	Server_IP:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP:= LLU.Build(ASU.To_String(Server_IP), Server_Port);
	Datos_Server.EP:= Server_EP;
	Datos_Server.Time:= Ada.Calendar.Clock;

	Server_Port2:= 2255;
	Server_IP2:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP2:= LLU.Build(ASU.To_String(Server_IP2), Server_Port2);
	Datos_Server2.EP:= Server_EP2;
	Datos_Server2.Time:= Ada.Calendar.Clock;

	Server_Port3:= 3680;
	Server_IP3:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP3:= LLU.Build(ASU.To_String(Server_IP3), Server_Port3);
	Datos_Server3.EP:= Server_EP3;
	Datos_Server3.Time:= Ada.Calendar.Clock;

	Server_Port4:= 4990;
	Server_IP4:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP4:= LLU.Build(ASU.To_String(Server_IP4), Server_Port4);
	Datos_Server4.EP:= Server_EP4;
	Datos_Server4.Time:= Ada.Calendar.Clock;

	Server_Port5:= 5730;
	Server_IP5:= ASU.To_Unbounded_String(LLU.To_IP(LLU.Get_Host_Name));
    Server_EP5:= LLU.Build(ASU.To_String(Server_IP5), Server_Port5);
	Datos_Server5.EP:= Server_EP5;
	Datos_Server5.Time:= Ada.Calendar.Clock;

-- Aquí empiezan las pruebas --

-- Un par de puts y gets
---------
	Maps.Put(Clients_Map, ASU.To_Unbounded_String("caracola"), Datos_Server);
	Maps.Put(Clients_Map, ASU.To_Unbounded_String("aconcha"), Datos_Server2);
	Maps.Put(Clients_Map, ASU.To_Unbounded_String("almeja"), Datos_Server3);
	Maps.Put(Clients_Map, ASU.To_Unbounded_String("mejillon"), Datos_Server4);
	Maps.Put(Clients_Map, ASU.To_Unbounded_String("dalamar"), Datos_Server5);


	Ada.Text_IO.Put_Line(Natural'Image(Maps.Map_Length(Clients_Map)));


	Nick_Para_Buscar:= ASU.To_Unbounded_String("caracola");
	Maps.Get(Clients_Map, Nick_Para_Buscar, Datos_Buscados, Success);
	if(Success) then
		Ada.Text_IO.Put_Line(LLU.Image(Datos_Buscados.EP));
	end if;

	Nick_Para_Buscar:= ASU.To_Unbounded_String("aconcha");
	Maps.Get(Clients_Map, Nick_Para_Buscar, Datos_Buscados2, Success);
	if(Success) then
		Ada.Text_IO.Put_Line(LLU.Image(Datos_Buscados2.EP));
	end if;

	Nick_Para_Buscar:= ASU.To_Unbounded_String("almeja");
	Maps.Get(Clients_Map, Nick_Para_Buscar, Datos_Buscados3, Success);
	if(Success) then
		Ada.Text_IO.Put_Line(LLU.Image(Datos_Buscados3.EP));
	end if;

	Nick_Para_Buscar:= ASU.To_Unbounded_String("mejillon");
	Maps.Get(Clients_Map, Nick_Para_Buscar, Datos_Buscados4, Success);
	if(Success) then
		Ada.Text_IO.Put_Line(LLU.Image(Datos_Buscados4.EP));
	end if;

	Nick_Para_Buscar:= ASU.To_Unbounded_String("dalamar");
	Maps.Get(Clients_Map, Nick_Para_Buscar, Datos_Buscados5, Success);
	if(Success) then
		Ada.Text_IO.Put_Line(LLU.Image(Datos_Buscados5.EP));
	end if;

-- Un delete

	Maps.Delete(Clients_Map, ASU.To_Unbounded_String("aconcha"), Success);
	if(Success) then
		Ada.Text_IO.Put_Line("Se ha borrado: " & LLU.Image(Datos_Buscados2.EP));
	end if;


--	Maps.Get(Clients_Map, ASU.To_Unbounded_String("aconcha"), Datos_Buscados, Success);
--	if(Success) then
--		Ada.Text_IO.Put_Line("El key que buscas es este: " & LLU.Image(Datos_Buscados2.EP));
--	else
--		Ada.Text_IO.Put_Line("El key que buscas no está en el mapa");
--	end if;


	Maps.Get(Clients_Map, ASU.To_Unbounded_String("dalamar"), Datos_Buscados5, Success);
	if(Success) then
		Ada.Text_IO.Put_Line("El key que buscas es este: " & LLU.Image(Datos_Buscados5.EP));
	else
		Ada.Text_IO.Put_Line("El key que buscas no está en el mapa");
	end if;



	Ada.Text_IO.Put_Line("__________________________________________________________");
	Ada.Text_IO.Put_Line("");


	Mostrar_Mapa;
	Ada.Text_IO.Put_Line("");





	LLU.Finalize;



end Prueba_Ordered_Maps_G;
