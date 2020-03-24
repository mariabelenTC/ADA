with Ada.Command_Line;
with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Chat_Messages;
with Ada.Calendar;
with Maps_G;



package Protocolo_Perdidas is
	package ACL renames Ada.Command_Line;
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package CM renames Chat_Messages;

	type Seq_N_T is mod Integer'Last;


	package Pending_Msgs is new Maps_G (Key_Type => ASU.Unbounded_String ,
													Value_Type => Valores_T,
													Max_Clients=> get_max_clients,
													"=" => ASU."=");


	Procedure Provocar_Perdida_Mess(Max_delay,Fault_pct:in Natural);


	function Restrasmisiones(Max_R: Natural);




end Protocolo_Perdidas;
