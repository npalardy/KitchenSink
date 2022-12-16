#tag Module
Protected Module Debug
	#tag Method, Flags = &h1
		Protected Sub Assert(condition As Boolean, message As String)
		  If condition = False Then
		    
		    #If DebugBuild Then
		      
		      Dim skipShowingMsgBox As Boolean
		      
		      // threaded ?
		      If (app.CurrentThread Is Nil) = False Then
		        skipShowingMsgBox = True
		      End If
		      
		      #If TargetMacOS
		        If skipShowingMsgBox = False Then
		          Try
		            Raise New nilobjectException
		          Catch noe As nilobjectexception
		            Dim s() As String = noe.Stack
		            For i As Integer = 0 To s.ubound
		              Dim eventName As String = NthField(s(i),".",2)
		              If eventName.StartsWith("Event_Paint%%o") Then
		                skipShowingMsgBox = True
		                Exit
		              End If
		            Next
		          End Try
		        End If
		      #EndIf
		      
		      
		      
		      If skipShowingMsgBox = False Then
		        MsgBox "Assertion failed" + EndOfLine + message
		      Else
		        System.Log System.LogLevelCritical, "Assertion failed " + EndOfLine + message
		      End If
		      
		      // now we can go see wtf caused the assertion in the debugger
		      // by walking the stack
		      Break 
		      
		    #Else
		      
		      System.Log System.LogLevelCritical, "Assertion failed " + EndOfLine + message
		      
		    #EndIf
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub init()
		  If m_Initialized = False Then
		    
		    #If DebugBuild 
		      m_logging = True
		    #Else
		      m_logging = False
		    #EndIf
		    
		    m_Initialized = True
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Log(msg as string)
		  init
		  
		  If m_logging Then
		    System.debuglog msg
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Logging(assigns b as boolean)
		  init
		  
		  m_logging = b
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_Initialized As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_logging As boolean = true
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
	#tag EndViewBehavior
End Module
#tag EndModule
