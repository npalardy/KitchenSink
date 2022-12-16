#tag Module
Protected Module US
	#tag Method, Flags = &h1
		Protected Function backspc_key() As string
		  return &u08
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function del_key() As string
		  return &u7f
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function down_key() As string
		  
		  return &u1f
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function enter_key() As string
		  
		  return &u03
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function left_key() As string
		  return &u1c
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function return_key() As string
		  return &u0D
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function right_key() As string
		  return &u1d 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function tab_key() As string
		  return &u09
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function up_key() As string
		  return &u1e
		  
		End Function
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
End Module
#tag EndModule
