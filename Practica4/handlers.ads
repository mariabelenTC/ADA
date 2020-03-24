with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Chat_Messages;
with Ada.Calendar;
with Gnat.Calendar.Time_IO;
with Ada.Command_Line;
with Ordered_Maps_G;
with Comparador_Array;

package Handlers is 

	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;

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


	procedure Mostrar_Mapa(lista: in ASU.Unbounded_String);

	type Tipo_Datos is record
		EP: LLU.End_Point_Type;
		Time: Ada.Calendar.Time;
	end record;


end Handlers;
