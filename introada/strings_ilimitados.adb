with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Strings_Ilimitados is

--------------------------------------------------------
--el string tiene que estar definido, sino no compila

	Str1:String:="es un String"; --tamaño 12
	Str2:String(1..10); -- simpre tendra tamaño 10

-- luego no puedo asignar a las variables un tamaño diferente
------------------------------------------------------------

	package ASU renames Ada.Strings.Unbounded;
	
	US: ASU.Unbounded_String; --no tiene tamaño fijo
	US2: ASU.Unbounded_String;
	

begin
	
	
	US2:= ASU.To_Unbounded_String (Str1); --Transformo el string en un unbounded_String, xq mi variable es de ese tipo.
	Ada.Text_IO.Put_Line (ASU.To_String(US2));--El put_Line escribe un string, por eso tranformo el unbounded string.
	Ada.Text_IO.Put_Line(Str1);--El put_Line escribe un string.

	
	US := ASU.To_Unbounded_String (Ada.Text_IO.Get_Line); 
	US := ASU.To_Unbounded_String (ASU.To_String(US));
	
	Ada.Text_IO.Put_Line (ASU.To_String(US) & " SE HA CONVERTIDO EN STRING");
	

	

end Strings_Ilimitados;