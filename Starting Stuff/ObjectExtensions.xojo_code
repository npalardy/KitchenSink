#tag Module
Protected Module ObjectExtensions
	#tag Method, Flags = &h0
		Function PropertyByName(extends o as Object, propertyName as string) As introspection.propertyinfo
		  Dim typeInfo As Introspection.TypeInfo = Introspection.GetType( o )
		  
		  Dim propInfos() As Introspection.PropertyInfo = typeInfo.GetProperties
		  
		  For i As Integer = propInfos.Ubound DownTo 0
		    
		    If propInfos(i).Name = propertyName Then
		      
		      Return propInfos(i)
		      
		    End If
		    
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PropertyByName(extends o as Object, propertyName as string, assigns value as string)
		  If o Is Nil Then
		    Break
		    Return
		  End If
		  
		  Dim tinfo As Introspection.TypeInfo = Introspection.GetType(o)
		  
		  If tInfo Is Nil Then
		    Break
		    Return
		  End If
		  
		  Dim v As Variant = value
		  
		  Dim pInfoList() As Introspection.PropertyInfo = tinfo.GetProperties
		  
		  // we work backwards since most derived properties seem to be last in the list
		  For i As Integer = pInfoList.LastIndex DownTo 0
		    
		    If pInfoList(i).Name = propertyName Then
		      pInfoList(i).Value(o) = v
		      Exit
		    End If
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  Dim Logger As debug.logger = CurrentMethodName
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
