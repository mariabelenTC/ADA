with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure multiplicararray is
	package ATIO renames Ada.Text_IO;
	package I_IO renames Ada.Integer_Text_IO;

	A:array (1..3) of Integer;
	producto:Integer;
	B:Integer;
	n:Integer;
begin

	b:=1;
	producto:=1;
	for n in 1..3 loop
		if n/=0 then
		--A(n):=Integer'Value(ATIO.Get_Line);
		A(n):=I_IO.Get_Line;
	end if;
		producto:=A(n)*B;
		B:=Producto;

	end loop;
	ATIO.Put_Line(Integer'Image(Producto));
end multiplicararray;
