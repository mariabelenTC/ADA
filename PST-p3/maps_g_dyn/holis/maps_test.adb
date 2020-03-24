with Ada.Text_IO;
With Ada.Strings.Unbounded;
with Maps_G;
with Lower_Layer_UDP;
with Ada.Calendar;
with Ada.Exceptions;
--with Gnat.Calendar.Time_IO;
with Get_Image;

procedure Maps_Test is
	package ASU  renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package LLU renames Lower_Layer_UDP;
	package AC renames Ada.Calendar;
	package G renames Get_Image;

	type Valores_T is record
		EP: llu.end_point_type;
		Hora : Ada.calendar.Time;
	end record;

	Max_Clients_Activos:Natural:=Natural'Value("2");

	package Active_Clients is new Maps_G (Key_Type => ASU.Unbounded_String ,
										   Value_Type => Valores_T,
											Max_Clients=> Max_Clients_Activos,
										   "=" => ASU."=");

	package Inactive_Clients is new Maps_G (Key_Type => ASU.Unbounded_String ,
										   Value_Type => AC.Time,
											Max_Clients=> 1,
										   "=" => ASU."=");

	--------------------------------------------------------------------------------
--	function Time_Image(T: AC.Time) return String is
--	begin
--		return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
--	end Time_Image;
----------------------------------------------------------------------------------
--	procedure Trocear_EP(EP_Image:in ASU.Unbounded_String;
--									IP,Puerto: out ASU.Unbounded_String) is
--		P_Delimitador:Integer;
--		Length_F:Natural;
--		Frase:ASU.Unbounded_String;
--	begin
--		Frase:=EP_Image;
--		Length_F:=ASU.Length(Frase);
--		P_Delimitador:= ASU.Index(Frase,"IP: ");
--		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+3));
--		Length_F:=ASU.Length(Frase);
--		P_Delimitador := ASU.Index(Frase,", Port:  ");
--		IP := ASU.Head(Frase,P_Delimitador-1);
--		Length_F:=ASU.Length(Frase);
--		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+8));
--		Puerto := Frase;
--	end Trocear_EP;
----------------------------------------------------------------------------------
--	function Image_EP(EP_Image: in ASU.Unbounded_String) return ASU.Unbounded_String is
--		Image:ASU.Unbounded_String;
--		IP,Puerto:ASU.Unbounded_String;
--	begin
--		Trocear_EP(EP_Image,IP,Puerto);
--		Image:=ASU.To_Unbounded_String(" (" & ASU.To_String(IP) & ":"
--							& ASU.To_String(Puerto) & ")");
--		return Image;
--	end Image_EP;

	Clients:Active_Clients.Map;
	Old_Clients:Inactive_Clients.Map;

--------------------------------------------------------------------------------
	procedure Print_Map (M : Active_Clients.Map) is
		C: Active_Clients.Cursor := Active_Clients.First(M);
		IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;
		Client_Time:AC.Time;
	begin
		ATIO.Put_Line ("Map");
		ATIO.Put_Line ("===");
		while Active_Clients.Has_Element(C) loop
			EP_ASU:=ASU.To_Unbounded_String(LLU.Image(Active_Clients.Element(C).Value.EP));
			EP_Image:=G.Image_EP(EP_ASU);
			Client_Time:=Active_Clients.Element(C).Value.hora;

			ATIO.Put_Line (ASU.To_String(Active_Clients.Element(C).Key)
			 							& ASU.To_String(EP_Image) & " : " &
								 		G.Time_Image(Client_Time));
			Active_Clients.Next(C);
		end loop;
	end Print_Map;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	procedure Print_Map (M : Inactive_Clients.Map) is
		C: Inactive_Clients.Cursor := Inactive_Clients.First(M);
		IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;
		Client_Time: AC.Time;
	begin
		ATIO.Put_Line ("Map");
		ATIO.Put_Line ("===");
		while Inactive_Clients.Has_Element(C) loop
			Client_Time:= Inactive_Clients.Element(C).Value;
			ATIO.Put_Line (ASU.To_String(Inactive_Clients.Element(C).Key) & ":  " &
								 		G.Time_Image(Client_Time));
			Inactive_Clients.Next(C);
		end loop;
	end Print_Map;
