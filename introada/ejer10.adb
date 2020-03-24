with Ada.Text_IO;

procedure ejer10 is
	package ATIO renames Ada.Text_IO;
	
	I, J, K : Integer;
	A,B,C,X : Integer;
	

begin

	X := (Integer(4.0) * A) * C;
	A := A*C;
	I := 2 * (-J);
	K := 3*(I + J);
	X := 5*A / B*C;
	I := 5*J*3;
	ATIO.Put_Line("hola mundo");
end ejer10;
