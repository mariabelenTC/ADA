--Escribe un programa que muestre la fecha actual 
--en el formato dd de MES de yyyy, siendo MES el nombre del mes.
--Ej: si hoy es 11/02/2001
--el programa mostrará 11 de febrero de 2001.


with Ada.Text_IO;
with Ada.Calendar;


procedure ejer19 is

	package ATIO renames Ada.Text_IO;
	package A_C renames Ada.Calendar;
	
	 
	 
begin
	ATIO.Put_Line("Hola mundo");

end ejer19;                 
