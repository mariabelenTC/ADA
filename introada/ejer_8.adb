with Ada.Text_IO;
with Ada.Strings.Unbounded;
	

procedure ejer_8 is
	
	package ASU renames Ada.Strings.Unbounded;
	
	US: ASU.Unbounded_String;
	
	Pi: constant Float:= 3.14159;
	Max_I: constant Integer:= 1000;
	
	
	X:Float;
	Y:Float:=2.0;
	A:Integer:= 5;
	B:Integer:=2;
	I:Integer;

begin 
	US:= ASU.To_Unbounded_String("Ejercicio 8: ");
	Ada.Text_IO.Put_Line(ASU.To_String(US));
	--Ada.Text_IO.Put_Line(Integer'Image(7));	
	
	
	I := A rem B;
	Ada.Text_IO.Put_Line(Integer'Image(I));	
	I := (990 - Max_I) / A ;
	Ada.Text_IO.Put_Line(Integer'Image(I));
	I := A rem Integer(Y);
	Ada.Text_IO.Put_Line(Integer'Image(I));
	
	Ada.Text_IO.Put_Line(Float'Image(X));	
		
	X := Pi * Y;
	
	Ada.Text_IO.Put_Line(Float'Image(X));	
	
	I := A / B;
	Ada.Text_IO.Put_Line(Integer'Image(I));
	
	X := Float(A)/ Float(B);
	Ada.Text_IO.Put_Line(Float'Image(x));
	
	--X := A rem (Float(A) /Float(B));
	--Ada.Text_IO.Put_Line(Float'Image(x));
	
	-- I := B / 0; 
	
	I := A rem (990 - Max_I);
	Ada.Text_IO.Put_Line(Integer'Image(I));
	
	I := (Max_I - 990) / A ;
	Ada.Text_IO-Put_Line(Integer'Image(I));
	
	X := Float(A) / Y;
	Ada.Text_IO.Put_Line(Float'Image(X));
	
	X := Pi ** 2.0;
	Ada.Text_IO-Put_Line(Float'Image(X));
	
	X := Pi ** Y;
	Ada.Text_IO.Put_Line(Float'Image(X));
	X := Float(A)/ Float(B);
	Ada.Text_IO.Put_Line(Float'Image(x));
	
	I := (Max_I - 990) rem A;
	Ada.Text_IO.Put_Line(Integer'Image(I));
	-- I := A rem 0; 
	
	I := A rem (Max_I - 990);
	Ada.Text_IO.Put_Line(Integer'Image(I));	

end ejer_8;
