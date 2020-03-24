with Ada.Calendar;
with Gnat.Calendar.Time_IO;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

package Get_Image is
	package AC renames Ada.Calendar;
	package ASU renames Ada.Strings.Unbounded;

	function Time_Image(T: AC.Time) return String;

	procedure Trocear_EP(EP_Image:in ASU.Unbounded_String;
									IP:out ASU.Unbounded_String;
									Puerto: out ASU.Unbounded_String);

	function Image_EP(EP_Image: in ASU.Unbounded_String) return ASU.Unbounded_String;


end Get_Image;
