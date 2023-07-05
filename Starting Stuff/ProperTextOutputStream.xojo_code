#tag Class
Protected Class ProperTextOutputStream
	#tag Method, Flags = &h0
		Shared Function Append(f as FolderItem, encoding as textencoding = nil) As ProperTextOutputStream
		  If f <> Nil And f.Directory Then
		    Return Nil
		  End If
		  
		  Dim tos As New ProperTextOutputStream
		  
		  tos.m_encoding = Encoding
		  
		  tos.LastErrorCode = NoError
		  
		  Try
		    tos.m_backingstream = BinaryStream.Open(f, true) 
		    
		    tos.m_backingstream.LittleEndian = False
		    
		    tos.m_backingstream.Position = tos.m_backingstream.Length + 1
		    
		  Catch iox As IOException
		    
		    tos.m_backingstream = Nil
		    
		    tos.LastErrorCode = iox.ErrorNumber
		    
		  End Try
		  
		  return tos
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  
		  m_backingstream.close
		  m_backingstream = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Create(f as FolderItem, encoding as textencoding = nil) As ProperTextOutputStream
		  If f <> Nil And f.Directory Then
		    Return Nil
		  End If
		  
		  Dim tos As New ProperTextOutputStream
		  
		  tos.m_encoding = Encoding
		  
		  tos.LastErrorCode = NoError
		  
		  Try
		    If f.exists Then
		      tos.m_backingstream = BinaryStream.Open(f, True) 
		    Else
		      tos.m_backingstream = BinaryStream.Create(f, True) 
		    End If
		    
		    tos.m_backingstream.LittleEndian = False
		    
		    tos.m_backingstream.Length = 0
		    
		    tos.m_backingstream.Position = 0
		    
		  Catch iox As IOException
		    
		    tos.m_backingstream = Nil
		    
		    tos.LastErrorCode = iox.ErrorNumber
		    
		  End Try
		  
		  Return tos 
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Flush()
		  
		  m_backingstream = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush()
		  
		  m_backingstream.Flush
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub InternalWrite(data as string)
		  LastErrorCode = NoError
		  
		  If m_backingstream Is Nil Then
		    LastErrorCode = StreamNotOpen
		    Return
		  End If
		  
		  Try
		    m_backingstream.Write(data)
		  Catch iox As IOException
		    LastErrorCode = iox.ErrorNumber
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(data As String)
		  
		  If m_encoding Is Nil Then
		    
		    InternalWrite(data)
		    
		  Else
		    
		    If data.Encoding Is Nil Then
		      
		      InternalWrite(data)
		      
		    Else
		      
		      InternalWrite(ConvertEncoding(data, m_Encoding))
		      
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WriteError() As boolean
		  return LastErrorCode = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteLine(Text as String)
		  
		  If m_encoding Is Nil Then
		    
		    InternalWrite(Text)
		    InternalWrite(Delimiter)
		    
		  Else
		    
		    If Text.Encoding Is Nil Then
		      
		      InternalWrite(Text)
		      InternalWrite(Delimiter)
		      
		    Else
		      
		      InternalWrite(ConvertEncoding(Text, m_Encoding))
		      InternalWrite(Delimiter)
		      
		    End If
		    
		  End If
		  
		  Flush()
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		#tag Note
			The character used to mark the end of a line of text written to the file. The OS default for EndOfLine is used.
		#tag EndNote
		Delimiter As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_Encoding
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  m_Encoding = value
			End Set
		#tag EndSetter
		Encoding As TextEncoding
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Reports the last file I/O error. Error numbers are given as original file system error codes.
		#tag EndNote
		LastErrorCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_backingstream As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Encoding As TextEncoding
	#tag EndProperty


	#tag Constant, Name = AccessDenied, Type = Double, Dynamic = False, Default = \"102", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = DestDoesNotExistError, Type = Double, Dynamic = False, Default = \"100", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FileInUse, Type = Double, Dynamic = False, Default = \"104", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FileNotFound, Type = Double, Dynamic = False, Default = \"101", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = InvalidName, Type = Double, Dynamic = False, Default = \"105", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = NoError, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = NotEnoughMemory, Type = Double, Dynamic = False, Default = \"103", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StreamNotOpen, Type = Double, Dynamic = False, Default = \"106", Scope = Protected
	#tag EndConstant


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
			Name="Delimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
