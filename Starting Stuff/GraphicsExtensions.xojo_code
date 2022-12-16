#tag Module
Protected Module GraphicsExtensions
	#tag Method, Flags = &h0
		Function BetterBitmapForCaching(extends g as graphics, width as integer, height as integer, depth as integer = 0) As Picture
		  Dim p As picture
		  
		  If depth <> 0 Then
		    p = New picture(width * g.ScaleX, height * g.ScaleY, depth )
		  Else
		    p = New picture(width * g.ScaleX, height * g.ScaleY )
		  End If
		  
		  p.Graphics.ScaleX = g.ScaleX
		  p.Graphics.ScaleY = g.ScaleY
		  p.Graphics.AntiAlias = g.AntiAlias
		  p.Graphics.AntiAliasMode = g.AntiAliasMode
		  p.Graphics.Bold = g.Bold
		  p.Graphics.ForeColor = g.ForeColor
		  p.Graphics.Italic = g.Italic
		  p.Graphics.PenHeight = g.PenHeight
		  p.Graphics.PenWidth = g.PenWidth
		  p.Graphics.TextFont = g.TextFont
		  p.Graphics.TextSize = g.TextSize
		  p.Graphics.TextUnit = g.TextUnit
		  p.Graphics.Transparency = g.Transparency
		  p.Graphics.Underline = g.Underline
		  
		  return p
		  
		  
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
