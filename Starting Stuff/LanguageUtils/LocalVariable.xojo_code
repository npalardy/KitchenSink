#tag Class
Protected Class LocalVariable
	#tag Method, Flags = &h0
		Sub Constructor(varName As String, varType As String, line As Integer)
		  name = varName
		  type = VarType
		  firstLine = line
		  
		  // quick and simple but wrong in many cases
		  If VarType.Right(2) = "()" Then
		    isarray = True
		  Else
		    
		    Dim tokens() As String = LanguageUtils.TokenizeLine(VarType)
		    // no token for type ? it cant be an array !
		    
		    If tokens.ubound > 0 Then
		      
		      Dim typeStr As String
		      Dim arrDimStr As String
		      Dim bracketCount As Integer
		      
		      Dim state As Integer 
		      
		      Const kSeekOpen = 0
		      Const kSeekClose = 1
		      
		      state = kSeekOpen
		      
		      // skip tokens until we get to (
		      // then look for matched ( ) and we retain only the commas
		      While tokens.ubound >= 0
		        
		        Select Case state
		          
		        Case kSeekOpen
		          
		          If tokens(0) = "(" Then
		            bracketCount = bracketCount + 1
		            arrDimStr = arrDimStr + tokens(0)
		            tokens.remove 0
		            state = kSeekClose
		          Else
		            typeStr = typeStr + tokens(0)
		            tokens.remove 0
		          End If
		          
		        Case kSeekClose
		          
		          If tokens(0) = "(" Then
		            
		            If bracketCount > 0 Then
		              arrDimStr = arrDimStr + tokens(0)
		            End If
		            
		            bracketCount = bracketCount + 1
		            tokens.remove 0
		            
		          ElseIf tokens(0) = ")" Then
		            
		            If bracketCount > 0 Then
		              arrDimStr = arrDimStr + tokens(0)
		            End If
		            
		            bracketCount = bracketCount - 1
		            tokens.remove 0
		            
		            If bracketCount = 0 Then
		              state = kSeekOpen
		            End If
		            
		          ElseIf tokens(0) = "," Then
		            
		            bounds = bounds + tokens(0)
		            arrDimStr = arrDimStr + tokens(0)
		            tokens.remove 0
		            
		          Else
		            
		            bounds = bounds + tokens(0)
		            
		            tokens.remove 0
		            
		          End If
		          
		        Else
		          
		        End Select
		        
		      Wend
		      
		      If arrDimStr <> "" Then
		        type = typeStr + arrDimStr
		        isarray = True
		      Else
		        type = typeStr
		        bounds = ""
		      End If
		      
		    End If
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub RunUnitTests()
		  // ones that should work
		  #If DebugBuild
		    
		    If True Then
		      Dim tmp As New LocalVariable("name", "integer", 1)
		      
		      LanguageUtils.DetailedErrorIf tmp.name <> "name", "local var not named right"
		      LanguageUtils.DetailedErrorIf tmp.type <> "integer", "local var type not right"
		    End If
		    
		    If True Then
		      Dim tmp As New LocalVariable("name", "integer()", 1)
		      
		      LanguageUtils.DetailedErrorIf tmp.name <> "name", "local var not named right"
		      LanguageUtils.DetailedErrorIf tmp.type <> "integer()", "local var type not right"
		      LanguageUtils.DetailedErrorIf tmp.isarray <> True, "local var not array"
		    End If
		    
		    If True Then
		      Dim tmp As New LocalVariable("name", "integer(,)", 1)
		      
		      LanguageUtils.DetailedErrorIf tmp.name <> "name", "local var not named right"
		      LanguageUtils.DetailedErrorIf tmp.type <> "integer(,)", "local var type not right"
		      LanguageUtils.DetailedErrorIf tmp.isarray <> True, "local var not array"
		      LanguageUtils.DetailedErrorIf tmp.bounds <> ",", "local var bounds wrong"
		      
		    End If
		    
		    If True Then
		      Dim tmp As New LocalVariable("name", "integer(-1,-1)", 1)
		      
		      LanguageUtils.DetailedErrorIf tmp.name <> "name", "local var not named right"
		      LanguageUtils.DetailedErrorIf tmp.type <> "integer(,)", "local var type not right"
		      LanguageUtils.DetailedErrorIf tmp.isarray <> True, "local var not array"
		      LanguageUtils.DetailedErrorIf tmp.bounds <> "-1,-1", "local var bounds wrong"
		    End If
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		bounds As string
	#tag EndProperty

	#tag Property, Flags = &h0
		default_value_str As string
	#tag EndProperty

	#tag Property, Flags = &h0
		firstLine As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		isarray As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		requiresNew As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		type As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="firstLine"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isarray"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="default_value_str"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bounds"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="requiresNew"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
