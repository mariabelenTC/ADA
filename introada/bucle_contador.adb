with Ada.Text_IO;
procedure Bucle_2 is
	I: Integer;
begin
	I:=1;
	Ada.Text_IO.Put_Line(Integer'Image(I));
	while I < 20 loop
		I := I + 1;
		Ada.Text_IO.Put_Line(Integer'Image(I));
	end loop;
	
	I:=10;
	Ada.Text_IO.Put_Line(Integer'Image(I));
	loop 
		I:= I+10;
		exit when I >100;
		Ada.Text_IO.Put_Line(Integer'Image(I));
	end loop;
	

end Bucle_2;
