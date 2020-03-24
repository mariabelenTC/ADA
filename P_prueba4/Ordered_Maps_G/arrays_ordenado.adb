with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure arrays_ordendo is
   package ATIO renames Ada.Text_IO;
   package ASU renames Ada.Strings.Unbounded;

   use type ASU.Unbounded_String;

   type Maps_clientes is array (1..10) of ASU.Unbounded_String;
   lista1:Maps_clientes;

   function Unbounded_H(W_ASU: ASU.Unbounded_String)  return Integer is
		Length_Word,N:natural;
		Word_String:String:=ASU.To_String(W_ASU);
	begin
		N:=0;
		Length_Word:=Word_String'Length;
		for k in 1 .. Length_Word loop
			N:=N+ Character'Pos(Word_String(K));
		end loop;
      return N;
		--ATIO.Put_Line(ASU.To_String(W_ASU) & " tamaño valor es: " & Integer'Image(N));
   end Unbounded_H;

   procedure Unbounded_H_uno(W_ASU: ASU.Unbounded_String) is
      Length_Word,N:natural;
      Word_String:String:=ASU.To_String(W_ASU);
   begin
      N:=0;
      Length_Word:=Word_String'Length;
      for k in 1 .. Length_Word loop
         N:=N+ Character'Pos(Word_String(K));
      end loop;

      ATIO.Put_Line(ASU.To_String(W_ASU) & " tamaño valor es: " & Integer'Image(N));
   end Unbounded_H_uno;

   procedure buscar( M:in out Maps_clientes;
                     Key:in ASU.Unbounded_String;
                     i:out Positive;
                     Found: out Boolean)  is
      i_medio:Natural:=1;
      i_inicial:Integer;
		i_final:Integer;
      Fin:Boolean;
      Menor:Boolean;
      M_Aux:Maps_clientes;
      Longitud:Integer:=5;
	begin
      i_inicial:=1;
		i_final:=Longitud;

      Found :=False;
      Fin:=False;
      Menor:=False;
      while not Found and not Fin loop
         I_Medio:= i_inicial + ((i_final-i_inicial)/2);
         if i_final < i_inicial then
            fin:=True;
            i:=i_final;
         end if;
         ATIO.Put_Line("El inicio es : " & Integer'Image(i_inicial));
         ATIO.Put_Line("El final es : " & Integer'Image(i_final));
         ATIO.Put_Line("El medio es : " & Integer'Image(i_medio));

         if M(i_medio)=Key then
              i:=i_medio;
              Found:=True;
      	elsif Key < M(i_medio) then
            i:=i_medio;
            i_final:= I_Medio-1;

            if i_final = 0 or i_medio=Longitud then
               Fin:=True;
            else
               i:=I_Medio;
            end if;
            ATIO.Put_Line(ASU.To_String(Key) & " es menor que: " & ASU.To_String(M(i_medio)));
            Menor:=True;
			else
            ATIO.Put_Line(ASU.To_String(Key) & " es mayor que: " & ASU.To_String(M(i_medio)));
				i_inicial:= I_Medio+1;
            if i_inicial > Longitud then
               Fin:=True;
            else
               i:=i_inicial + 1;
            end if;
			end if;

		end loop;


      --if not Found and Menor then
      --   ATIO.Put_Line("El medio es : " & Integer'Image(i_medio));
      --   M_Aux:=M;
      --   M_Aux(i):=key;
      --   for k in i.. Longitud loop
      --         M_Aux(i+1):=M(i);
      --         i:=i+1;
      --   end loop;
      --   M:=M_Aux;
      --end if;

      if  Found then
         ATIO.Put_Line("El medio es : " & Integer'Image(i_medio));
         M_Aux:=M;
         for k in i.. Longitud loop
               M_Aux(i):=M(i+1);
               i:=i+1;
         end loop;
         M:=M_Aux;
      end if;

   end buscar;




   procedure buscarYcopiar( M:in out Maps_clientes;
                     Key:in ASU.Unbounded_String;
                     i:out Positive;
                     Found: out Boolean)  is
      i_medio:Natural:=1;
      i_inicial:Integer;
		i_final:Integer;
      Fin:Boolean;
      Menor:Boolean;
      Ordenado:Boolean;
      Numero_de_casillas_del_menor_Al_final:Positive;
      Longitud:Integer:=3;
      M_Aux:Maps_clientes;

	begin
      i_inicial:=1;
		i_final:=Longitud;
      Menor:=False;
      Found :=False;
      Fin:=False;
      Ordenado:=False;

      while not Found and not Fin loop
         I_Medio:= i_inicial + ((i_final-i_inicial)/2);
         if i_final < i_inicial then
            fin:=True;
            i:=i_final;
         end if;
         ATIO.Put_Line("El inicio es : " & Integer'Image(i_inicial));
         ATIO.Put_Line("El final es : " & Integer'Image(i_final));
         ATIO.Put_Line("El medio es : " & Integer'Image(i_medio));

         if M(i_medio)=(Key) then
              i:=i_medio;
              Found:=True;
      	elsif Key < M(i_medio) then


            if i_final = 0 then
               Fin:=True;
            else
               i:=I_Medio;
               i_final:= I_Medio-1;
            end if;
            Menor:=True;

            ATIO.Put_Line(ASU.To_String(Key) & " es menor que: "
            & ASU.To_String(M(i_medio)) & " ::: " & Boolean'Image(Menor));

			else
            --i:=i_medio;

            if i_inicial >= Longitud then
               Fin:=True;
               i:=i_inicial;
               Menor:=False;
            else
               i_inicial:= I_Medio+1;
            end if;



            ATIO.Put_Line(ASU.To_String(Key) & " es mayor que: "
            & ASU.To_String(M(i_medio))& " ::: " & Boolean'Image(Menor));

			end if;
		end loop;


      --if not Found and Menor then
      --   ATIO.Put_Line("El inicio es : " & Integer'Image(i_inicial));
      --   ATIO.Put_Line("El final es : " & Integer'Image(i_final));
      --      ATIO.Put_Line("El medio es : " & Integer'Image(i_medio));
      --      M_Aux:=M;
      --      M_Aux(i):=key;
      --   for k in i.. Longitud loop
      --      --ATIO.Put_Line("resta: " & Integer'Image(i_final - i_inicial));
      --         ATIO.Put_Line("hhola");
      --         M_Aux(i+1):=M(i);
      --         i:=i+1;
      --   end loop;
      --
      --   M:=M_Aux;
      --end if;


   end buscarYcopiar;


   ------------------------------------------------------------------------------
   procedure Imprimir( M:in Maps_clientes) is
   begin
   	for K in 1..10 loop
   	     ATIO.Put_Line(Integer'Image(K) & " " & ASU.To_String(M(K)));
      end loop;
   end Imprimir;



   A,B,C,D,E,F,G,H,Y,J,K,L:ASU.Unbounded_String;
   i:Integer;
   Found:Boolean;
begin


   A:=ASU.To_Unbounded_String("Ana");
   B:=ASU.To_Unbounded_String("Cale");
   C:=ASU.To_Unbounded_String("Mana");
   D:=ASU.To_Unbounded_String("Sala");
   E:=ASU.To_Unbounded_String("Zala");
   F:=ASU.To_Unbounded_String("Tata");
   G:=ASU.To_Unbounded_String("Tate");
   H:=ASU.To_Unbounded_String("Palo");
   Y:=ASU.To_Unbounded_String("Belen");
   J:=ASU.To_Unbounded_String("Raton");
   K:=ASU.To_Unbounded_String("");



   L:=ASU.To_Unbounded_String("Cale");


   Unbounded_H_uno(A);
   Unbounded_H_uno(B);
   Unbounded_H_uno(C);
   Unbounded_H_uno(D);
   Unbounded_H_uno(E);
   Unbounded_H_uno(F);
   Unbounded_H_uno(G);
   Unbounded_H_uno(H);
   Unbounded_H_uno(Y);
   Unbounded_H_uno(J);
   --Unbounded_H_uno(K);
   Unbounded_H_uno(L);


   --lista1:=(1=>A,2=> B, 3=> C, 4=>D, 5=>E, 6=>F, 7=>G, 8=>H, 9=>Y, 10=>J);
   lista1:=(1=>A, 2=>B, 3=>H, 4=>J, 5=>G, others=>k);


   Imprimir(lista1);
   --
   buscar(lista1,L,i,Found);

   Imprimir(lista1);

   ATIO.Put_Line("Encontrado: " & Boolean'Image(Found));
   ATIO.Put_Line(Integer'Image(i));
   --
   --
   --desplazar(lista1,L,i);


end arrays_ordendo;
