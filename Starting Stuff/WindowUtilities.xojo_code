#tag Module
Protected Module WindowUtilities
	#tag Method, Flags = &h1
		Protected Function FindAllWindowsOfType(type as Introspection.TypeInfo) As Window()
		  // calling this method
		  // 
		  // use a form like
		  //    Dim w As Window = WindowUtilities.FindFirstWindowOfType( GetTypeInfo( <name of window class> ) )
		  //
		  // where <name of window class> is the class name of window(s) to locate
		  
		  Dim foundWindows() As Window
		  
		  For i As Integer = 0 To WindowCount - 1
		    
		    Dim thisWindowTypeInfo As Introspection.TypeInfo = Introspection.GetType( Window(i) )
		    
		    If thisWindowTypeInfo.FullName = type.FullName Then
		      foundWindows.Append Window(i)
		    End If
		    
		  Next
		  
		  Return foundWindows
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindFirstWindowOfType(type as Introspection.TypeInfo) As Window
		  // calling this method
		  // 
		  // use a form like
		  //    Dim w As Window = WindowUtilities.FindFirstWindowOfType( GetTypeInfo( <name of window class> ) )
		  //
		  // where <name of window class> is the class name of window(s) to locate
		  
		  For i As Integer = 0 To WindowCount - 1
		    
		    Dim thisWindowTypeInfo As Introspection.TypeInfo = Introspection.GetType( Window(i) )
		    
		    If thisWindowTypeInfo.FullName = type.FullName Then
		      Return Window(i)
		    End If
		    
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindFirstWindowOfType(w as Window) As Window
		  // calling this method
		  // 
		  // use a form like
		  //    Dim w As Window = WindowUtilities.FindFirstWindowOfType( <name of window class> ) 
		  //
		  // where <name of window class> is the class name of window(s) to locate
		  
		  // note this style ONLY works if the windo has implicit instance set to TRUE !!!!!!!!!!!
		  // other wise yuou get a weird error like
		  // 
		  // Expected a value Of type Class Window, but found a Static Namespace reference To Class ..........
		  
		  Return WindowUtilities.FindFirstWindowOfType( Introspection.GetType( w ) )
		  
		  
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
