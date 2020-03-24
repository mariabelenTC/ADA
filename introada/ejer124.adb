with Ada.Text_IO;

procedure ejer124 is
	package ATIO renames Ada.Text_IO;
	
	
	subtype Name_Type is String (1..10);
	subtype GPA_Type is Float range 0.0 .. 4.0;
	type Student_Rec is record
		First_Name: Name_Type;-- 10 bytes
		Last_Name: Name_Type;-- 10 Bytes
		ID: Positive; --4					-- el record Student_Rec
		GPA: GPA_Type;--4					-- ocupa 36 Bytes
		Current_Hours : Natural;--4
		Total_Hours: Natural;--4
	end record;  
	
	type List_Type is array (1 .. 10) of Student_Rec; -- 3600Bytes
	
	type List_Ptr is access List_Type;
	
	
	Student_List : List_Ptr; --6 Bytes.
	
	Cont_estudiantes: Integer;
	
		
begin 
	Cont_estudiantes:=0;
	
	Student_List:= new List_Type; -- 3600 bytes.
	
	Student_List(1).ID:= 1000; -- asigna 1000 al campo ID del primer estudiante.
	
	--o tmabien se puede hacer Student_List'Range--
	--Student_List.all'First .. Student_List.all'Last
	for I in Student_List'Range loop
	--loop 
		--Cont_Estudiantes:= Cont_estudiantes + 1;
		--ATIO.Put_Line(Integer'Image(Student_List(Cont_estudiantes).ID));
		ATIO.Put_Line(Integer'Image(Student_List(I).ID));
		
		
		--exit when Cont_estudiantes = 100;
	end loop;

	--PROBAR ESTOOOOO***********************************************************
	for I in loop
		Student_List.all(I).Total_Hours + Student_List.all(I).Current_Hours;
		Student_List.all(I).Current_Hours(otres=>0);
	end loop;
	
	
	
	
	ATIO.Put_Line("hola mundo");
	
	

end ejer124;
