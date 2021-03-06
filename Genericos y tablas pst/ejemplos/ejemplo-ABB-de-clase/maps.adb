with Pantalla;

with Ada.Text_IO;
with Ada.Strings.Unbounded.Text_IO;

package body Maps is
   package ASUIO renames Ada.Strings.Unbounded.Text_IO;

   use type Asu.Unbounded_String;



   procedure Draw_Tree (P_Tree : Map;
                        Fila : Pantalla.T_Fila;
                        Columna : Pantalla.T_Columna;
                        Level : Integer) is
   begin

      if P_Tree /= null then
         if P_Tree.Left /= null then
            Draw_Tree (P_Tree.Left,
                       Fila + 3,
                       Columna - Pantalla.T_Columna'Last / ((abs(Level) + 1)*3),
                       -1*abs(Level) - 1);
         end if;

         Pantalla.Mover_Cursor (Fila,Columna);

         if Level < 0 then
            Ada.Text_IO.Put_Line ("          /");
         elsif Level > 0 then
            Ada.Text_IO.Put_Line ("\");
         end if;
         Pantalla.Mover_Cursor (Fila+1,Columna);

         Pantalla.Poner_Color (P_Tree.color);
         ASUIO.Put_Line (P_Tree.Key);
         Pantalla.Mover_Cursor (Fila+2,Columna);
         ASUIO.Put_Line (P_Tree.Value);
         Pantalla.Poner_Color (Pantalla.Blanco);

         if P_Tree.Right /= null then
            Draw_Tree (P_Tree.Right,
                       Fila + 3,
                       Columna + Pantalla.T_Columna'Last / ((abs(Level) +1)*3),
                       abs(Level) + 1);
         end if;
      end if;

   end Draw_Tree;


   P_Root : Map;

   procedure Draw_Tree is
   begin
      Draw_Tree (P_Root, 1, Pantalla.T_Columna'Last/2, 0);
   end Draw_Tree;

   procedure Draw_Tree (M : Map) is
   begin
      P_Root := M;
      Draw_Tree;
   end Draw_Tree;


   procedure Draw_Node (M: Map; Color: Pantalla.T_Color) is
      S: ASU.Unbounded_String;
   begin
      if M /= null then
         M.Color := Color;
         Draw_Tree;
         S := ASU.To_Unbounded_STring(Ada.Text_Io.Get_Line);
      end if;
   end Draw_Node;


   procedure Get (M       : Map;
                  Key     : in  ASU.Unbounded_String;
                  Value   : out ASU.Unbounded_String;
                  Success : out Boolean) is
   begin
      Value := ASU.Null_Unbounded_String;

      If M = null then
         Success := False;
      elsif M.Key = Key then
         Value := M.Value;
         Success := True;
      elsif Key > M.Key then
         Get (M.Right, Key, Value, Success);
      else
         Get (M.Left, Key, Value, Success);
      end if;
   end Get;




   procedure Put (M     : in out Map;
                  Key   : ASU.Unbounded_String;
                  Value : ASU.Unbounded_String) is
   begin

      if M = null then
         M := new Tree_Node'(Key, Value, null, null, Pantalla.Blanco);
      else
         if Key = M.Key then
            Draw_Node (M, Pantalla.Azul);
            M.Value := Value;
            Draw_Node (M, Pantalla.Blanco);
         elsif Key < M.Key then
            Put (M.Left, Key, Value);
         elsif Key > M.Key then
            Put (M.Right, Key, Value);
         end if;
      end if;
   end Put;


   function Min (M : Map) return Map is
   begin

      if M.Left = null then
         Draw_Node (M, Pantalla.Amarillo);
         return M;
      else
         return Min (M.Left);
      end if;

   end Min;


   function Delete_Min (M : Map)  return Map  is
      P_Aux: Map;
      P : Map;
   begin

      P_Aux := M;

      if P_Aux = null then
         return null;
      end if;

      if P_Aux.Left = null then
         Draw_Node (M, Pantalla.Rojo);
         P := P_Aux.Right;
         P_Aux := null; -- Hay que liberar memoria si no hay GC
         return P;
      else
         P_Aux.Left := Delete_Min (P_Aux.Left);
         return P_Aux;
      end if;

   end Delete_Min;


   procedure Delete (M       : in out Map;
                     Key     : in  Asu.Unbounded_String;
                     Success : out Boolean) is
      Min : Map;
      P_Aux : Map;
      P_Free : Map;
   begin
      Success := True;

      if M = null then
         Success := false;
         return;
      end if;

      if Key < M.Key and then M.Left /= null Then
         Delete (M.Left, Key, Success);
         return;
      end if;

      if Key > M.Key and then M.Right /= null then
         Delete (M.Right, Key, Success);
         return;
      end if;


      if M.Key = Key then
         if M.Left = null then
            Draw_Node (M, Pantalla.Rojo);
            P_Aux := M.Right;
            P_Free := M; -- Si no hay GC, liberar P_Free
            M := P_Aux;
         elsif M.Right = null then
            P_Aux := M.Left;
            Draw_Node (M, Pantalla.Rojo);
            P_Free := M; -- Si no hay GC, liberar P_Free
            M := P_Aux;
         else
            Draw_Node (M, Pantalla.Rojo);
            Min := Maps.Min (M.Right);
            if Min /= null then
               M.Key := Min.key;
               M.Value := Min.Value;
               Draw_Node (M, Pantalla.amarillo);
            end if;
            M.Right := Delete_Min (M.Right);

            M.Color := Pantalla.Blanco;

            return;
         end if;
      end if;

      return;

   end Delete;


   function Map_Length (M : Map) return Natural is
   begin
      if M /= null then
         return 1 + Map_Length (M.Left) + Map_Length (M.Right);
      else
         return 0;
      end if;
   end Map_Length;


   procedure Print_Tree (M : Map) is
   begin
      if M /= null then
         if M.Left /= null then
            Print_Tree (M.Left);
         end if;

         ASUIO.Put_Line ("(" & M.Key & ", " & M.Value & ")");


         if M.Right /= null then
            Print_Tree (M.Right);
         end if;
      end if;
   end Print_Tree;

   procedure Print_Map (M : Map) is
   begin
      Pantalla.Mover_Cursor (Pantalla.T_Fila'First+10, Pantalla.T_Columna'First);
      Ada.Text_Io.Put_Line ("Symbol Table");
      Ada.Text_Io.Put_Line ("============");

      Print_Tree (M);
   end Print_Map;






end Maps;
