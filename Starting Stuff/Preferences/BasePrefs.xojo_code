#tag Class
Private Class BasePrefs
	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key as String) As Boolean
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String) As Boolean
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key As String) As Color
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key As String) As Date
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key As String) As DateTime
		  #Pragma unused key
		  
		  #Pragma TODO "Norm finish !"
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key As String) As Double
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key As String) As Integer
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key As String) As String
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key As String) As string()
		  #pragma unused key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  #pragma unused key
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteBoolean(key as string, value as Boolean)
		  #Pragma unused key
		  #pragma unused value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteColor(key as string, value as Color)
		  #Pragma unused key
		  #pragma unused value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDate(key as string, value as date)
		  #Pragma unused key
		  #pragma unused value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDateTime(key as string, value as dateTime)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #Pragma unused key
		  
		  #Pragma TODO "Norm finish !"
		  
		  Break
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDouble(key as string, value as Double)
		  #Pragma unused key
		  #Pragma unused value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInteger(key as string, value as integer)
		  #Pragma unused key
		  #pragma unused value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteString(key as string, value as String)
		  #Pragma unused key
		  #pragma unused value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStringArray(key as string, arr() as string)
		  #Pragma unused key
		  #Pragma unused arr
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
