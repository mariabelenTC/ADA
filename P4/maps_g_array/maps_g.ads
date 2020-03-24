with Ada.Calendar;
with Gnat.Calendar.Time_IO;

generic
	type Key_Type is private;
	type Value_Type is private;
	Max_Clients: in Natural;
	with function "=" (K1, K2: Key_Type) return Boolean;
package Maps_G is

   type Map is limited private;

   procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean);


   Full_Map : exception;
   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type);

   procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean);


   function Map_Length (M : Map) return Natural;

   --
   -- Cursor Interface for iterating over Map elements
   --
   type Cursor is limited private;
   function First (M: Map) return Cursor;
   procedure Next (C: in out Cursor);
   function Has_Element (C: Cursor) return Boolean;
   type Element_Type is record
      Key:   Key_Type;
      Value: Value_Type;
   end record;
   No_Element: exception;
   function Element (C: Cursor) return Element_Type;

private
   type Cell is record
		Key   : Key_Type;
		Value : Value_Type;
		Full: Boolean:= False;
   end record;

	type Cell_Array is array(1..Max_Clients) of Cell;

	type Cell_Array_A is access Cell_Array;

   type Map is record
      P_Array : Cell_Array_A:=new Cell_Array;
      Length  : Natural := 0;
   end record;

   type Cursor is record
		M: Map;
		pos: Integer;
		Valido:Boolean;
   end record;

end Maps_G;
