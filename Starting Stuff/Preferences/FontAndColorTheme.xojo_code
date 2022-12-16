#tag Class
Protected Class FontAndColorTheme
	#tag Method, Flags = &h0
		Sub AddColorSetting(settingName as FontAndColorTheme.Members, assigns newColor as color)
		  SetKeyValuePair(settingName, newColor)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddColorSetting(settingName as FontAndColorTheme.Members, assigns newColorName as String)
		  SetKeyValuePair(settingName, newColorName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllColorSettings() As Pair()
		  Dim settings() As Pair
		  
		  // this could put an actual COLOR &cFF00FF00 or "default"
		  
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorKeywordsColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorKeywordsColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorStringsColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorStringsColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorNumbersColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorNumbersColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorTextColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorTextColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorCommentsColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorCommentsColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorBackgroundColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorBackgroundColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorCaretColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorCaretColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.LayoutEditorBackColor, m_ColorSettings.lookup(FontAndColorTheme.Members.LayoutEditorBackColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorGutterBackgroundColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorLineNumberColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorLineNumberColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorSelectedTextColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorSelectedTextColor, kDefault))
		  settings.append New Pair( FontAndColorTheme.Members.CodeEditorSyntaxErrorColor, m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor, kDefault))
		  
		  Return settings
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AsXML() As String
		  Dim strings() As String
		  
		  Strings.append "<?xml version=""1.0"" encoding=""UTF-8""?>"
		  Strings.append "<Theme name=""" + Name + """>"
		  
		  Strings.append MakeEntry( nameOf(Members.CodeEditorFont), CodeEditorFont )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorFontSize), Str(CodeEditorFontSize) )
		  
		  Strings.append MakeEntry( nameOf(Members.CodeEditorKeywordsColor), Str(CodeEditorKeywordsColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorStringsColor), Str(CodeEditorStringsColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorNumbersColor), Str(CodeEditorNumbersColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorTextColor), Str(CodeEditorTextColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorCommentsColor), Str(CodeEditorCommentsColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorBackgroundColor), Str(CodeEditorBackgroundColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorCaretColor), Str(CodeEditorCaretColor) )
		  Strings.append MakeEntry( nameOf(Members.LayoutEditorBackColor), Str(LayoutEditorBackColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorGutterBackgroundColor), Str(CodeEditorGutterBackgroundColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorLineNumberColor), Str(CodeEditorLineNumberColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorSelectedTextBackgroundColor), Str(CodeEditorSelectedTextBackgroundColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorSelectedTextColor), Str(CodeEditorSelectedTextColor) )
		  Strings.append MakeEntry( nameOf(Members.CodeEditorSyntaxErrorColor), Str(CodeEditorSyntaxErrorColor) )
		  
		  Strings.append "</Theme>"
		  
		  Return Join(strings, EndOfLine)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone() As FontAndColorTheme
		  Dim trimmedName As String = Name.Trim
		  
		  Dim isDark As Boolean = trimmedName.EndsWith("(Dark)")
		  Dim isLight As Boolean = trimmedName.EndsWith("(Light)")
		  
		  Dim lightDark As String 
		  If isDark Then
		    lightDark = "(Dark)"
		  Elseif IsLight Then
		    lightDark = "(Light)"
		  End If
		  Dim baseName As String = trimmedName.Left( trimmedName.Len - Len(lightDark) ).Trim
		  Dim copyname As String = baseName + " Copy" + if(lightDark<>"", " " + lightDark, "")
		  
		  Dim clone As New FontAndColorTheme( copyName )
		  
		  For Each key As FontAndColorTheme.Members In m_ColorSettings.Keys
		    clone.SetPair( key, m_ColorSettings.value(key) )
		  Next
		  
		  clone.CodeEditorFont = CodeEditorFont
		  clone.CodeEditorFontSize = CodeEditorFontSize
		  
		  return clone
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorBackgroundColor() As color
		  
		  Dim v As Variant = m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorBackgroundColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("underPageBackgroundColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorBackgroundColor(assigns c as color)
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorBackgroundColor, c)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorBackgroundColor(assigns s as string)
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorBackgroundColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorCaretColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorCaretColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorCaretColor(assigns c as color)
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorCaretColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorCaretColor(assigns s as string)
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorCaretColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorCommentsColor() As color
		  
		  Dim v As Variant = m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorCommentsColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorCommentsColor(assigns c as color)
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorCommentsColor, c)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorCommentsColor(assigns s as string)
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorCommentsColor, kDefault)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorFont() As String
		  
		  Dim v As Variant = m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorFont, kDefault)
		  
		  If v.StringValue = kDefault Then
		    // default font on Windows & macOS ? 
		    Return "System" 
		  Else
		    Return v.StringValue
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorFont(assigns s as string)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorFont, s)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorFontSize() As Single
		  
		  Dim v As Variant = m_ColorSettings.lookup(FontAndColorTheme.Members.CodeEditorFontSize, kDefault)
		  
		  If v.StringValue = kDefault Then
		    // default font size on Windows & macOS ? 
		    Return 0
		  Else
		    Return v.SingleValue
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorFontSize(assigns s as Single)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorFontSize, s)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorFontSize(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorFontSize, kDefault)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorGutterBackgroundColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("underPageBackgroundColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorGutterBackgroundColor(assigns c as color)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorGutterBackgroundColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorKeywordsColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorKeywordsColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorKeywordsColor(assigns c as color)
		  
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorKeywordsColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorKeywordsColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorKeywordsColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorLineNumberColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorLineNumberColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorLineNumberColor(assigns c as color)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorLineNumberColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorLineNumberColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorLineNumberColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorNumbersColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorNumbersColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorNumbersColor(assigns c as color)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorNumbersColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorNumbersColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorNumbersColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorSelectedTextBackgroundColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("selectedTextBackgroundColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSelectedTextBackgroundColor(assigns c as color)
		  
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSelectedTextBackgroundColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorSelectedTextColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorSelectedTextColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("selectedTextColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSelectedTextColor(assigns c as color)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSelectedTextColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSelectedTextColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSelectedTextColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorStringsColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorStringsColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorStringsColor(assigns c as color)
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorStringsColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorStringsColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorStringsColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorSyntaxErrorColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("systemRedColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSyntaxErrorColor(assigns c as color)
		  
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorSyntaxErrorColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CodeEditorTextColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.CodeEditorTextColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("textColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorTextColor(assigns c as color)
		  
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorTextColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CodeEditorTextColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.CodeEditorTextColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColorForKey(i as Integer) As color
		  // we're given one of the keys from FontAndColorTheme
		  // and we want to return the color it gives
		  
		  Select Case FontAndColorTheme.Members(i)
		    
		  Case FontAndColorTheme.Members.CodeEditorKeywordsColor
		    Return CodeEditorKeywordsColor
		  Case FontAndColorTheme.Members.CodeEditorStringsColor
		    Return CodeEditorStringsColor
		  Case FontAndColorTheme.Members.CodeEditorNumbersColor
		    Return CodeEditorNumbersColor
		  Case FontAndColorTheme.Members.CodeEditorTextColor
		    Return CodeEditorTextColor
		  Case FontAndColorTheme.Members.CodeEditorCommentsColor
		    Return CodeEditorCommentsColor
		  Case FontAndColorTheme.Members.CodeEditorBackgroundColor
		    Return CodeEditorBackgroundColor
		  Case FontAndColorTheme.Members.CodeEditorCaretColor
		    Return CodeEditorCaretColor
		  Case FontAndColorTheme.Members.LayoutEditorBackColor
		    Return LayoutEditorBackColor
		  Case FontAndColorTheme.Members.CodeEditorGutterBackgroundColor
		    Return CodeEditorGutterBackgroundColor
		    // Case FontAndColorTheme.Members.CodeEditorFont
		    // CodeEditorFont
		    // Case FontAndColorTheme.Members.CodeEditorFontSize
		    // CodeEditorFontSize
		  Case FontAndColorTheme.Members.CodeEditorLineNumberColor
		    Return CodeEditorLineNumberColor
		  Case FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor
		    Return CodeEditorSelectedTextBackgroundColor
		  Case FontAndColorTheme.Members.CodeEditorSelectedTextColor
		    Return CodeEditorSelectedTextColor
		  Case FontAndColorTheme.Members.CodeEditorSyntaxErrorColor
		    Return CodeEditorSyntaxErrorColor
		  Else
		    #If debugbuild
		      Break
		    #EndIf
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(themeName as string)
		  m_Name = themeName
		  
		  m_ColorSettings = New Dictionary
		  
		  // // set these so we ALWAYS have a setting for them
		  // AddColorSetting(FontAndColorTheme.Members.Keywords) = &c000000
		  // AddColorSetting(FontAndColorTheme.Members.Strings) = &c000000
		  // AddColorSetting(FontAndColorTheme.Members.Numbers) = &c000000
		  // AddColorSetting(FontAndColorTheme.Members.SourceCode) = &c000000
		  // AddColorSetting(FontAndColorTheme.Members.Comments) = &c000000
		  // AddColorSetting(FontAndColorTheme.Members.EditorBackground) =  &c000000
		  // AddColorSetting(FontAndColorTheme.Members.CursorColor) =  &c000000
		  // AddColorSetting(FontAndColorTheme.Members.LayoutEditorBackColor) =  &c000000
		  // 
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(themeName as string, settings() as Pair)
		  Constructor( themeName )
		  
		  If settings <> Nil Then
		    
		    For i As Integer = 0 To settings.Ubound
		      
		      // is this an element in the enum ?
		      Dim lhs As FontAndColorTheme.Members = Members( settings(i).Left.IntegerValue )
		      
		      If NameOf(lhs) <> "" Then
		        
		        if settings(i).Right.Type = Variant.TypeString then
		          AddColorSetting( lhs ) = settings(i).Right.StringValue 
		        Else
		          AddColorSetting( lhs ) = settings(i).Right.ColorValue 
		        End If
		        
		      End If
		      
		    Next
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function DefaultDark() As FontAndColorTheme
		  Static theme As FontAndColorTheme
		  
		  If theme Is Nil Then
		    theme = New FontAndColorTheme("Default (Dark)")
		    
		    If IsDarkMode = False Then
		      // if we're in light mode then we hard code colors 
		      // but in dark mode we can just use the defaults
		      
		      // these need to be settable by name OR color value
		      // theme.ColorSetting = New ColorSetting("Keywords" ,    <colorName>)
		      // theme.ColorSetting = New ColorSetting("Keywords" ,    &cFC5FA3   )
		      
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorKeywordsColor) = &cB3416000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorStringsColor) = &cD76C3200
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorNumbersColor) = &c786DFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorTextColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorCommentsColor) = &c30983000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorBackgroundColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorCaretColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.LayoutEditorBackColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorLineNumberColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor) = &c304F7800
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSelectedTextColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor) = &cFF282200
		      
		      // ??????????
		      // // Block Highlights     &c
		      // // Text Selection Color &c
		      
		      'theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorFont
		      'theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorFontSize
		      
		    End If
		    
		    #If TargetMacOS
		      theme.CodeEditorFont = "Menlo"
		      theme.CodeEditorFontSize = 12
		    #ElseIf TargetWindows
		      theme.CodeEditorFont = "Consolas"
		      theme.CodeEditorFontSize = 12
		    #EndIf
		    
		    
		    theme.MakeReadOnly
		  End If
		  
		  Return theme
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function DefaultLight() As FontAndColorTheme
		  Static theme As FontAndColorTheme
		  
		  If theme Is Nil Then
		    theme = New FontAndColorTheme("Default (Light)")
		    
		    If IsDarkMode = True Then
		      // if we're in dark mode then we hard code colors for light mode
		      // but in light mode we can just use the defaults
		      
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorKeywordsColor) = &cB3416000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorStringsColor) = &cD76C3200
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorNumbersColor) = &c786DFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorTextColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorCommentsColor) = &c30983000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorBackgroundColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorCaretColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.LayoutEditorBackColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorGutterBackgroundColor) = &cFFFFFF00
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorLineNumberColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor) = &c304F7800
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSelectedTextColor) = &c00000000
		      theme.AddColorSetting(FontAndColorTheme.Members.CodeEditorSyntaxErrorColor) = &cFF282200
		      
		      // Block Highlights     &c
		      // Text Selection Color &c
		    End If
		    
		    #If TargetMacOS
		      theme.CodeEditorFont = "Menlo"
		      theme.CodeEditorFontSize = 12 
		    #ElseIf TargetWindows
		      theme.CodeEditorFont = "Consolas"
		      theme.CodeEditorFontSize = 12
		    #EndIf
		    
		    theme.MakeReadOnly
		  End If
		  
		  Return theme
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromXML(xmldata as string) As FontAndColorTheme
		  
		  Dim xmlDoc As New XmlDocument( xmldata )
		  
		  Dim docElement As XmlNode = xmlDoc.DocumentElement
		  
		  Dim readTheme As New FontAndColorTheme( docElement.GetAttribute("name") )
		  
		  For i As Integer = 0 To docElement.ChildCount - 1
		    
		    Dim node As XmlNode = docElement.Child(i)
		    
		    If node.Name = NameOf(Members.CodeEditorFont) Then
		      readTheme.CodeEditorFont = node.FirstChild.Value
		    Elseif node.Name = NameOf(Members.CodeEditorFontSize) Then
		      readTheme.CodeEditorFontSize = Val(node.FirstChild.Value)
		    Else
		      Try
		        Dim memberID As FontAndColorTheme.Members = MemberIDForName( node.name )
		        Dim value As String = node.FirstChild.Value
		        If value.Left(Len("&h")) = "&h" Then
		          // color literal written as &h instead of &c
		          Dim v As Variant = value
		          Dim c As Color = v.ColorValue
		          readTheme.AddColorSetting( memberID ) = c
		        Else
		          // doesn't really matter as assigning a string sets it to "default"
		          readTheme.AddColorSetting( memberID ) = "default" 
		        End If
		      Catch UnsupportedOperationException
		        Break
		      End Try
		      
		    End If
		  Next
		  
		  Return readTheme
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LayoutEditorBackColor() As color
		  
		  Dim v As Variant = m_ColorSettings.Lookup(FontAndColorTheme.Members.LayoutEditorBackColor, kDefault)
		  
		  If v.Type = v.TypeColor Then
		    Return v.ColorValue
		  Else
		    // lookup the color by "name"
		    Return SemanticColors.ColorByName("controlColor")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LayoutEditorBackColor(assigns c as color)
		  
		  
		  SetKeyValuePair(FontAndColorTheme.Members.LayoutEditorBackColor, c)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LayoutEditorBackColor(assigns s as string)
		  
		  #Pragma unused s
		  
		  SetKeyValuePair(FontAndColorTheme.Members.LayoutEditorBackColor, kDefault)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MakeEntry(keyName as String, value as String) As string
		  
		  Dim tmp As String = value
		  // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
		  // encode a few entities
		  'Name    Character    Unicode code point (decimal)    Standard   Name
		  'quot    "            U+0022 (34)                     XML 1.0    quotation mark
		  'amp     &            U+0026 (38)                     XML 1.0    ampersand
		  'apos    '            U+0027 (39)                     XML 1.0    apostrophe (1.0: apostrophe-quote)
		  'lt      <            U+003C (60)                     XML 1.0    less-than Sign
		  'gt      >            U+003E (62)                     XML 1.0    greater-than Sign
		  
		  
		  tmp = ReplaceAll( tmp, &u26, "&amp;")
		  tmp = ReplaceAll( tmp, &u22, "&quot;")
		  tmp = ReplaceAll( tmp, &u27, "&apos")
		  tmp = ReplaceAll( tmp, &u3C, "&lt;")
		  tmp = ReplaceAll( tmp, &u3E, "&gt;")
		  
		  
		  Return  "<" + keyName + ">" + tmp + "</" + keyName +">"
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub MakeReadOnly()
		  mReadOnly = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MemberIDForName(param1 as string) As FontAndColorTheme.Members
		  Select Case param1
		  Case "CodeEditorKeywordsColor"
		    Return FontAndColorTheme.Members.CodeEditorKeywordsColor
		  Case "CodeEditorStringsColor"
		    Return FontAndColorTheme.Members.CodeEditorStringsColor
		  Case "CodeEditorNumbersColor"
		    Return FontAndColorTheme.Members.CodeEditorNumbersColor
		  Case "CodeEditorTextColor"
		    Return FontAndColorTheme.Members.CodeEditorTextColor
		  Case "CodeEditorCommentsColor"
		    Return FontAndColorTheme.Members.CodeEditorCommentsColor
		  Case "CodeEditorBackgroundColor"
		    Return FontAndColorTheme.Members.CodeEditorBackgroundColor
		  Case "CodeEditorCaretColor"
		    Return FontAndColorTheme.Members.CodeEditorCaretColor
		  Case "LayoutEditorBackColor"
		    Return FontAndColorTheme.Members.LayoutEditorBackColor
		  Case "CodeEditorGutterBackgroundColor"
		    Return FontAndColorTheme.Members.CodeEditorGutterBackgroundColor
		  Case "CodeEditorFont"
		    Return FontAndColorTheme.Members.CodeEditorFont
		  Case "CodeEditorFontSize"
		    Return FontAndColorTheme.Members.CodeEditorFontSize
		  Case "CodeEditorGutterBackgroundColor"
		    Return FontAndColorTheme.Members.CodeEditorGutterBackgroundColor
		  Case "CodeEditorLineNumberColor"
		    Return FontAndColorTheme.Members.CodeEditorLineNumberColor
		  Case "CodeEditorSelectedTextBackgroundColor"
		    Return FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor
		  Case "CodeEditorSelectedTextColor"
		    Return FontAndColorTheme.Members.CodeEditorSelectedTextColor
		  Case "CodeEditorSyntaxErrorColor"
		    Return FontAndColorTheme.Members.CodeEditorSyntaxErrorColor
		  End Select
		  
		  Dim ufex As New UnsupportedOperationException
		  
		  ufex.Message = "No such member '" + param1 + "'"
		  
		  Raise ufex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function NameOf(param1 as FontAndColorTheme.Members) As String
		  Select Case param1
		  Case FontAndColorTheme.Members.CodeEditorKeywordsColor
		    Return "CodeEditorKeywordsColor"
		  Case FontAndColorTheme.Members.CodeEditorStringsColor
		    Return "CodeEditorStringsColor"
		  Case FontAndColorTheme.Members.CodeEditorNumbersColor
		    Return "CodeEditorNumbersColor"
		  Case FontAndColorTheme.Members.CodeEditorTextColor
		    return "CodeEditorTextColor"
		  Case FontAndColorTheme.Members.CodeEditorCommentsColor
		    return "CodeEditorCommentsColor"
		  Case FontAndColorTheme.Members.CodeEditorBackgroundColor
		    return "CodeEditorBackgroundColor"
		  Case FontAndColorTheme.Members.CodeEditorCaretColor
		    Return "CodeEditorCaretColor"
		  Case FontAndColorTheme.Members.LayoutEditorBackColor
		    Return "LayoutEditorBackColor"
		  Case FontAndColorTheme.Members.CodeEditorGutterBackgroundColor
		    Return "CodeEditorGutterBackgroundColor"
		  Case FontAndColorTheme.Members.CodeEditorFont
		    Return "CodeEditorFont"
		  Case FontAndColorTheme.Members.CodeEditorFontSize
		    Return "CodeEditorFontSize"
		  Case FontAndColorTheme.Members.CodeEditorGutterBackgroundColor
		    Return "CodeEditorGutterBackgroundColor"
		  Case FontAndColorTheme.Members.CodeEditorLineNumberColor
		    Return "CodeEditorLineNumberColor"
		  Case FontAndColorTheme.Members.CodeEditorSelectedTextBackgroundColor
		    Return "CodeEditorSelectedTextBackgroundColor"
		  Case FontAndColorTheme.Members.CodeEditorSelectedTextColor
		    Return "CodeEditorSelectedTextColor"
		  Case FontAndColorTheme.Members.CodeEditorSyntaxErrorColor
		    Return "CodeEditorSyntaxErrorColor"
		  End Select
		  
		  Dim ufex As New UnsupportedOperationException
		  
		  ufex.Message = "No such member '" + Str(param1) + "'"
		  
		  Raise ufex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetKeyValuePair(settingName as FontAndColorTheme.Members, newvalue as color)
		  If mReadOnly Then
		    Return
		  End If
		  
		  m_ColorSettings.Value(settingName) = newvalue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetKeyValuePair(settingName as FontAndColorTheme.Members, newvalue as single)
		  If mReadOnly Then
		    Return
		  End If
		  
		  m_ColorSettings.Value(settingName) = newvalue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetKeyValuePair(settingName as FontAndColorTheme.Members, newvalue as String)
		  If mReadOnly Then
		    Return
		  End If
		  
		  m_ColorSettings.Value(settingName) = newvalue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetPair(settingName as FontAndColorTheme.Members, newvalue as variant)
		  If mReadOnly Then
		    Return
		  End If
		  
		  m_ColorSettings.Value(settingName) = newvalue
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Untitled
		Xcode has the following 
		  * indicates one we can lift for our use as they make sense
		  ? not sure
		
		*         Plain Text
		*         Comments
		          Documentation Markup
		          Documentation Markup Keywords
		          Marks
		*         Strings
		          Characters
		*         Numbers
		*         Keywords
		          Preprocessor Statements
		*         URLS
		          Attributes
		          Type Declarations
		          Other Declarations
		?         Project Class Names
		?         Project Function and Method Names
		?         Project Constants
		?         Project Type Names
		?         Project Instance Variables and Globals
		?         Project Preprocessor Macros
		          Other Class Names
		          Other Function and Method Names
		          Other Constants
		          Other Type Names
		          Other Instance Variables and Globals
		          Other Preprocessor Macros
		
	#tag EndNote


	#tag Property, Flags = &h1
		Protected mReadOnly As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_ColorSettings As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Name As string
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_Name
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  If mReadOnly Then
			    Return
			  End If
			  
			  m_Name = value
			End Set
		#tag EndSetter
		Name As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mReadOnly
			End Get
		#tag EndGetter
		ReadOnly As boolean
	#tag EndComputedProperty


	#tag Constant, Name = kDefault, Type = String, Dynamic = False, Default = \"default", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDefaultDarkName, Type = String, Dynamic = False, Default = \"Default (Dark)", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kDefaultLightName, Type = String, Dynamic = False, Default = \"Default (Light)", Scope = Public
	#tag EndConstant


	#tag Enum, Name = Members, Type = Integer, Flags = &h0
		CodeEditorKeywordsColor
		  CodeEditorStringsColor
		  CodeEditorNumbersColor
		  CodeEditorTextColor
		  CodeEditorCommentsColor
		  CodeEditorBackgroundColor
		  CodeEditorCaretColor
		  LayoutEditorBackColor
		  CodeEditorGutterBackgroundColor
		  CodeEditorFont
		  CodeEditorFontSize
		  CodeEditorLineNumberColor
		  CodeEditorSelectedTextBackgroundColor
		  CodeEditorSelectedTextColor
		CodeEditorSyntaxErrorColor
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
		#tag ViewProperty
			Name="ReadOnly"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
