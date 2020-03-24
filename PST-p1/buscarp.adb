with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure buscarp is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;

	function Count_Parentesis(Frase:in out ASU.Unbounded_String;Parentesis: in String) return Natural is
		Length_F:Natural;
		N:Natural;
		P_Parentesis:Natural;
	begin
		N:=0;
		loop 
			Length_F:=ASU.Length(Frase);
			
			P_Parentesis:=ASU.Index(Frase,Parentesis);					 --Extension 1 			
					
			if P_Parentesis = 1 then
				Frase:= ASU.Tail(Frase,Length_F-P_Parentesis);	
				N:=N+1;
			elsif P_Parentesis/= 0 then
				N:=N+1;
				Frase:=ASU.Tail(Frase,Length_F-P_Parentesis);
			
			end if;			
			exit when P_Parentesis = 0; -- para que no se salga de mi rango
		
		end loop;	
	
		return N;	
	end Count_Parentesis;
	N_P_Open:Natural;
	N_P_Close:Natural;
	Frase:ASU.Unbounded_String;
begin
	
	Ada.Text_IO.Put("Introduce una frase: ");
	Frase:=ASU.To_Unbounded_String(ATIO.Get_Line);
	
	N_P_Open:=Count_Parentesis(Frase,"(");
	N_P_Close:=Count_Parentesis(Frase,")");
	

	if N_P_Open=0 and N_P_Close=0 then
		ATIO.Put_Line("Expresion sin parentesis");
	elsif N_P_Open = N_P_Close then
		ATIO.Put_Line("Parentesis Equilibrados");
	else
		ATIO.Put_Line("Parentesis no Equilibrados");
	end if;

end buscarp;