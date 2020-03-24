with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Chat_Messages;
with Ada.Calendar;
with Ada.Command_Line;
with Client_Collections;

package handlers is

	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;
	package ATIO renames Ada.Text_IO;
	package CC renames Client_Collections;

	use type CM.Message_Type;
	use type ASU.Unbounded_String;
	use type Ada.Calendar.Time;
	use type LLU.End_Point_Type;

	procedure Server_Handler(From: in LLU.End_Point_Type;
							 To: in LLU.End_Point_Type;
							 P_Buffer: access LLU.Buffer_Type);

	procedure Client_Handler(From: in LLU.End_Point_Type;
							 To: in LLU.End_Point_Type;
							 P_Buffer: access LLU.Buffer_Type);

end handlers;