--------------------------------------------------------------------------------
	procedure Get_Old_User( M :  Active_Clients.Map;
							Key: out ASU.Unbounded_String;
							Value:out Valores_T) is
 		use type Ada.Calendar.Time;
		C: Active_Clients.Cursor := Active_Clients.First(M);
		Hora_Inicio,Client_Time: AC.Time;
		Found_Old_Time:Boolean;
	begin
		Found_Old_Time:=False;
		Hora_Inicio := Active_Clients.Element(C).Value.Hora;
		Key:=Active_Clients.Element(C).Key;
		Value:=Active_Clients.Element(C).Value;

		while  Active_Clients.Has_Element(C) loop
			Client_Time:=Active_Clients.Element(C).Value.hora;
			if(Client_Time < Hora_Inicio) then
				Hora_Inicio:= Client_Time;
				Key:=Active_Clients.Element(C).Key;
				Value:=Active_Clients.Element(C).Value;

			end if;
			Active_Clients.Next(C);
		end loop;


	end Get_Old_User;

-------------------------------------------------------------------------------

	Old_Nick,Nick1,Nick2,Nick3,Nick4:ASU.Unbounded_String;
	Cliente1,Cliente2,Cliente3,Cliente4:Valores_T;

	IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;

	Value,Old_datos_Client  : Valores_T;
	Success : Boolean;

begin

--==========================CLIENTES ACTIVOS==================================--

	Nick1:=ASU.To_Unbounded_String("Belen");
	Cliente1.EP:= LLU.Build ("193.147.71",8000);
	Cliente1.Hora:=AC.Clock;
	delay 2.0;
	Nick2:=ASU.To_Unbounded_String("Maria");
	Cliente2.EP:=LLU.Build ("193.147.72",9000);
	Cliente2.Hora:=AC.Clock;
	delay 3.0;
	Nick3:=ASU.To_Unbounded_String("Isa");
	Cliente3.EP:=LLU.Build ("193.147.73",10000);
	Cliente3.Hora:=AC.Clock;
	delay 1.0;
	Nick4:=ASU.To_Unbounded_String("Regui");
	Cliente4.EP:= LLU.Build ("193.147.60",9001);
	Cliente4.Hora:=AC.Clock;


	-----------AÑADIR CLIENTES---------------------------------------------------
