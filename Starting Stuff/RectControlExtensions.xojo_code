#tag Module
Protected Module RectControlExtensions
	#tag Method, Flags = &h0
		Function Bottom(extends control as RectControl) As Integer
		  Return control.Top + control.Height
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlobalLeft(extends ctrl as RectControl) As Integer
		  Dim Left As Integer
		  
		  Left = ctrl.Left
		  
		  Dim parent As RectControl = ctrl.Parent
		  
		  While parent <> Nil
		    
		    Left = Left + parent.Left
		    
		    parent = parent.Parent
		    
		  Wend
		  
		  Return Left
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlobalTop(extends ctrl as RectControl) As Integer
		  Dim top As Integer
		  
		  top = ctrl.Top
		  
		  Dim parent As RectControl = ctrl.Parent
		  
		  While parent <> Nil
		    
		    top = top + parent.top
		    
		    parent = parent.Parent
		    
		  Wend
		  
		  Return top
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlobalXToLocalX(extends control as RectControl, x as integer) As integer
		  // removes my local offset from the X value so we return a X that is local to this control not global
		  
		  return x - control.left - control.window.left
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlobalYToLocalY(extends control as RectControl, y as integer) As integer
		  // removes my local offset from the Y value so we return a Y that is local to this control not global
		  
		  return y - control.top - control.window.top
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Right(extends control as RectControl) As Integer
		  Return control.Left + control.Width
		  
		End Function
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
