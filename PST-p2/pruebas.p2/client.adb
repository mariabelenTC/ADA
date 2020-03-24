with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Command_Line;
with Chat_Messages;
procedure Client is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	Usage_Error: exception;

	use type CM.Message_Type;	
----------------------------------------------------------------------------------------------------------
	procedure comprobar_comandos(maquina:out ASU.Unbounded_String; puerto:out Natural; 
													nickname: out ASU.Unbounded_String) is
	begin
		if ACL.Argument_Count = 3 then
			maquina:=ASU.To_Unbounded_String(ACL.Argument(1));
			puerto:=Natural'Value(ACL.Argument(2));
			nickname:=ASU.To_Unbounded_String(ACL.Argument(3));
		else
			raise Usage_Error;
		end if;
	end comprobar_comandos;
----------------------------------------------------------------------------------------------------------
	procedure Crear_EP(Server_EP: out LLU.End_Point_Type; Maquina:ASU.Unbounded_String; Puerto:Natural) is
		Dir_IP:ASU.Unbounded_String;
	begin
		Dir_IP := ASU.To_Unbounded_String (LLU.To_IP(ASU.To_String(Maquina)));
		Server_EP := LLU.Build (ASU.To_String(Dir_IP) ,Puerto);
	end Crear_EP;
---------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Init(P_Buffer: access  LLU.Buffer_Type; 
									Client_EP: LLU.End_Point_Type; Nickname:ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Init);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
		ASU.Unbounded_String'Output(P_Buffer, Nickname);
	end Build_Message_Init;
--------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Writer(P_Buffer: access  LLU.Buffer_Type;
									Client_EP: LLU.End_Point_Type; Comentario: ASU.Unbounded_String) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Writer);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
		ASU.Unbounded_String'Output(P_Buffer, Comentario);
	end Build_Message_Writer;
---------------------------------------------------------------------------------------------------------
	Procedure Build_Message_Logout (P_Buffer: access LLU.Buffer_Type;Client_EP: LLU.End_Point_Type) is
	begin
		LLU.Reset(P_Buffer.all);
		CM.Message_Type'Output(P_Buffer,CM.Logout);
		LLU.End_Point_Type'Output(P_Buffer, Client_EP);
	end Build_Message_Logout;
---------------------------------------------------------------------------------------------------------
	procedure Modo_Escritor(Client_EP,Server_EP: in LLU.End_Point_Type; P_Buffer: access LLU.Buffer_Type) is
		Comentario:ASU.Unbounded_String;
		Nickname:ASU.Unbounded_String;
	begin
		Loop
			Build_Message_Init(P_Buffer,Client_EP,Nickname);
			LLU.send(Server_EP,P_Buffer); 
			ATIO.Put("Message: ");
			Comentario:=ASU.To_Unbounded_String(ATIO.Get_Line);
			if ASU.To_String(Comentario) /=".quit" then
				Build_Message_Writer(P_Buffer,Client_EP,Comentario);
				LLU.send(Server_EP,P_Buffer);	
			else
				Build_Message_Logout(P_Buffer,Client_EP);
				LLU.send(Server_EP,P_Buffer); 
			end if;	
			exit when ASU.To_String(Comentario)=".quit" ;
		end loop;	
	end Modo_Escritor;
----------------------------------------------------------------------------------------------------------
	Procedure Sacar_Message_Server(P_Buffer: access  LLU.Buffer_Type; Tipo:out CM.Message_Type; Nickname,Text:out ASU.Unbounded_String) is
	begin
		Tipo:= CM.Message_Type'Input(P_Buffer);
		Nickname:=ASU.Unbounded_String'Input(P_Buffer);
		Text:=ASU.Unbounded_String'Input(P_Buffer);
	end Sacar_Message_Server;
----------------------------------------------------------------------------------------------------------
	procedure Modo_Lector(Client_EP,Server_EP: LLU.End_Point_Type; P_Buffer: access  LLU.Buffer_Type) is
		Tipo: CM.Message_Type;
		Nickname: ASU.Unbounded_String;
		Text: ASU.Unbounded_String;
		Expired : Boolean;
	begin
		Build_Message_Init(P_Buffer,Client_EP,Nickname);
		LLU.send(Server_EP,P_Buffer); 
		loop
			LLU.Receive(Client_EP, P_Buffer, 100.0, Expired);
			if Expired then
				ATIO.Put_Line ("Plazo expirado");
			else
				Sacar_Message_Server(P_Buffer,Tipo,Nickname,Text);
				ATIO.Put(ASU.To_String(Nickname) & ": ");
				ATIO.Put_Line(ASU.To_String(Text));
			end if;
		end loop;
	end Modo_Lector;
--------------------------------------------------------------------------------------------------------
	Procedure Evaluar_Nickname(Client_EP,Server_EP: LLU.End_Point_Type; Nickname: ASU.Unbounded_String) is
	Buffer: aliased LLU.Buffer_Type(1024); 
	begin
		if ASU.To_String(Nickname)="reader" then
			Modo_Lector(Client_EP,Server_EP,Buffer'Access);
		else
			Modo_Escritor(Client_EP,Server_EP, Buffer'Access);
		end if;
	end Evaluar_Nickname;
-------------------------------------------------------------------------------------------------------- 
	Maquina:ASU.Unbounded_String;
	Puerto:Natural;
	Server_EP: LLU.End_Point_Type;
	Nickname: ASU.Unbounded_String;
	Client_EP: LLU.End_Point_Type;
		
begin
	comprobar_comandos(Maquina,Puerto,Nickname);
	Crear_EP(Server_EP,Maquina,Puerto);	
	LLU.Bind_Any(Client_EP);

	Evaluar_Nickname(Client_EP,Server_EP, Nickname);	 
	LLU.Finalize;
	
	----------------------------------------------------------------------------
	exception
	when Usage_Error =>
	Ada.Text_IO.Put_Line("Usage:  ./client  <Maquina>  <Puerto>  <Nickname> ");
	LLU.Finalize;
	when Ex:others =>
	Ada.Text_IO.Put_Line ("Excepción imprevista: " &
	Ada.Exceptions.Exception_Name(Ex) & " en: " &
	Ada.Exceptions.Exception_Message(Ex));
	LLU.Finalize;

end Client;