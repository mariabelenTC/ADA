with Ada.Text_IO;

procedure ejer127 is
	package ATIO renames Ada.Text_IO;
	
	
	type Caracteres is access String;
	
	
	Texto: Caracteres:= new String'("hola a todos he de decirte amigos de pst");
	Letras: Caracteres:= new String'("alberto");	
 	Posicion:Integer;
 	
 	
	function Encontrar_Posicion_Letras(Texto: Caracteres; Palabra: Caracteres) return Integer is
		
		function Comparar_Letras_Iguales(Texto:Caracteres; Letras:Caracteres; Pos: Integer) return Boolean is
			N:Integer;
			Encontrado:Boolean;
		Begin
			N:=0;
			Encontrado:= True;
				
			for K in Pos..((Pos + Letras.all'Length)-1)loop
				N:= N+1;
			
				if Texto.all(K) /= Letras.all(N) then
				
					Encontrado:=False;
				
				end if;
				
				
			end loop;
			
			return Encontrado;
		end Comparar_Letras_Iguales;	
		
	
		function Posicion_Letras_Iguales (Texto: Caracteres;  Palabra: Caracteres; Pos:in out Integer) return Integer is
			
			Similares: Boolean;
		
		begin
			
			Similares:= False;
			loop
				Similares:= Texto.all(Pos) = Letras.all(1);
				
				Pos:= Pos +1;
				
				if Pos >= Texto.all'Length then
					Similares:=True;
					Pos:=1;
				end if;
					
				exit when Similares=True;
			end loop;
			
			return (Pos-1);	
			
		end Posicion_Letras_Iguales;
		
		
		
		Pos:Integer;
		Encontrado:Boolean;
	begin
		Pos:=1;
		loop
		
			Pos:=Posicion_Letras_Iguales(Texto,Letras,Pos);
			
			Encontrado:=True;
			
			if Pos/= 0 then
			
				Encontrado:= Comparar_Letras_Iguales(Texto, Letras, Pos);
		
			end if;
		
			Pos:= Pos +1;
			
			exit when Encontrado = True;
		end loop;
		return Pos-1;
	
	end Encontrar_Posicion_Letras;
		
	
begin

	
	ATIO.Put_Line("Hola Mundo");
	Posicion:=Encontrar_Posicion_Letras(Texto,Letras);
	ATIO.Put_Line("Hola Mundo2");
	ATIO.Put_Line(Integer'Image(Posicion));
end ejer127;
