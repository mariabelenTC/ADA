with Ada.Text_IO;

--Programa que muestra las tablas de multiplicar

procedure Tablas_De_Multiplicar is 
	
	package ATIO renames Ada.Text_IO;
	
	Resultado:Integer;

begin
	ATIO.Put_Line("Tablas de multiplicar");
	ATIO.Put_Line("=====================");
	ATIO.New_Line(2); --imprime dos lineas en banco en el terminal

	for Fila in 1..10 loop
		ATIO.New_Line(2);
		for Columna in 1..10 loop
		    Resultado := Fila * Columna;
			ATIO.Put (Integer'Image(Fila) & "*" &
					  Integer'Image(Columna) & "=" &
					  Integer'Image(Resultado));
			ATIO.New_Line;	
		end loop;
	end loop;

end Tablas_De_Multiplicar;

