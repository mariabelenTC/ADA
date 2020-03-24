with Ada.Text_IO;
with Client_Collections;
with Ada.Strings.Unbounded;
with Lower_Layer_UDP;


procedure client_collections_test is
	package ATIO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	package CC renames Client_Collections;
	package LLU renames Lower_Layer_UDP;

	Lista_Clientes_Escritores: CC.Collection_Type;
	Lista_Clientes_Lectores:CC.Collection_Type;

	EP,EP_2,EP_3,EP_4:LLU.End_Point_Type;
	Nick:ASU.Unbounded_String;
	Total_Clientes:Natural;
	--Usuarios:ASU.Unbounded_String;
	Lista_Usuarios:ASU.Unbounded_String;
begin
	EP := LLU.Build ("193.147.72",8000);
	EP_2:=LLU.Build ("193.147.72",9000);
	EP_3:=LLU.Build ("193.147.72",10000);
	EP_4:=LLU.Build ("193.147.72",11000);

	CC.Add_Client(Lista_Clientes_Escritores,EP, ASU.To_Unbounded_String("Ana"), True);
	CC.Add_Client(Lista_Clientes_Escritores,EP_2, ASU.To_Unbounded_String("gema"), True);
	CC.Add_Client(Lista_Clientes_Escritores,EP_4, ASU.To_Unbounded_String("anchoa"), True);
	CC.Add_Client(Lista_Clientes_Escritores,EP_3, ASU.To_Unbounded_String("Ana"), True);

	CC.Add_Client(Lista_Clientes_Lectores,EP, ASU.To_Unbounded_String("reader"), False);
	CC.Add_Client(Lista_Clientes_Lectores,EP_2, ASU.To_Unbounded_String("reader"), False);
	CC.Add_Client(Lista_Clientes_Lectores,EP_3, ASU.To_Unbounded_String("reader"), False);
	CC.Add_Client(Lista_Clientes_Lectores,EP_4, ASU.To_Unbounded_String("reader"), False);

	--CC.Print_All(Lista_Clientes_Escritores);
	Total_Clientes:=CC.Total(Lista_Clientes_Escritores);
	ATIO.Put_Line("Numero total de clientes escritores: " & Natural'Image(Total_Clientes));

	--CC.Print_All(Lista_Clientes_Lectores);
	Lista_Usuarios:=ASU.To_Unbounded_String(CC.Collection_Image(Lista_Clientes_Escritores));
	ATIO.Put_Line(ASU.To_String(Lista_Usuarios));

	Nick:=CC.Search_Client (Lista_Clientes_Escritores,EP_4);
	ATIO.Put_Line(ASU.To_String(Nick) & " EP_4");

	CC.Delete_Client (Lista_Clientes_Escritores,ASU.To_Unbounded_String("gema"));
	--CC.Print_All(Lista_Clientes_Escritores);

	Total_Clientes:=CC.Total(Lista_Clientes_Escritores);
	ATIO.Put_Line("Numero total de clientes escritores: " & Natural'Image(Total_Clientes));


--	Usuarios:=ASU.To_Unbounded_String(CC.Collection_Image(Lista_Clientes_Escritores));
--	ATIO.Put_Line(ASU.To_String(usuarios));

	LLU.Finalize;
end client_collections_test;
