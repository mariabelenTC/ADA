
package body Get_Image is
--------------------------------------------------------------------------------
	function Time_Image(T: AC.Time) return String is
	begin
		return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
	end Time_Image;
--------------------------------------------------------------------------------
	procedure Trocear_EP(EP_Image:in ASU.Unbounded_String;
									IP,Puerto: out ASU.Unbounded_String) is
		P_Delimitador:Integer;
		Length_F:Natural;
		Frase:ASU.Unbounded_String;
	begin
		Frase:=EP_Image;
		Length_F:=ASU.Length(Frase);
		P_Delimitador:= ASU.Index(Frase,"IP: ");
		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+3));
		Length_F:=ASU.Length(Frase);
		P_Delimitador := ASU.Index(Frase,", Port:  ");
		IP := ASU.Head(Frase,P_Delimitador-1);
		Length_F:=ASU.Length(Frase);
		Frase := ASU.Tail(Frase,Length_F-(P_Delimitador+8));
		Puerto := Frase;
	end Trocear_EP;
--------------------------------------------------------------------------------
	function Image_EP(EP_Image: in ASU.Unbounded_String) return ASU.Unbounded_String is
		Image:ASU.Unbounded_String;
		IP,Puerto:ASU.Unbounded_String;
	begin
		Trocear_EP(EP_Image,IP,Puerto);
		Image:=ASU.To_Unbounded_String(" (" & ASU.To_String(IP) & ":"
							& ASU.To_String(Puerto) & ")");
		return Image;
	end Image_EP;
-----------------------------------------------------------------------------

end Get_Image;
