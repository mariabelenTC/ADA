--condicion de salida.

with Ada.Text_IO;

procedure booleano is

	package ATIO renames Ada.Text_IO;
	comprobar:Boolean;
	function no_es_menosuno (numero: in  Integer) return Boolean is
		esmenosuno:boolean;
	begin
		esmenosuno:=False;
		if not esmenosuno and numero/= -1 then
			return esmenosuno=True;
		else 
			return esmenosuno=False;
		end if;
	end no_es_menosuno;

	numero:Integer;
begin
	numero:=Integer'Value(ATIO.Get_Line);
	comprobar:=no_es_menosuno(numero);
	ATIO.Put_Line(boolean'Image(comprobar));

end booleano;	