with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Maps;
With Lower_Layer_UDP;

procedure trocear_ep is
	package ASU renames Ada.Strings.Unbounded;
	package ATIO renames Ada.Text_IO;
	package LLU renames Lower_Layer_UDP;
	package ASM renames Ada.Strings.Maps;
	Usage_Error: exception;
--LOWER_LAYER.INET.UDP.UNI.ADDRESS IP: 193.147.0.72, Port:  1025
	--procedure Corto(Frase:in out ASU.Unbounded_String; IP,Puerto: out ASU.Unbounded_String;Delimitador: in ASM.Character_Set) is
	--	P_Delimitador:Integer;
	--	Length_F:Natural;
	--begin
	--	loop
	--		Length_F:=ASU.Length(Frase);
	--		P_Delimitador:=ASU.Index(Frase,Delimitador);
	--		if P_Delimitador = 33 or P_Delimitador = 1 then
	--			Frase:= ASU.Tail(Frase,Length_F-P_Delimitador);
	--		elsif P_Delimitador=4 then
	--			Frase:= ASU.Tail(Frase,Length_F-P_Delimitador);
	--		elsif P_Delimitador = 13 then
	--			IP:= ASU.Head(Frase,P_Delimitador -1);--193.147.0.72
	--			Frase:=ASU.Tail(Frase,Length_F-P_Delimitador);
	--		elsif P_Delimitador = 6 then
	--			Frase:= ASU.Tail(Frase,Length_F-P_Delimitador);
	--		elsif P_Delimitador=0  and Length_F/=0 then
	--			Puerto:=ASU.Tail(Frase,Length_F);
	--		end if;
	--		exit when P_Delimitador = 0; -- para que no se salga de mi rango
	--	end loop;
	--end Corto;

	procedure Corto(EP:in ASU.Unbounded_String; IP,Puerto: out ASU.Unbounded_String) is
		P_Delimitador:Integer;
		Length_F:Natural;
		Frase:ASU.Unbounded_String;
	begin
		Frase:=EP;
		--frase:LOWER_LAYER.INET.UDP.UNI.ADDRESS IP: 193.147.0.72, Port:  1025
		Length_F:=ASU.Length(Frase);
--	ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));

		P_Delimitador:= ASU.Index(Frase,"IP: ");
--	ATIO.Put_Line("poscion de un espacio: " & Integer'Image(P_Delimitador));

		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+3));
		Length_F:=ASU.Length(Frase);
--	ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));

		-- Frase:193.147.0.72, Port:  1025
		P_Delimitador := ASU.Index(Frase,", Port:  ");
--	ATIO.Put_Line("poscion de un espacio: " & Integer'Image(P_Delimitador));

		IP := ASU.Head(Frase,P_Delimitador-1);
		--IP:193.147.0.72
		Length_F:=ASU.Length(Frase);
--	ATIO.Put_Line("longitud de la frase: " & Integer'Image(Length_F));

		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+8));
		--Frase:1025
		Puerto := Frase;
		--Puerto: 1025

	end Corto;

	EP:LLU.End_Point_Type;
	IP,Puerto:ASU.Unbounded_String;
	EP_ASU:ASU.Unbounded_String;
	--Palabra:ASU.Unbounded_String;
begin
	EP := LLU.Build ("193.147.72",1025);
	EP_ASU:=ASU.To_Unbounded_String(LLU.Image(EP));
	--Corto(EP_ASU,IP,Puerto,ASM.To_Set(""", "));
	Corto(EP_ASU,IP,Puerto);

	ATIO.Put_Line(ASU.To_String(IP));
	ATIO.Put_Line(ASU.To_String(Puerto));

	LLU.Finalize;

end trocear_ep;
