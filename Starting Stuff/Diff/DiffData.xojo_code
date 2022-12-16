#tag Class
Private Class DiffData
	#tag Method, Flags = &h0
		Sub Constructor(initData() as integer)
		  For i As Integer = 0 To initData.Ubound
		    data.append initData(i)
		  Next
		  
		  Length = initData.Ubound+1
		  
		  Redim modified(Length + 2)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Data() As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Length As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified() As boolean
	#tag EndProperty


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
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
