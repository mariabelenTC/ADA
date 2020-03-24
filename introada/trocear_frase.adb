with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Exceptions;

procedure trocear_frase is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package AE renames Ada.Exceptions;
	package ACL renames Ada.Command_Line;
	Usage_Error: exception;

	procedure Next_Token(Frase:in out ASU.Unbounded_String;
						palabra: Out ASU.Unbounded_String;
						Delimiter: in String) is
		posicion:Integer;
	begin
		posicion:=ASU.Index(Frase,Delimiter);
		palabra:=ASU.Head(Frase,posicion-1);
		ASU.Tail(Frase,ASU.Length(Frase)-posicion);

	end Next_Token;

	procedure imprimir_troceado(Frase:in out ASU.Unbounded_String;Palabra:in out ASU.Unbounded_String ) is
	begin
		Ada.Text_IO.Put("Introduce una frase: ");
		Frase:=ASU.To_Unbounded_String(ATIO.Get_Line);
		
		for I in 1..3 loop
			Next_Token(Frase,Palabra, " ");
			ATIO.Put_Line("|" & ASU.To_String(Palabra) & "|");
		end loop;
		ATIO.Put_Line(ASU.To_String(Frase));
	end imprimir_troceado;

	Frase:ASU.Unbounded_String;
	Palabra:ASU.Unbounded_String;
begin
	if ACL.Argument_Count /= 1 then
		raise Usage_Error;
	end if;
	imprimir_troceado(Frase,Palabra);

	exception
	when Usage_Error =>
	Ada.Text_IO.Put_Line ("Uso: trocear_frase_US <nùmero-de-puerto>");
end trocear_frase;
