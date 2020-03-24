with Ada.Text_IO;

procedure repetido is
	package ATIO renames Ada.Text_IO;

	numero:Integer;
	numero2:Integer;
	function repetido (numero:Integer; numero2:Integer) return Boolean is
		rep:Boolean;
	begin
		rep:=False;
		if not rep and numero /= numero2 then
			return rep=True;
		else 
			return rep=False;
		end if;

	end repetido;
	comprobar:Boolean;
begin
	
		numero:=Integer'Value(ATIO.Get_Line);
		numero2:=Integer'Value(ATIO.Get_Line);
		comprobar:=repetido(numero,numero2);
		ATIO.Put_Line(Boolean'Image(comprobar));
		if comprobar=True then
		numero2:=1;
		end if;
		ATIO.Put_Line(Integer'Image(numero));
		ATIO.Put_Line(Integer'Image(numero2));
	
		
end repetido;