--Escribe un programa que reciba como entrada el de ıa de la semana y 
--muestre como salida el de ıa siguiente y el de ıa
--anterior al introducido en la entrada.
--El programa deber de usar el siguiente tipo:
--type Dıas is (Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo);

--Ejemplo de ejecucion:
--Introduce el nombre de un dıa de la semana: Domingo
--Ayer fue Sabado
--Hoy es Domingo
--Mañana es Lunes

with Ada.Text_IO;

procedure ejer20 is

	package ATIO renames Ada.Text_IO;

	type TipoDias is (Lunes,Martes,Miercoles,Jueves,Viernes,Sabado,Domingo);
	Dia:TipoDias;
	
	procedure intro_dia(dia:out TipoDias) is
	
	begin	
		ATIO.Put("introduce el nombre de la semana: ");
		dia:=TipoDias'Value(ATIO.Get_Line);
	end intro_dia;

	procedure calendario(dia: in out TipoDias) is
		anterior:TipoDias;
		siguiente:TipoDias;
		Hoy:TipoDias;
	begin
		Hoy:=dia;
		--anterior:=TipoDias'pred(dia);
		--siguiente:=TipoDias'Succ(dia);
		case dia is 
			when Domingo =>
				siguiente:=Lunes;
				anterior:=TipoDias'pred(dia);
			when Lunes =>
				anterior:=Domingo; 
				siguiente:=TipoDias'Succ(dia);
			when others=>
				anterior:=TipoDias'pred(dia);
				siguiente:=TipoDias'Succ(dia);
		end case;
		ATIO.Put_Line("ayer fue " & TipoDias'Image(anterior));
		ATIO.Put_Line("hoy es  " & TipoDias'Image(Hoy));
		ATIO.Put_Line("Mañana será " & TipoDias'Image(siguiente));

	end calendario;

begin
	intro_dia(Dia);
	calendario(Dia);

end ejer20;