with Ada.Text_IO;
with Ada.Calendar;
with Gnat.Calendar.Time_IO;


procedure Plazo is
   use type Ada.Calendar.Time;
	package ATIO renames Ada.Text_IO;
	package AC renames Ada.Calendar;


   function Time_Image (T: Ada.Calendar.Time) return String is
   begin
      return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
   end Time_Image;


	procedure Print_Clock (Hora_Inicio,Hora_Fin: AC.Time;Hora_Actual, Hora_Anterior: in out AC.Time) is
		--Hora_Anterior:AC.Time;
		--Hora_Actual:AC.Time;
		Intervalo: constant Duration := 0.2;
	begin
		ATIO.Put_Line("Hora de inicio: " & Time_Image(Hora_Inicio));
	   ATIO.Put_Line("Hora de fin:    " & Time_Image(Hora_Fin));

	   while Hora_Actual < Hora_Fin loop
	      if Hora_Actual - Hora_Anterior > Intervalo then
	         ATIO.Put ("Hora actual:    " & Time_Image(Hora_Actual));
	         ATIO.Put_Line (", han pasado ya: " &
	                           Duration'Image(Hora_Actual - Hora_Inicio) &
	                              " segundos");
	         Hora_Anterior := Hora_Actual;
	      end if;
	      Hora_Actual := AC.Clock;
	   end loop;

	   ATIO.Put_Line("Saliendo:       " & Time_Image(Hora_Actual));

	end Print_Clock;


   Plazo: constant Duration := 3.0;
   --Intervalo: constant Duration := 0.2;
   Hora_Inicio, Hora_Fin: AC.Time;
   Hora_Actual, Hora_Anterior: Ada.Calendar.Time;

begin
   --
   Hora_Inicio := AC.Clock;
   Hora_Fin := Hora_Inicio + Plazo;
   Hora_Anterior := Ada.Calendar.Clock;
   Hora_Actual := Ada.Calendar.Clock;

  Print_Clock(Hora_Inicio,Hora_Fin,Hora_Actual, Hora_Anterior);

   --
   --ATIO.Put_Line("Hora de inicio: " & Time_Image(Hora_Inicio));
   --ATIO.Put_Line("Hora de fin:    " & Time_Image(Hora_Fin));
   --
   --while Hora_Actual < Hora_Fin loop
   --   if Hora_Actual - Hora_Anterior > Intervalo then
   --      ATIO.Put ("Hora actual:    " & Time_Image(Hora_Actual));
   --      ATIO.Put_Line (", han pasado ya: " &
   --                              Duration'Image(Hora_Actual - Hora_Inicio) &
   --                              " segundos");
   --      Hora_Anterior := Hora_Actual;
   --   end if;
   --   Hora_Actual := Ada.Calendar.Clock;
   --end loop;
   --
   --ATIO.Put_Line("Saliendo:       " & Time_Image(Hora_Actual));

end Plazo;
