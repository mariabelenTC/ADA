with Ada.Text_IO;

procedure ejer6 is
	package ATIO renames Ada.Text_IO;
	
	Operacion:Integer;
begin
	
	Operacion:= 22/7;
	ATIO.Put_Line("22/7: " & Integer'Image(Operacion));
	Operacion:= 7/22;
	ATIO.Put_Line("7/22: " & Integer'Image(Operacion));
	Operacion:= 22 rem 7;
	ATIO.Put_Line("22 rem 7: " & Integer'Image(Operacion));
	Operacion:= 7 rem 22;
	ATIO.Put_Line("7 rem 22: " & Integer'Image(Operacion));
	Operacion:= 15/16;
	ATIO.Put_Line("15/16: " & Integer'Image(Operacion));
	Operacion:=16/15;
	ATIO.Put_Line("16/15: " & Integer'Image(Operacion));
	Operacion:= 15 rem 16;
	ATIO.Put_Line("15 rem 16: " & Integer'Image(Operacion));
	operacion:=16 rem 15;
	ATIO.Put_Line("16 rem 15: " & Integer'Image(Operacion));
	Operacion:= 3/23;
	ATIO.Put_Line(" 3/33: " & Integer'Image(Operacion));
	Operacion:= 23/3;
	ATIO.Put_Line("23/3: " & Integer'Image(Operacion));
	Operacion:= 3 rem 23;
	ATIO.Put_Line("3 rem 23: " & Integer'Image(Operacion));
	Operacion:= 23 rem 3;
	ATIO.Put_Line("23 rem 3: " & Integer'Image(Operacion));
	Operacion:= 4/16;
	ATIO.Put_Line("4/16: " & Integer'Image(Operacion));
	Operacion:=16/4;
	ATIO.Put_Line("16/4: " & Integer'Image(Operacion));
	Operacion:= 4 rem 16;
	ATIO.Put_Line("4 rem 16: " & Integer'Image(Operacion));
	Operacion:= 16 rem 4;
	ATIO.Put_Line("16 rem 4: " & Integer'Image(Operacion));	
end ejer6;
