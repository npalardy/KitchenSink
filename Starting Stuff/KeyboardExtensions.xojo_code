#tag Module
Protected Module KeyboardExtensions
	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u08
			End Get
		#tag EndGetter
		Protected keyBackspace As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u1F
			  
			End Get
		#tag EndGetter
		Protected keyDownArrow As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u03
			  
			End Get
		#tag EndGetter
		Protected keyEnter As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u1B
			  
			End Get
		#tag EndGetter
		Protected keyEscape As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u7F
			End Get
		#tag EndGetter
		Protected keyForwardDelete As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u01
			End Get
		#tag EndGetter
		Protected keyHome As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u1C
			  
			End Get
		#tag EndGetter
		Protected keyLeftArrow As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u0C
			  
			End Get
		#tag EndGetter
		Protected keyPageDown As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u08
			End Get
		#tag EndGetter
		Protected keyPageUp As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u0D
			End Get
		#tag EndGetter
		Protected keyReturn As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u1D
			End Get
		#tag EndGetter
		Protected keyRightArrow As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u09
			  
			End Get
		#tag EndGetter
		Protected keyTab As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u1E
			End Get
		#tag EndGetter
		Protected keyUpArrow As String
	#tag EndComputedProperty


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
