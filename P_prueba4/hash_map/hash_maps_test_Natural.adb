with Ada.Text_IO;
With Ada.Strings.Unbounded;
with Ada.Numerics.Discrete_Random;
with Hash_Maps_G;


procedure Hash_Maps_Test_Natural is
   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;

   HASH_SIZE:   constant := 10;

   type Hash_Range is mod HASH_SIZE;

--____________________________________________________________________________--

	--function Unbounded_Hash(W_ASU: ASU.Unbounded_String) return Hash_Range is
	--	Length_Word,N:natural;
	--	Word_String:String:=ASU.To_String(W_ASU);
	--begin
	--	N:=0;
	--	Length_Word:=Word_String'Length;
	--	ATIO.Put_Line(Natural'Image(Length_Word));
	--	for k in 1 .. Length_Word loop
	--		N:=N+ Character'Pos(Word_String(K));
	--		ATIO.Put_Line(Word_String(K) & Natural'Image(Character'Pos(Word_String(K))));
	--
	--	end loop;
	--
	--	return Hash_Range'Mod(N);
   --end Unbounded_Hash;

	function Natural_Hash (N: Natural) return Hash_Range is
   begin
      return Hash_Range'Mod(N);
   end Natural_Hash;
--____________________________________________________________________________--

   package Maps is new Hash_Maps_G (Key_Type   => Natural,
                                    Value_Type => Natural,
                                    "="        => "=",
                                    Hash_Range => Hash_Range,
                                    Hash =>Natural_Hash ,
												Max=> 11);
--____________________________________________________________________________--

   procedure Print_Map (M : Maps.Map) is
      C: Maps.Cursor := Maps.First(M);
   begin
      ATIO.Put_Line ("Map");
      ATIO.Put_Line ("===");

      while Maps.Has_Element(C) loop
			begin
	         ATIO.Put_Line (Natural'Image(Maps.Element(C).Key) & " " &
	                               Natural'Image(Maps.Element(C).Value));
			exception
				when Maps.No_Element =>
					ATIO.Put_Line("no hay elemento");
			end;

         Maps.Next(C);
      end loop;
   end Print_Map;

--____________________________________________________________________________--

   procedure Do_Put (M: in out Maps.Map; K: Natural; V: Natural) is
   begin
      ATIO.New_Line;
      ATIO.Put_Line("Putting" & Natural'Image(K));
      Maps.Put (M, K, V);
      Print_Map(M);
   exception
      when Maps.Full_Map =>
         ATIO.Put_Line("Full_Map");
   end Do_Put;

--____________________________________________________________________________--

   procedure Do_Get (M: in out Maps.Map; K: Natural) is
      V: Natural;
      Success: Boolean;
   begin
      ATIO.New_Line;
      ATIO.Put_Line("Getting" & Natural'Image(K));
      Maps.Get (M, K, V, Success);
      if Success then
         ATIO.Put_Line("Value:" & Natural'Image(V));
         Print_Map(M);
      else
         ATIO.Put_Line("Element not found!");
      end if;
   end Do_Get;

--____________________________________________________________________________--

	--
	--
   procedure Do_Delete (M: in out Maps.Map; K: Natural) is
      Success: Boolean;
   begin
      ATIO.New_Line;
      ATIO.Put_Line("Deleting" & Natural'Image(K));
      Maps.Delete (M, K, Success);
      if Success then
         Print_Map(M);
      else
         ATIO.Put_Line("Element not found!");
      end if;
   end Do_Delete;



   A_Map : Maps.Map;

begin

   -- First puts
   Do_Put (A_Map, 10, 10);
   Do_Put (A_Map, 20, 20);
   Do_Put (A_Map, 11, 11);
   Do_Put (A_Map, 30, 30);
   Do_Put (A_Map, 21, 21);
   Do_Put (A_Map, 15, 15);
   Do_Put (A_Map, 16, 16);
   Do_Put (A_Map, 40, 40);
   Do_Put (A_Map, 25, 25);
   Do_Put (A_Map, 50, 50);

   -- Now deletes
   Do_Delete (A_Map, 11);
   Do_Delete (A_Map, 15);

   Do_Delete (A_Map, 25);
	--
   ---- Now gets
   Do_Get (A_Map, 21);
   Do_Get (A_Map, 40);
   Do_Get (A_Map, 50);

end Hash_Maps_Test_Natural;
