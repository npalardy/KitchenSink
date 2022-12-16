#tag Class
Protected Class Logger
	#tag Method, Flags = &h0
		Sub Constructor(msg as string, enabled_by_default as boolean = true)
		  Self.m_logging = Debug.m_logging And enabled_by_default
		  
		  Self.m_msg = msg
		  
		  debug.log "Start " + m_msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  
		  debug.Log "End " + m_msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(msg as string)
		  // do NOT log in logging !
		  
		  If m_logging Then
		    debug.Log msg
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Logging(assigns b as boolean)
		  me.m_logging = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub operator_convert(msg as string)
		  Constructor(msg)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_logging As boolean = true
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_msg As string
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
End Class
#tag EndClass
