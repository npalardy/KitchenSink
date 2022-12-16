#tag Module
Protected Module EndOfLineExtensions
	#tag Method, Flags = &h0
		Function Length(extends e as EndOfLine) As integer
		  
		  Dim s As String = e
		  
		  Return s.length
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  #If DebugBuild
		    Dim Logger As debug.logger = CurrentMethodName
		    
		    if true then
		      Dim l As Integer = EndOfLine.Length
		      #If targetwindows
		        debug.Assert l = 2 , CurrentMethodName + " should have gotten 2"
		      #Else
		        debug.Assert l = 1 , CurrentMethodName + " should have gotten 1"
		      #EndIf
		      
		    End If
		    
		    if true then
		      Dim s As String = EndOfLine.ToString
		      #If targetwindows
		        debug.Assert s = ChrB(&h0D) + ChrB(&h0A) , CurrentMethodName + " should have gotten &h0D &hOA"
		      #Else
		        debug.Assert  s = ChrB(&h0A) , CurrentMethodName + " should have gotten &hOA"
		      #EndIf
		      
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(extends e as EndOfLine) As string
		  Dim s As String = e
		  return s
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
