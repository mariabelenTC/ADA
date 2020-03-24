with gnat.os_lib;

package body Protocolo_Perdidas is

--____________________________________________________________________________--

	procedure Provocar_Perdida_Mess(Max_delay,Fault_pct:in Natural) is
	begin
		LLU.Set_Faults_Percent(Fault_pct);
		LLU.Set_Random_Propagation_Delay(0,500);
	end Provocar_Perdida_Mess;

--____________________________________________________________________________--

	function Plazo_Retrasmision (Max_delay:Natural) return Duration is
		Plazo_Retrasmision:Duration;
	begin
		--LA HORA DE RETRASMISION
		Plazo_Retrasmision:=2*Duration(Max_delay)/1000;

		return Plazo_Retrasmision;
	end Plazo_Retrasmision;
--____________________________________________________________________________--

	function Restrasmisiones(Fault_pct:in Natural) return Natural is
		Max_R: Natural;
	begin

		Max_R:= 10 + ((Fault_pct/10)**2);
		return Max_R;

	end Restrasmisiones;

--____________________________________________________________________________--


	procedure Guardar_Mensajes_Server() is
	begin

		-- Pending_Msgs: Coleccion de mensajes pendintes de asentimiento


		-- Restrasmision_Times : Coleccion de horas  y mesajes a restransmitir

	end guardar_Mensajes_Server;

	procedure Guardar_Mensajes_Client() is
	begin

		-- Pending_Msgs: Coleccion de mensajes pendintes de asentimiento

		-- Restrasmision_Times : Coleccion de horas  y mesajes a restransmitir

	end guardar_Mensajes_Client;


	procedure Gestion_de_Retrasmisiones() is

	begin

	end Gestion_de_Retrasmisiones;


end Protocolo_Perdidas;
