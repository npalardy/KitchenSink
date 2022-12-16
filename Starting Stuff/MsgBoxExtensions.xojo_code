#tag Module
Protected Module MsgBoxExtensions
	#tag Enum, Name = Buttons, Flags = &h0
		OKOnly = 0
		  OKCancel = 1
		  AbortRetryIgnore = 2
		  YesNoCancel = 3
		  YesNo = 4
		RetryCancel = 5
	#tag EndEnum

	#tag Enum, Name = DefaultButton, Flags = &h0
		First = 0
		  Second = 256
		  Third = 512
		None = 768
	#tag EndEnum

	#tag Enum, Name = Icon, Flags = &h0
		None = 0
		  Stop = 16
		  Question = 32
		  Caution = 48
		Note = 64
	#tag EndEnum

	#tag Enum, Name = PressedButton, Flags = &h0
		OK = 1
		  Cancel = 2
		  Abort = 3
		  Retry = 4
		  Ignore = 5
		  Yes = 6
		No = 7
	#tag EndEnum


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
