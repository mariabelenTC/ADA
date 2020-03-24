with Ada.Text_IO;

procedure ejer11 is
	package ATIO renames Ada.Text_IO;
	
	
	X,Y,Z: Integer;
	
	Suma:Integer;
	Producto: Integer;

begin 

	X:=Integer'value(ATIO.Get_Line);
	Y:= Integer'value(Atio.Get_Line);
	Z:= Integer'value(ATIO.Get_Line);
	
	Suma:= X+ Y + Z;
	Producto:= X * Y * Z;
	
	ATIO.Put_Line(Integer'image(Suma));
	ATIO.Put_Line(Integer'image(Producto));
	

end ejer11;
