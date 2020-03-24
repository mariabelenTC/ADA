with Ada.Text_IO;

procedure ejer9 is
	package ATIO renames Ada.Text_IO;
	
	--para poder utilizar integer y float necesito transformarlos
	-- de integer a float:  Integer(Purple);
	-- de float a integer:FLoat(Straw);
	
	
	Color, Lime, Straw, Yellow, Red, Orange : Integer;
	Black, White, Green, Blue, Purple, Crayon : Float;

	

begin
	ATIO.Put_Line("operaciones con integer y float");
	Color  := 2;
	Black  :=2.5;
	Crayon :=-1.3;
	Straw  :=1;
	Red    :=3;
	Purple :=0.3E1;
	
	
	-- los de tipo Float--
	White := Crayon * 2.5 / Purple;
	ATIO.Put_Line(Float'Image(White));
	
	Green := Black / Purple;
	ATIO.Put_Line(Float'Image(Green));
	
	Purple := Float(Straw) / Float(Red * Color);
	ATIO.Put_Line(Float'Image(Purple));
	
	-- los de tipo Integer-- 
	Orange := Color / Red;
	ATIO.Put_Line(Integer'Image(orange));
	
	Orange := (Color + Straw) / (2*Straw);
	
	ATIO.Put_Line(Integer'Image(orange));
	Lime := Red / Color + Red rem Color;
	ATIO.Put_Line(Integer'Image(Lime));
	
	
	
	
	
	
	
	
	
	
	


end ejer9;

