with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
with Handlers;
with Protocolo_Perdidas;

procedure chat_client_2 is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package H renames Handlers;
	package PP renames Protocolo_Perdidas;

	Usage_Error:exception;
	Ignored:exception;
	Shutdown:exception;
	Fault_pct_Error:exception;
	Max_delay_Error:exception;

	use type CM.Message_Type;

--____________________________________________________________________________--

	procedure comprobar_comandos (maquina:out ASU.Unbounded_String;
	 										puerto:out Natural;
											nickname: out ASU.Unbounded_String;
											min_delay,max_delay,fault_pct:out Natural) is
	begin
		if ACL.Argument_Count = 6 then
			maquina:=ASU.To_Unbounded_String(ACL.Argument(1));
			puerto:=Natural'Value(ACL.Argument(2));
			nickname:=ASU.To_Unbounded_String(ACL.Argument(3));
			min_delay:=Natural'Value(ACL.Argument(4));
			max_delay:=Natural'Value(ACL.Argument(5));
			if (max_delay < min_delay) then
				raise Max_delay_Error;
			end if;
			fault_pct:=Natural'Value(ACL.Argument(6));
			if (fault_pct< 0 or fault_pct > 100) then
				raise Fault_pct_Error;
			end if;
		else
			raise Usage_Error;
		end if;
	end comprobar_comandos;
--____________________________________________________________________________--

	procedure Crear_EP (	Server_EP: out LLU.End_Point_Type;
								Maquina:ASU.Unbounded_String;
								Puerto:Natural) is
		Dir_IP:ASU.Unbounded_String;
	begin
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build (ASU.To_String(Dir_IP),Puerto);
	end Crear_EP;

--____________________________________________________________________________--

	procedure Modo_Escritor_Lector ( Client_EP_Receive:in LLU.End_Point_Type;
												Client_EP_Handler:in LLU.End_Point_Type;
												Server_EP: in LLU.End_Point_Type;
												Nickname:in ASU.Unbounded_String;
												P_Buffer: access LLU.Buffer_Type) is
		Comentario:ASU.Unbounded_String;
		n_secuencia:H.Seq_N_T:=0;
	begin
		ATIO.Put(">>");
		ATIO.New_Line;
		Loop
			n_secuencia:=n_secuencia+1;
			ATIO.Put(">>");
			Comentario:=ASU.To_Unbounded_String(ATIO.Get_Line);
			if ASU.To_String(Comentario) /=".quit" then
				CM.Build_Message_Writer(P_Buffer,Client_EP_Handler,n_secuencia,Nickname,Comentario);

				LLU.send(Server_EP,P_Buffer);
			else
				CM.Build_Message_Logout(P_Buffer,Client_EP_Handler,n_secuencia,Nickname);
				LLU.send(Server_EP,P_Buffer);
			end if;
			exit when ASU.To_String(Comentario)=".quit" ;
		end loop;
	end Modo_Escritor_Lector;
--____________________________________________________________________________--

	Maquina:ASU.Unbounded_String;
	Puerto,Min_delay,Max_delay,Fault_pct:Natural;
	Plazo_Retrasmision:Duration;
	Nickname: ASU.Unbounded_String;
	Client_EP_Receive,Client_EP_Handler: LLU.End_Point_Type;
	Buffer: aliased LLU.Buffer_Type(1024);
	Acogido,Expired:Boolean;

	--numero Maximo  de restrasmision
	Max_R:Integer;
	M:Integer;

begin

	comprobar_comandos(Maquina,Puerto,Nickname,Min_delay,Max_delay,Fault_pct);
	Crear_EP(H.Server_EP_Handler,Maquina,Puerto);

	PP.Provocar_Perdida_Mess(Max_delay,Fault_pct);
	Max_R:= PP.Restrasmisiones(Fault_pct);

	LLU.Bind_Any(Client_EP_Receive);
	LLU.Bind_Any(Client_EP_Handler,H.Client_Handler'Access);

	M:=0;
	loop
		M:= M+1;
		-- Guardar la informacion del mensaje
		CM.Build_Message_Init(Buffer'Access,Client_EP_Receive,Client_EP_Handler,Nickname);
		LLU.send(Server_EP,Buffer'Access);

		LLU.Reset(Buffer);
		LLU.Receive(Client_EP_Receive,Buffer'Access, 10.0, Expired);
		if not Expired then
			CM.Extract_Message_Welcome(Buffer'Access,Acogido);
			if Acogido then
				ATIO.Put_Line("Mini-Chat_2 v2.0: Welcome " & ASU.To_String(Nickname));
				Modo_Escritor_Lector(Client_EP_Receive,Client_EP_Handler,Server_EP,Nickname,Buffer'Access);
				ATIO.New_Line;
			else
				ATIO.Put_Line("Mini-Chat_2 v2.0: IGNORED new user "& ASU.To_String(Nickname)
				 						& ", nick already used");
				raise Ignored;
			end if;
		end if;

		Exit when M = Max_R+1 or Acogido;

	end loop;
	LLU.Finalize;

--------------------------------------------------------------------------------

	exception
	when Usage_Error =>
		ATIO.Put_Line("Usage:  ./client  <Maquina>  <Puerto>  <Nickname>  <min_delay> <max_delay> <fault_pct> ");
		LLU.Finalize;
	when Max_delay_Error=>
		ATIO.Put_Line("El retardo maximo debe ser mayor o igual al retardo minimo");
		LLU.Finalize;
	when Fault_pct_Error=>
		ATIO.Put_Line("el procentaje de error debe ser entre 0 y 100");
		LLU.Finalize;
	When Shutdown =>
		ATIO.Put_Line("Server unreachable");
		LLU.Finalize;
	When Ignored =>
		LLU.Finalize;
	when Ex:others =>
		ATIO.Put_Line ("Excepción imprevista: " &
		Ada.Exceptions.Exception_Name(Ex) & " en: " &
		Ada.Exceptions.Exception_Message(Ex));
		LLU.Finalize;

end chat_client_2;
