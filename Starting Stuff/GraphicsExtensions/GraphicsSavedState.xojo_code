#tag Class
Class GraphicsSavedState
	#tag Method, Flags = &h0
		Sub Constructor(g as graphics)
		  
		  Self.mAntiAlias = g.AntiAlias 
		  Self.mAntiAliasMode = g.AntiAliasMode
		  Self.mbold = g.Bold 
		  Self.mCharacterSpacing = g.CharacterSpacing 
		  Self.mForeColor = g.ForeColor 
		  Self.mItalic = g.Italic 
		  Self.mPenHeight = g.PenHeight 
		  Self.mPenWidth = g.PenWidth 
		  Self.mScaleX = g.ScaleX 
		  Self.mScaleY = g.ScaleY 
		  Self.mTextFont = g.TextFont
		  Self.mTextSize = g.TextSize
		  Self.mTextUnit = g.TextUnit
		  Self.mUnderline = g.Underline
		  
		  Self.mGraphics = g
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Self.mGraphics.AntiAlias = Self.AntiAlias
		  Self.mGraphics.AntiAliasMode = Self.AntiAliasMode
		  Self.mGraphics.Bold = Self.bold
		  Self.mGraphics.CharacterSpacing = Self.CharacterSpacing
		  Self.mGraphics.ForeColor = Self.ForeColor
		  Self.mGraphics.Italic = Self.Italic
		  Self.mGraphics.PenHeight = Self.PenHeight
		  Self.mGraphics.PenWidth = Self.PenWidth
		  Self.mGraphics.ScaleX = Self.ScaleX
		  Self.mGraphics.ScaleY = Self.ScaleY
		  Self.mGraphics.TextFont = Self.TextFont
		  Self.mGraphics.TextSize = Self.TextSize
		  Self.mGraphics.TextUnit = Self.TextUnit 
		  Self.mGraphics.Underline = Self.Underline 
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAntiAlias
			End Get
		#tag EndGetter
		AntiAlias As boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAntiAliasMode
			End Get
		#tag EndGetter
		AntiAliasMode As graphics.AntiAliasModes
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBold
			End Get
		#tag EndGetter
		Bold As boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mCharacterSpacing
			End Get
		#tag EndGetter
		CharacterSpacing As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mForeColor
			End Get
		#tag EndGetter
		ForeColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mItalic
			End Get
		#tag EndGetter
		Italic As boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAntiAlias As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAntiAliasMode As graphics.AntiAliasModes
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBold As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCharacterSpacing As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mForeColor As Color
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mGraphics As graphics
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItalic As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPenHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPenWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScaleX As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScaleY As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextFont As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextSize As Single
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextUnit As FontUnits
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnderline As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPenHeight
			End Get
		#tag EndGetter
		PenHeight As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPenWidth
			End Get
		#tag EndGetter
		PenWidth As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mScaleX
			End Get
		#tag EndGetter
		ScaleX As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mScaleY
			End Get
		#tag EndGetter
		ScaleY As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTextFont
			End Get
		#tag EndGetter
		TextFont As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTextSize
			End Get
		#tag EndGetter
		TextSize As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTextUnit
			End Get
		#tag EndGetter
		TextUnit As FontUnits
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mUnderline
			End Get
		#tag EndGetter
		Underline As Boolean
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
		#tag ViewProperty
			Name="AntiAlias"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AntiAliasMode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="graphics.AntiAliasModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - LowQuality"
				"1 - DefaultQuality"
				"2 - HighQuality"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CharacterSpacing"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PenHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PenWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScaleX"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScaleY"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextUnit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inches"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
