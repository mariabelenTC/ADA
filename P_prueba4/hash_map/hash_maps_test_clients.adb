with Ada.Text_IO;
With Ada.Strings.Unbounded;
with Lower_Layer_UDP;
with Ada.Calendar;
with Ada.Exceptions;
with Get_Image;
with Ada.Numerics.Discrete_Random;
with Hash_Maps_G;


procedure hash_maps_test_clients is
   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;
	package LLU renames Lower_Layer_UDP;
	package AC renames Ada.Calendar;
	package G renames Get_Image;

   HASH_SIZE:   constant := 10;

   type Hash_Range is mod HASH_SIZE;

	type Valores_T is record
		EP: llU.End_point_type;
		Hora : AC.Time;
	end record;

--____________________________________________________________________________--

	function Unbounded_Hash(W_ASU: ASU.Unbounded_String) return Hash_Range is
		Length_Word,N:natural;
		Word_String:String:=ASU.To_String(W_ASU);
	begin
		N:=0;
		Length_Word:=Word_String'Length;
		for k in 1 .. Length_Word loop
			N:=N+ Character'Pos(Word_String(K));
		end loop;
		return Hash_Range'Mod(N);
   end Unbounded_Hash;

--____________________________________________________________________________--

   package Active_Clients is new Hash_Maps_G(Key_Type   => ASU.Unbounded_String ,
			                                    Value_Type => Valores_T,
			                                    "="        => ASU."=",
			                                    Hash_Range => Hash_Range,
			                                    Hash =>Unbounded_Hash ,
															Max=> 11);
--____________________________________________________________________________--

	procedure Print_Map (M : Active_Clients.Map) is
		C: Active_Clients.Cursor := Active_Clients.First(M);
		IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;
		Client_Time:AC.Time;
		Nick:ASU.Unbounded_String;
	begin
		ATIO.Put ("ACTIVE CLIENTS");
		ATIO.Put_Line ("     Longitud de la tabla de símbolos: " &
							  Integer'Image(Active_Clients.Map_Length(M)));
		ATIO.Put_Line("================================================");
		ATIO.New_Line;

		while Active_Clients.Has_Element(C) loop
			EP_ASU:=ASU.To_Unbounded_String(LLU.Image(Active_Clients.Element(C).Value.EP));

			EP_Image:=G.Image_EP(EP_ASU);
			Client_Time:=Active_Clients.Element(C).Value.hora;

			ATIO.Put_Line (ASU.To_String(Active_Clients.Element(C).Key)
										& ASU.To_String(EP_Image) & " : " &
										G.Time_Image(Client_Time));
			Active_Clients.Next(C);
		end loop;

		ATIO.New_Line;
		ATIO.Put_Line("================================================");
	end Print_Map;

--____________________________________________________________________________--_________________________________________________________--


	Old_Nick,Nick1,Nick2,Nick3,Nick4:ASU.Unbounded_String;
	Cliente1,Cliente2,Cliente3,Cliente4:Valores_T;

	IP,Puerto,EP_Image,EP_ASU:ASU.Unbounded_String;

	Value,Old_datos_Client  : Valores_T;
	Success:Boolean;

   Clients:Active_Clients.Map;

begin

--==========================CLIENTES ACTIVOS==================================--
--============================================================================--

	Nick1:=ASU.To_Unbounded_String("Belen");
	Cliente1.EP:= LLU.Build ("193.147.71",8000);
	Cliente1.Hora:=AC.Clock;

	delay 1.0;
	Nick2:=ASU.To_Unbounded_String("Maria");
	Cliente2.EP:=LLU.Build ("193.147.72",9000);
	Cliente2.Hora:=AC.Clock;

	delay 1.0;
	Nick3:=ASU.To_Unbounded_String("Isa");
	Cliente3.EP:=LLU.Build ("193.147.73",10000);
	Cliente3.Hora:=AC.Clock;

	delay 1.0;
	Nick4:=ASU.To_Unbounded_String("Regui");
	Cliente4.EP:= LLU.Build ("193.147.60",9001);
	Cliente4.Hora:=AC.Clock;

--============================================================================--
--============================================================================--

   --__________________ First puts____________________________________________

		--Nick1: Belen
		--Nick2:Maria
		--Nick3:Isa
		--Nick4:Regui
			begin
			Active_Clients.Put(Clients,Nick1,Cliente1);
			Active_Clients.Put(Clients,Nick2,Cliente2);
			Active_Clients.Put(Clients,Nick3,Cliente3);
			Active_Clients.Put(Clients,Nick4,Cliente4);
			exception
				when Active_Clients.Full_Map=>
					ATIO.Put_Line("exception");
			end;

			--Print--
			ATIO.New_Line;
			Print_Map(Clients);


   -- ___________________Now deletes____________________________________________

			Active_Clients.Delete(Clients, Nick1, Success);
			Active_Clients.Delete(Clients, Nick2, Success);
			Active_Clients.Delete(Clients, Nick3, Success);
		--	Active_Clients.Delete(Clients, Nick4, Success);

			--Print--
			ATIO.New_Line;
			Print_Map(Clients);

   --______________________ Now gets____________________________________________

			Active_Clients.Get(Clients,Nick2,Value,Success);
			ATIO.Put_Line(Boolean'Image(Success));
			Active_Clients.Get(Clients,Nick4,Value,Success);
			ATIO.Put_Line(Boolean'Image(Success));


LLU.Finalize;

end hash_maps_test_clients;
