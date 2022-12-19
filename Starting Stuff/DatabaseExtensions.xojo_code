#tag Module
Protected Module DatabaseExtensions
	#tag Method, Flags = &h0
		Function UTF8StringValue(extends dbField as DatabaseField) As String
		  
		  // suggested by Christian Schmitz
		  
		  Dim s As String = dbField.StringValue
		  
		  If s.Encoding = Nil Then
		    If encodings.UTF8.IsValidData(s) Then
		      // mark as UTF-8
		      Return DefineEncoding( s, Encodings.UTF8 )
		    Else
		      // use a fallback encoding
		      Return DefineEncoding( s, encodings.ISOLatin1)
		    End If
		  Else
		    // make sure, we have UTF-8 and not UTF-16 or Windows encoding
		    Return ConvertEncoding(s, encodings.UTF8)
		  End If
		  
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
