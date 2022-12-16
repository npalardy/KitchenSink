#tag Class
Private Class NotificationReceiver
Implements Notifications.Subscriber
	#tag Method, Flags = &h0
		Sub Destructor()
		  // break // notification receiver
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GotMessage(message as string, payload as variant)
		  // Part of the Notifications.Subscriber interface.
		  RaiseEvent Notified( message, payload )
		  
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Notified(message as string, payload as variant)
	#tag EndHook


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
