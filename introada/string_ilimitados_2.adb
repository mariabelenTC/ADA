with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure String_Ilimitados_2 is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
		
	use type ASU.Unbounded_String;
	
	US: ASU.Unbounded_String;

begin 
	ATIO.Put("Di algo:  ");
	US:= ASU.To_Unbounded_String(ATIO.Get_line);
	
	if US = "gracias" then
		ATIO.Put_Line("Gracias a ti");
	else 
		US:= "Has dicho: "& US;
		ATIO.Put_Line(ASU.TO_String(US));
	end if;
		
end String_Ilimitados_2;
	
	