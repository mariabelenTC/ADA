with Ada.Text_IO;

-- 		Esto es para explicar
--			la razón por la que vuelve a inicializarce a 0
--			cuando llega a su ulimo Valore=>>> Integer'Last



--================== NO TIENE MAS MISTERIO  ===============================00



procedure n_secuencia is
	package ATIO renames Ada.Text_IO;
	type Seq_N_T is mod Integer'Last;
	contador:Seq_N_T;

begin
	contador:=0;
	ATIO.Put_Line("contador:=Seq_N_T'Last=>  " & Seq_N_T'Image(contador));
	--contador:=Seq_N_T'Last -1 ;
	--ATIO.Put_Line("Seq_N_T'Last -1=> " & Seq_N_T'Image(contador));
	--contador:=Seq_N_T'Last -2 ;
	--ATIO.Put_Line("Seq_N_T'Last -2=>  " & Seq_N_T'Image(contador));
	--contador:=Seq_N_T'Last -1 ;
	--ATIO.Put_Line("Seq_N_T'Last -1=> " & Seq_N_T'Image(contador));


ATIO.Put_Line("hola empieza el contador");
	for k in 1 .. 5 loop

		ATIO.Put_Line(Seq_N_T'Image(contador));
		contador:=contador +1;
	end loop;


end n_secuencia;
