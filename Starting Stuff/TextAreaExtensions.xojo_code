#tag Module
Protected Module TextAreaExtensions
	#tag Method, Flags = &h0
		Sub AutomaticDashSubstitution(extends t as textarea, assigns b as Boolean)
		  #If TargetCocoa Then
		    
		    Declare Function NSClassFromString Lib "Cocoa" (aClassName As CFStringRef) As Integer
		    
		    Declare Function documentView Lib "Cocoa" selector "documentView" (obj_id As Integer) As Integer
		    
		    Declare Sub setAutomaticDashSubstitutionEnabled Lib "Cocoa" selector "setAutomaticDashSubstitutionEnabled:" (id As Integer, value As Boolean)
		    
		    Var myTextArea As Integer = documentView(t.Handle)
		    
		    setAutomaticDashSubstitutionEnabled(myTextArea, b )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AutomaticQuoteSubstitution(extends t as textarea, assigns b as Boolean)
		  #If TargetCocoa Then
		    
		    Declare Function NSClassFromString Lib "Cocoa" (aClassName As CFStringRef) As Integer
		    
		    Declare Function documentView Lib "Cocoa" selector "documentView" (obj_id As Integer) As Integer
		    
		    Declare Sub setAutomaticQuoteSubstitutionEnabled Lib "Cocoa" selector "setAutomaticQuoteSubstitutionEnabled:" (id As Integer, value As Boolean)
		    
		    Var myTextArea As Integer = documentView(t.Handle)
		    
		    setAutomaticQuoteSubstitutionEnabled(myTextArea, b )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AutomaticTextReplacement(extends t as textarea, assigns b as Boolean)
		  #If TargetCocoa Then
		    
		    Declare Function NSClassFromString Lib "Cocoa" (aClassName As CFStringRef) As Integer
		    
		    Declare Function documentView Lib "Cocoa" selector "documentView" (obj_id As Integer) As Integer
		    
		    Declare Sub setAutomaticTextReplacementEnabled Lib "Cocoa" selector "setAutomaticTextReplacementEnabled:" (id As Integer, value As Boolean)
		    
		    Var myTextArea As Integer = documentView(t.Handle)
		    
		    setAutomaticTextReplacementEnabled(myTextArea, b )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FastText(extends t as textarea, assigns newText as string)
		  #If TargetMacOS
		    Declare Function documentView Lib "AppKit" Selector "documentView" ( obj As Integer ) As Integer
		    Declare Function textStorage Lib "AppKit" Selector "textStorage" ( obj As Integer ) As Integer
		    Declare Sub beginEditing Lib "AppKit" Selector "beginEditing" ( obj As Integer )
		    Declare Sub endEditing Lib "AppKit" Selector "endEditing" ( obj As Integer )
		    
		    // First, you want to get the text storage for the document, which is a two-step process. 
		    // In the first step, you take the TextArea’s Handle property and ask for its document view:
		    Dim docView As Integer
		    docView = documentView(t.Handle)
		    
		    // Now you get the NSTextStorage for the NSTextView:
		    Dim storage As Integer
		    storage = textStorage(docView)
		    
		    // With the Text storage, you can now enable batch-editing mode by calling beginEditing:
		    beginEditing(storage)
		    
		    t.Text = newText
		    
		    // And when you are finished disable batch-editing mode:
		    endEditing(storage)
		  #Else
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScrollerStyle(extends ta as textArea) As ScrollerStyles
		  #If TargetMacOS
		    // https://developer.apple.com/documentation/appkit/nsscroller/1523591-scrollerstyle?language=objc
		    
		    Declare Function scrollerStyle Lib "Foundation" Selector "scrollerStyle" (obj As Integer) As Integer
		    
		    Dim style As Integer = scrollerStyle(ta.Handle)
		    
		    // Style will be 0 for "Legacy" and 1 for "Overlay"
		    Select Case style
		      
		    Case 0, 1
		      Return ScrollerStyles(style)
		      
		    Else
		      Return ScrollerStyles.Unknown
		    End Select
		    
		  #EndIf
		  
		End Function
	#tag EndMethod


	#tag Enum, Name = ScrollerStyles, Type = Integer, Flags = &h0
		Legacy
		  Overlay
		Unknown
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
