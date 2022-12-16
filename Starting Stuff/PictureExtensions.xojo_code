#tag Module
Protected Module PictureExtensions
	#tag Method, Flags = &h0
		Function TintWith(extends basePicture as picture, tintColor as Color) As Picture
		  // assumes you are passing an image that is a template
		  // basically JUST the alpha channel / mask is relevant
		  // and we can take that and punch in the tintcolor
		  
		  Dim tintedPicture As picture
		  
		  
		  If basePicture.ImageCount > 0 Then
		    Dim parts() As Picture
		    
		    For i As Integer = 0 To basePicture.ImageCount - 1
		      Dim thisElement As New picture(basePicture.IndexedImage(i).Width, basePicture.IndexedImage(i).Height)
		      thisElement.Graphics.ForeColor = tintColor
		      thisElement.Graphics.FillRect 0, 0, thisElement.Width, thisElement.Height
		      thisElement.ApplyMask basePicture.IndexedImage(i).CopyMask
		      
		      parts.Append thisElement
		    Next
		    tintedPicture = New picture(basePicture.Width, basePicture.Height, parts)
		  Else
		    break
		  End If
		  
		  Return tintedPicture
		  
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
