with Ada.Text_IO;

procedure ejer17 is
	package ATIO renames Ada.Text_IO;

	type Day is (Monday, Tuesday, Wednesday, Thursday, Friday,Saturday,Sunday);
	today : Day:=Thursday;
	posicion:Integer;

begin
	posicion:=Day'Pos(Monday);
	ATIO.Put_Line("posicion de Monday "& Integer'Image(posicion));
	posicion:=Day'Pos(Today); --- me dará la posicion de Thursday, a lo que esta inicializado.
	ATIO.Put_Line("posicion de Today "& Integer'Image(posicion));

--	today:=Day'Val(6); lo que hay en la posicion 6
--	recorrer enumerado
	for k in 0..6 loop
		today:=Day'Val(k);
		--posicion:=Day'Pos(k);
		ATIO.Put_Line(Day'Image(today));
	end loop;
	
	
	--Today < Tuesday;

	
	today := Day'Succ(Saturday);
	ATIO.Put_Line(Day'Image(today));

	today:=Day'Pred(Tuesday);
	ATIO.Put_Line(Day'Image(today));

--	today:=Today >= Thursday;
	
	ATIO.Put_Line(Integer'Image(posicion));

end ejer17;