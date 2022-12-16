#tag Module
Protected Module EmbeddedWindowControlExtensions
	#tag Method, Flags = &h0
		Function Container(extends ctrl as EmbeddedWindowControl) As ContainerControl
		  Dim handleToFind As Integer = ctrl.Handle
		  
		  If handleToFind = 0 Then
		    Return Nil
		  End If
		  
		  // ok we have the handle for this EWC 
		  // so find the matching ContainerControl
		  
		  Dim iter As Runtime.ObjectIterator = Runtime.IterateObjects
		  While iter.MoveNext
		    If iter.Current IsA ContainerControl Then
		      Dim tInfo As Introspection.TypeInfo = Introspection.GetType(iter.Current)
		      Dim pInfo() As Introspection.PropertyInfo = tInfo.GetProperties
		      For Each propInfo As Introspection.PropertyInfo In pInfo
		        If propInfo.Name = "handle" And propInfo.Value(iter.Current) = handleToFind Then
		          Return ContainerControl(iter.Current)
		        End If
		      Next
		      
		    End If
		    
		  Wend
		  
		  Return Nil
		  
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
