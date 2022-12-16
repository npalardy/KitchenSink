#tag Module
Protected Module ListBoxExtensions
	#tag Method, Flags = &h0
		Function LastRowIndex(extends lb as Listbox) As integer
		  return lb.ListCount - 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectFirstRowByTag(extends lb as Listbox, item as variant)
		  // note that IF the variant is an object then = will compare instances NOT calling operator_equal
		  
		  For i As Integer = 0 To lb.LastRowIndex
		    
		    If lb.rowtag(i) = item Then
		      lb.Selected(i) = True
		      Return
		    End If
		    
		  Next
		  
		  
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
End Module
#tag EndModule
