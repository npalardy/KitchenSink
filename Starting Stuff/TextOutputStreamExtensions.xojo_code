#tag Module
Protected Module TextOutputStreamExtensions
	#tag Method, Flags = &h0
		Sub IndentLine(extends tos as TextOutputStream, indentLevel as integer, line as String)
		  tos.WriteLine IndentSpacing(indentLevel) + line
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IndentSpacing(count as integer) As string
		  Const kStdIndent = "    "
		  
		  Dim tmp() As String
		  
		  For i As Integer = 1 To count
		    tmp.Append kStdIndent
		  Next
		  
		  Return Join(tmp,"")
		  
		End Function
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
