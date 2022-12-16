#tag Module
Protected Module PopupMenuExtensions
	#tag Method, Flags = &h0
		Sub CheckMarkForitem(extends popup as popupMenu, indexToCheck as integer, state as popupmenuextensions.States)
		  #Pragma unused popup
		  #Pragma unused indexToCheck
		  #Pragma unused state
		  
		  #If targetMacOS
		    
		    Const CocoaLib = "AppKit"
		    
		    Declare Function itemAtIndex Lib CocoaLib selector "itemAtIndex:" ( id As ptr, idx As Integer ) As ptr
		    Declare Sub setState Lib CocoaLib selector "setState:" ( id As ptr, idx As Integer )
		    Declare Function menu Lib CocoaLib selector "menu" ( id As Integer ) As ptr
		    
		    Dim ctrlHandle As Integer = popup.Handle
		    Dim mi As ptr = itemAtIndex( menu( ctrlHandle ),indexToCheck )
		    setState( mi, 1 )
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Enum, Name = States, Type = Integer, Flags = &h0
		On = 1
		  Off = 0
		Mixed = -1
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
