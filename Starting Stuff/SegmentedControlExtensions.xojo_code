#tag Module
Protected Module SegmentedControlExtensions
	#tag Method, Flags = &h0
		Sub DeselectAllSegments(extends segmented as SegmentedControl)
		  // deselects all segments
		  For i As Integer = 0 To segmented.Items.UBound
		    
		    Dim thisItem As SegmentedControlItem = segmented.Items(i)
		    thisItem.Selected = False
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindItemWithTitle(extends segmented as SegmentedControl, title as string) As SegmentedControlItem
		  // finds & returns the FIRST segment with the given title
		  Dim foundSegment As SegmentedControlItem
		  
		  For i As Integer = 0 To segmented.Items.UBound
		    Dim thisItem As SegmentedControlItem = segmented.Items(i)
		    If thisItem.Title = title Then
		      foundSegment = thisItem
		      exit
		    End If
		  Next
		  
		  Return foundSegment
		  
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