--------------------------------------------------------------------------------
		begin
		ATIO.Put_Line("añado 1º cliente");
		Active_Clients.Get(Clients,Nick1,Value,Success);
		ATIO.Put_Line(Boolean'Image(Success));
		if not Success then
		ATIO.Put_Line(Natural'Image(Active_Clients.Map_Length(Clients)));
			Active_Clients.Put(Clients,Nick1,Cliente1);
		ATIO.Put_Line(Natural'Image(Active_Clients.Map_Length(Clients)));
		end if;

		exception
			when Active_Clients.Full_Map =>
				Get_Old_User(Clients,Old_Nick,Old_datos_Client);
				Active_Clients.Delete(Clients, Old_Nick, Success);
		end;
		ATIO.New_Line;
		ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
							  Integer'Image(Active_Clients.Map_Length(Clients)));

		ATIO.New_Line;
		Print_Map(Clients);

		ATIO.New_Line;
		Get_Old_User(Clients,Old_Nick,Old_datos_Client);
		ATIO.Put("El usuario mas antiguo es:   ");
		ATIO.Put_Line(ASU.To_String(Old_Nick) & " " & G.Time_Image(Old_datos_Client.Hora));
--------------------------------------------------------------------------------
		begin
		ATIO.Put_Line("añado 2º client");
		Active_Clients.Get(Clients,Nick2,Value,Success);
		ATIO.Put_Line(Boolean'Image(Success));
		if not Success then

			Active_Clients.Put(Clients,Nick2, Cliente2);
		ATIO.Put_Line(Natural'Image(Active_Clients.Map_Length(Clients)));
		end if;

		exception
			when Active_Clients.Full_Map =>
				Get_Old_User(Clients,Old_Nick,Old_datos_Client);
				Active_Clients.Delete(Clients, Old_Nick, Success);
		end;
		ATIO.New_Line;
		ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
							  Integer'Image(Active_Clients.Map_Length(Clients)));

		ATIO.New_Line;
		Print_Map(Clients);

		ATIO.New_Line;
		Get_Old_User(Clients,Old_Nick,Old_datos_Client);
		ATIO.Put("El usuario mas antiguo es:   ");
		ATIO.Put_Line(ASU.To_String(Old_Nick) & " " & G.Time_Image(Old_datos_Client.Hora));
--------------------------------------------------------------------------------
		begin
		ATIO.Put_Line("añado 3º cliente");
		Active_Clients.Get(Clients,Nick3,Value,Success);
		ATIO.Put_Line(Boolean'Image(Success));
		if not Success then
			Active_Clients.Put(Clients,Nick3, Cliente3);
			ATIO.Put_Line(Natural'Image(Active_Clients.Map_Length(Clients)));
		end if;
		exception
			when Active_Clients.Full_Map =>
				Get_Old_User(Clients,Old_Nick,Old_datos_Client);
				Active_Clients.Delete(Clients, Old_Nick, Success);
		end;
		ATIO.New_Line;
		ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
							  Integer'Image(Active_Clients.Map_Length(Clients)));

		ATIO.New_Line;
		Print_Map(Clients);

		ATIO.New_Line;
		Get_Old_User(Clients,Old_Nick,Old_datos_Client);
		ATIO.Put("El usuario mas antiguo es:   ");
		ATIO.Put_Line(ASU.To_String(Old_Nick) & " " & G.Time_Image(Old_datos_Client.Hora));
--------------------------------------------------------------------------------
		begin
		ATIO.Put_Line("añado 4º cliente");
		Active_Clients.Get(Clients,Nick4,Value,Success);
		ATIO.Put_Line(Boolean'Image(Success));
		if not Success then
			ATIO.Put_Line(Natural'Image(Active_Clients.Map_Length(Clients)));
			Active_Clients.Put(Clients,Nick4, Cliente4);
		end if;
		exception
			when Active_Clients.Full_Map =>
				Get_Old_User(Clients,Old_Nick,Old_datos_Client);
				Active_Clients.Delete(Clients, Old_Nick, Success);
		end;
--------------------------------------------------------------------------------

 	---------------------PINTAR LISTA CLIENTES-----------------------------------
	ATIO.New_Line;
	ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
						  Integer'Image(Active_Clients.Map_Length(Clients)));

	ATIO.New_Line;
	Print_Map(Clients);

	ATIO.New_Line;
	Get_Old_User(Clients,Old_Nick,Old_datos_Client);
	ATIO.Put("El usuario mas antiguo es:   ");
	ATIO.Put_Line(ASU.To_String(Old_Nick) & " " & G.Time_Image(Old_datos_Client.Hora));

--==========================CLIENTES INACTIVOS==================================--

	begin
	Active_Clients.Delete(Clients, Nick1, Success);
	if Success then
		ATIO.Put_Line ("Delete: " & ASU.To_String(Nick1));
		Inactive_Clients.Put(Old_Clients,Nick1, Cliente1.Hora);
	else
		ATIO.Put_Line ("Nick:" & ASU.To_String(Nick1)& " Nick no encontrado");
	end if;

	exception
		when Inactive_Clients.Full_Map =>
			ATIO.New_Line;
			ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
							 Integer'Image(Inactive_Clients.Map_Length(Old_Clients)));
			ATIO.New_Line;
			Print_Map(Old_Clients);

			LLU.Finalize;

	end;
--------------------------------------------------------------------------------
	begin
	Active_Clients.Delete(Clients, Nick2, Success);
	if Success then
		ATIO.Put_Line ("Delete: " & ASU.To_String(Nick2));
		Inactive_Clients.Put(Old_Clients,Nick2,Cliente2.Hora);
	else
		ATIO.Put_Line ("Nick:" & ASU.To_String(Nick2)& " Nick no encontrado");
	end if;

	exception
		when Inactive_Clients.Full_Map =>
			ATIO.New_Line;
			ATIO.Put_Line ("Longitud de la tabla de símbolos: " &
							  Integer'Image(Inactive_Clients.Map_Length(Old_Clients)));
			ATIO.New_Line;
			Print_Map(Old_Clients);

			LLU.Finalize;

	end;



--============================================================================--


	LLU.Finalize;

end Maps_Test;
