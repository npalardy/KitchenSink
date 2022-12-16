#tag Class
Protected Class ProperTextInputStream
	#tag Method, Flags = &h0
		Shared Function Create(f as folderitem, convertLineEndings as boolean = true) As ProperTextInputStream
		  Dim stream As New ProperTextInputStream
		  
		  stream.m_InputStream = BinaryStream.Create(f)
		  stream.m_ConvertLineEndings = convertLineEndings
		  stream.m_Encoding = Encodings.UTF8
		  
		  stream.m_OriginalFolderitem = f
		  
		  Return stream
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub FillBufferWithLines()
		  Const kChunkSize = 630 // 64 * 1024 * 1024
		  
		  While m_InputStream.EndOfFile <> true
		    
		    m_buffer = m_buffer + m_InputStream.Read( kChunkSize ).DefineEncoding( m_Encoding )
		    
		    If m_ConvertLineEndings Then
		      m_buffer = m_buffer.ReplaceLineEndings( EndOfLine )
		    End If
		    
		    If m_buffer.IndexOf(EndOfLine) >= 0 Then
		      Exit While
		    End If
		    
		  Wend
		  
		  // ok now split off as many lines as we can
		  If m_buffer.Length > 0 Then
		    
		    // find the last eol
		    Dim lastEOL As Integer = -1
		    For i As Integer = m_buffer.Length DownTo 0
		      If m_buffer.Middle(i,1) = EndOfLine Then
		        lastEOL = i
		        Exit For
		      End If
		    Next
		    
		    // and split everything up to there
		    If lastEOL >= 0 Then
		      // account for the fact that EOL might be one ot two bytes
		      Dim eol As String = EndOfLine
		      
		      // get the chunbk we're going to split apart
		      Dim tmp As String = m_buffer.Left(lastEOL-eol.Length)
		      
		      // shrink the remainder
		      m_buffer = m_buffer.Middle(lastEOL + eol.Length)
		      
		      // add al lthe lines
		      Dim lines() As String = tmp.Split(EndOfLine)
		      For i As Integer = 0 To lines.LastIndex
		        m_lines.append lines(i)
		      Next
		      
		    Else
		      m_lines.Append m_buffer
		      m_buffer = ""
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(f as folderitem, convertLineEndings as boolean = true) As ProperTextInputStream
		  Dim stream As New ProperTextInputStream
		  
		  stream.m_InputStream = BinaryStream.Open(f)
		  stream.m_ConvertLineEndings = convertLineEndings
		  stream.m_Encoding = Encodings.UTF8
		  
		  stream.m_OriginalFolderitem = f
		  
		  Return stream
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadLine() As string
		  m_hasRead = True
		  
		  // see if our internal buffer still has another line (with conversion of line endings if necessary)
		  If m_lines.Count <= 0 Then
		    FillBufferWithLines()
		  End If
		  
		  If m_Lines.Count <= 0 Then
		    Return ""
		  Else
		    Dim tmp As String= m_Lines(0)
		    m_Lines.RemoveRowAt(0)
		    Return tmp
		  End If
		  
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_Encoding
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If m_hasRead = False Then
			    m_Encoding = value
			  End If
			  
			End Set
		#tag EndSetter
		Encoding As TextEncoding
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_InputStream.EndOfFile = True And m_lines.Count <= 0
			  
			End Get
		#tag EndGetter
		EndOfFile As boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_OriginalFolderitem
			End Get
		#tag EndGetter
		Folderitem As FolderItem
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected m_buffer As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_ConvertLineEndings As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Encoding As TextEncoding
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_hasRead As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_InputStream As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_lines() As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_OriginalFolderitem As FolderItem
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
		#tag ViewProperty
			Name="EndOfFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
