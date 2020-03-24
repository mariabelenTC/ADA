with Ada.Real_Time;

	--Llamadas a cualquier Procedure_A,
	--ya sea a través de un controlador de temporizador programado mediante
	--Program_Timer_Procedure
	--o mediante llamadas a Protected_Call,
	--se ejecutan en exclusión mutua.

package Protected_Ops is

   type Procedure_A is access procedure;

   procedure Program_Timer_Procedure (H: Procedure_A; T: Ada.Real_Time.Time);
	--Depertador
	--despues de enviar un mensaje quiera programar el plazo de retrasmision
	--

	--		H: procedimiento que quiero que se ejecute en el futuro (este no debe tener argumentos)
	--		T: Instante en el que quiero que se ejecute

	--		El sistema llamará al procedimiento H cuando la hora T a la que fue encargada su ejecucion,
	--		creando asi para ello un nuevo hilo de ejecucion.
	--		Cuando llegue esa hora el procedimiento se ejecutará de manera concurrente al resto e los hilos
	--		de ejecucion del programa
	--
	--		Llegado el momento mientras que se esté ejecutando el procedimiento
	--		pasado como argumento a Program_Timer_Procedure, este no será interrumpido
	-- 	por procedimientos que se ejecuten mediante Protected_Call.


   procedure Protected_Call (H: Procedure_A);

	-- garantizo que mientras se esté ejecutando.. nadie le va a poder interrumpir
	-- para aquellas partes del codigo que quiero que cuando se ejecute nadie mas lo manipule.
	

	--		H: procedimiento que quiero que se ejecute, es de exclusion mutua con otros
	--		procedimientos que se esten ejecutando a travès de Protected_Call o con el procedimiento
	--		que el sistema esté ejecutando tras haber sido programada su ejecucion futrua a traves
	--		de Program_Timer_Procedure



end Protected_Ops;
