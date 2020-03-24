with Ada.Text_IO;

procedure enumerados is 
package ATIO renames Ada.Text_IO;
type NombreMonedas is (rojo,bolo,mama,lupe);
--type Nombre is array (1..4) of NombreMonedas;
moneda:NombreMonedas;

begin
	moneda:=rojo;
	
	for k in 0..3 loop 
	moneda:=NombreMonedas'Val(K);
		ATIO.Put_Line(NombreMonedas'Image(moneda));
		
	end loop;

end enumerados;