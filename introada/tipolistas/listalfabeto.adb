with Ada.Text_IO;
with lista;
with Ada.Strings.Unbounded;



procedure listalfabeto is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	package l renames lista;

	Mi_Lista:l.Word_List_Type;
	procedure buscar_menor( Word1,Word2: in  ASU.Unbounded_String ; haymenor: out Boolean; Word:out ASU.Unbounded_String)  is
	
	begin
	  	if ASU.To_String(Word1)>ASU.To_String(Word2) then
			haymenor:=True;
			word:=Word2;
		else
			word:=Word1;
		end if;	
	end buscar_menor;

haymenor:Boolean;
Word:ASU.Unbounded_String;
	
	
begin
	--buscar_menor(ASU.To_Unbounded_String("acd"), ASU.To_Unbounded_String("abc"), haymenor,Word);
	--ATIO.Put_Line("la palabra mas pequeña: " & ASU.To_String(Word));
	for k in 0..2 loop
		l.Add_Word_alfabeto(Mi_Lista,ASU.To_Unbounded_String(ATIO.Get_Line));
	end loop;
	
	l.Print_All(Mi_Lista);

end listalfabeto;