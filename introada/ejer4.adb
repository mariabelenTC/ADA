with Ada.Text_IO;

procedure ejer4 is 
	
	X:Integer;
	Y:Integer;
	Z:Integer;
	A:Float;
	B:Float;
	C:Float;
begin
	Y:= 15;
	Z:= -Y + 3;
    X:= Y + Z;
	
	Ada.Text_IO.Put_Line(Integer'Image(Z) & Integer'Image(Y) & Integer'Image(X));
	
	A:=2.5;
	B:=25.2;
	Ada.Text_IO.Put_Line("Es un float de 2.5: " & Float'Image(A));
	Ada.Text_IO.Put_Line("Es un float de 25.0: " & Float'Image(B));
	A:=0.2;
	B:=1.5;
	C:= A+B;
	X:=Integer(A);
	Y:=Integer(B);
	Ada.Text_IO.Put_Line("Tranformo 1.2 a integer: " & Integer'Image(X));
	Ada.Text_IO.Put_Line("Tranformo 1.5 a integer: " & Integer'Image(Y));
	
	
end ejer4;
