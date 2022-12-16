#tag Module
Protected Module IntrospectionExtensions
	#tag Method, Flags = &h0
		Function Signature(extends mInfo as Introspection.MethodInfo) As string
		  // craft a "signature" that is
		  //   name([parameter TYPEs comma separated)
		  // return type is NOT considered
		  // an "array of X" will be represented as X()
		  Dim parts() As String
		  
		  parts.Append mInfo.Name
		  parts.append "("
		  
		  Dim params() As Introspection.ParameterInfo = mInfo.GetParameters
		  For i As Integer = 0 To params.LastIndex
		    Dim p As Introspection.ParameterInfo = params(i)
		    If i > 0 Then
		      parts.append ","
		    End If
		    
		    parts.append p.ParameterType.Fullname 
		    
		  Next
		  
		  parts.append ")"
		  
		  Return Join(parts,"")
		  
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
