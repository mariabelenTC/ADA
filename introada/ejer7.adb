with Ada.Text_IO;

procedure ejer7 is
	package ATIO renames Ada.Text_IO;
	
	Pi: constant Float:= 3.14159;
	Max_I : constant Integer := 1000;
	X:Float;
	Y:Float := -1.0;
	A:Integer := 3;
	B:Integer := 4;
	I:Integer;
begin 
	I:= A rem B;
	ATIO.Put_Line(Integer'Image(I));
	I:=(990 - Max_I)/A;
	ATIO.Put_Line(Integer'Image(I));
	I:= a rem Integer(Y); -- Y es un float, asi que hay que pasarlo a integer para que se pueda guardar en la variable de tipo integer.
	ATIO.Put_Line(Integer'Image(I));
	X:= Pi * Y;
	ATIO.Put_Line(Float'Image(X));
	I := A / B;
	ATIO.Put_Line(Integer'Image(I));
	X := float(A / B);
	X := float(A rem A / B);
	ATIO.Put_Line(Float'Image(X));
	--I := B / 0; no se puede dividir por cero
	I := A rem (990 - Max_I);
	ATIO.Put_Line(Integer'Image(I));
	I := (Max_I - 990) / A;
	ATIO.Put_Line(Integer'Image(I));
	X :=Float(A) / Y;
	ATIO.Put_Line(Float'Image(X));
	X := Pi ** 2;
	ATIO.Put_Line(Float'Image(X));
	X := Pi ** Integer(Y);
	ATIO.Put_Line(Float'Image(X));
	X := Float(A / B);
	ATIO.Put_Line(Float'Image(X));
	I := (Max_I - 990) rem A;
	ATIO.Put_Line(Integer'Image(I));
	-- I := A rem 0; esto me dará: "Constraint_Error" will be raised at run time
	I := A rem (Max_I - 990);
	ATIO.Put_Line(Integer'Image(I));
end ejer7;

	




