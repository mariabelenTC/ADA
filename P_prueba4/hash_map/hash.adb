with Ada.Text_IO;
With Ada.Strings.Unbounded;

procedure Hash is
   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;

	HASH_SIZE:   constant :=10;

	type Hash_Range is mod HASH_SIZE;


   function Unbounded_Hash (W_ASU: ASU.Unbounded_String) return Hash_Range is
		Length_Word,N:natural;
		Word_String:String:=ASU.To_String(W_ASU);
	begin
		N:=0;
		Length_Word:=Word_String'Length;
		ATIO.Put_Line(Natural'Image(Length_Word));
		for k in 1 .. Length_Word loop
			N:=N+ Character'Pos(Word_String(K));

			ATIO.Put_Line(Word_String(K) & Natural'Image(Character'Pos(Word_String(K))));

		end loop;
			ATIO.Put_Line(Natural'Image(N));
      return Hash_Range'Mod(N);
   end Unbounded_Hash ;

	function String_Hash(Word: in String ) return Hash_Range is
		Length_Word,N:natural;
	begin
		N:=0;
		Length_Word:=Word'Length;
		ATIO.Put_Line(Natural'Image(Length_Word));
		for k in 1 .. Length_Word loop
			N:=N+ Character'Pos(Word(K));

			ATIO.Put_Line(Word(K) & Natural'Image(Character'Pos(Word(K))));

		end loop;
			ATIO.Put_Line(Natural'Image(N));
		return Hash_Range'Mod(N);
	end String_Hash;
	--AS:ASU.Unbounded_String;
	AS:String:=ATIO.Get_Line;
	R:Hash_Range;
begin
	--AS:=ASU.To_Unbounded_String(ATIO.Get_Line);


	--R:=Unbounded_Hash (AS);
	R:= String_Hash(AS);
	ATIO.Put_Line(Hash_Range'Image(R));

end Hash;
