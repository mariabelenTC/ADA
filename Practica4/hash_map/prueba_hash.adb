with Ada.Text_IO;
With Ada.Strings.Unbounded;
with Ada.Numerics.Discrete_Random;
with Hash_Maps_G;


procedure Prueba_Hash is
   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;

   HASH_SIZE:   constant := 10;

   type Hash_Range is mod HASH_SIZE;

   function Natural_Hash (N: Natural) return Hash_Range is
   begin
      return Hash_Range'Mod(N);
   end Natural_Hash;


   package Maps is new Hash_Maps_G (Key_Type   => Natural,
                                    Value_Type => Natural,
                                    "="        => "=",
                                    Hash_Range => Hash_Range,
                                    Hash => Natural_Hash,
									Max =>  30);


   procedure Do_Put (M: in out Maps.Map; K: Natural; V: Natural) is
   begin
      Ada.Text_IO.New_Line;
      ATIO.Put_Line("Putting" & Natural'Image(K));
      Maps.Put (M, K, V);
--      Print_Map(M);
   exception
      when Maps.Full_Map =>
         Ada.Text_IO.Put_Line("Full_Map");
   end Do_Put;

   A_Map : Maps.Map;
	N_Ejemplo: Natural;
	Success: Boolean;

begin

   -- First puts
	Do_Put (A_Map, 10, 10);            
	Do_Put (A_Map, 20, 20);


	Maps.Get(A_Map, 20, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;


	Ada.Text_IO.Put_Line(Natural'Image(Maps.Map_Length(A_Map)));

	Do_Put (A_Map, 11, 11);
	Do_Put (A_Map, 30, 30);
	Do_Put (A_Map, 21, 21);
	Do_Put (A_Map, 15, 15);
	Do_Put (A_Map, 16, 16);
	Do_Put (A_Map, 40, 40);
	Do_Put (A_Map, 25, 25);
	Do_Put (A_Map, 50, 50);

	Ada.Text_IO.Put_Line("------------------------------------------------------------------------");

	Maps.Get(A_Map, 20, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;

	Maps.Delete(A_Map, 16, Success);
	Maps.Get(A_Map, 16, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;

	Maps.Get(A_Map, 50, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;


	Maps.Delete(A_Map, 20, Success);
	Maps.Get(A_Map, 20, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;


	Maps.Get(A_Map, 40, N_Ejemplo, Success);
	if (Success) then
		Ada.Text_IO.Put_Line(Natural'Image(N_Ejemplo));
	end if;

	Ada.Text_IO.Put_Line(Natural'Image(Maps.Map_Length(A_Map)));

end Prueba_Hash;
