#tag Module
Protected Module Notifications
	#tag Method, Flags = &h21
		Private Function ConvertToSimpleRegex(messageSubscribingTo As String) As string
		  // basically this escapes EVERYTHING in a "regex looking" string 
		  // except the * which it turns into a .* 
		  // this way everything else is literal except the * which is "any sequence of anything"
		  
		  Dim subscribesTo As String = messageSubscribingTo
		  
		  subscribesTo = ReplaceAll(subscribesTo, ".", ChrB(0)+"DOT"+ChrB(0))
		  subscribesTo = ReplaceAll(subscribesTo, "*", ".*")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "\", "\\")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "[", "\[")
		  subscribesTo = ReplaceAll(subscribesTo, "]", "\]")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "(", "\(")
		  subscribesTo = ReplaceAll(subscribesTo, ")", "\)")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "{", "\{")
		  subscribesTo = ReplaceAll(subscribesTo, "}", "\}")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "^", "\^")
		  subscribesTo = ReplaceAll(subscribesTo, "$", "\$")
		  
		  subscribesTo = ReplaceAll(subscribesTo, "?", "\?")
		  subscribesTo = ReplaceAll(subscribesTo, "+", "\+")
		  subscribesTo = ReplaceAll(subscribesTo, "|", "\|")
		  subscribesTo = ReplaceAll(subscribesTo, "<", "\<")
		  subscribesTo = ReplaceAll(subscribesTo, "=", "\=")
		  subscribesTo = ReplaceAll(subscribesTo, ":", "\:")
		  subscribesTo = ReplaceAll(subscribesTo, "!", "\!")
		  subscribesTo = ReplaceAll(subscribesTo, "'", "\'")
		  subscribesTo = ReplaceAll(subscribesTo, "-", "\-")
		  subscribesTo = ReplaceAll(subscribesTo, "`", "\`")
		  subscribesTo = ReplaceAll(subscribesTo, "&", "\&")
		  subscribesTo = ReplaceAll(subscribesTo, "#", "\#")
		  
		  subscribesTo = ReplaceAll(subscribesTo, ChrB(0)+"DOT"+ChrB(0), "\.")
		  
		  // subscribesTo = subscribesTo.ReplaceAllB( "\E", "\\EE\Q" )
		  // subscribesTo = subscribesTo.ReplaceAll( "*", "\E.*\Q" )
		  // subscribesTo = "\Q" + subscribesTo + "\E"
		  // 
		  // If subscribesto.Right(4) = "\Q\E" Then
		  // subscribesTo = subscribesTo.Left( subscribesTo.Len - 4 )
		  // End If
		  
		  Return subscribesTo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitializeNotifications()
		  If m_CurrentSubscriptions Is Nil Then
		    m_CurrentSubscriptions = New Dictionary
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MessageIsA(key as string, message as string) As Boolean
		  Dim r As New RegEx
		  r.SearchPattern = "^"+key
		  r.Options.StringBeginIsLineBegin = True
		  r.options.StringEndIsLineEnd = True
		  r.Options.MatchEmpty = False
		  
		  Dim match As RegExMatch = r.Search(message)
		  
		  return match <> nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Notify(message as string, payload as variant = nil)
		  // note that with publishing we COULD have both a message and a payload
		  // and we would just pass the payload along in any event
		  
		  InitializeNotifications
		  
		  // so lets see what patterns this matches 
		  // & tell all those subscribers about this message if their subscription matches
		  For Each key As String In m_CurrentSubscriptions.Keys
		    
		    // what we really want is a REALLY limited regex where only . and * matter
		    // . is literally a .
		    // and * is "anything" and thats it
		    // everything else is literally what it says
		    
		    Dim r As New RegEx
		    r.SearchPattern = "^"+key
		    r.Options.StringBeginIsLineBegin = True
		    r.options.StringEndIsLineEnd = True
		    r.Options.MatchEmpty = False
		    
		    Dim match As RegExMatch = r.Search(message)
		    
		    If match <> Nil and match.SubExpressionString(0) = message then
		      Dim subscribers() As Subscriber = m_CurrentSubscriptions.value(key)
		      
		      For Each s As Subscriber In subscribers
		        // may need to shove these into a thread or timer or something that lets us move on quickly
		        S.GotMessage(message, payload)
		      Next
		      
		    End If
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RemoveIllegalCharsFromItem(original as string) As string
		  // here . and * are reserved
		  
		  Dim workingCopy As String = original
		  
		  workingCopy = workingCopy.ReplaceAll(".", "_")
		  workingCopy = workingCopy.ReplaceAll("*", "_")
		  
		  workingCopy = ConvertToSimpleRegex( workingCopy )
		  
		  return workingCopy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  #If DebugBuild
		    
		    Dim Logger As debug.logger = CurrentMethodName
		    
		    // test converting the regex to be a simple one
		    If True Then
		      Dim s As String = "foo.*"
		      
		      Dim result As String = ConvertToSimpleRegex(s)
		      
		      // note the DOT (.) above needs to be matched LITERALLY hence it turns into \.
		      // and the * means "anything"  which in a regex is ".*"
		      // assert result = "\Qfoo.\E.*", CurrentMethodName + " did the wrong thing with a pattern"
		      Debug.assert result = "foo\..*", CurrentMethodName + " did the wrong thing with a pattern"
		    End If
		    
		    If True Then
		      Dim s As String = "foo.*.bar.*"
		      
		      Dim result As String = ConvertToSimpleRegex(s)
		      
		      // note the DOT (.) above needs to be matched LITERALLY hence it turns into \.
		      // and the * means "anything"  which in a regex is ".*"
		      // assert result = "\Qfoo.\E.*\Q.bar.\E.*", CurrentMethodName + " did the wrong thing with a pattern"
		      Debug.assert result = "foo\..*\.bar\..*", CurrentMethodName + " did the wrong thing with a pattern"
		      
		    End If
		    
		    If True Then
		      Dim s As String = ".[]-^\?*+{}|$`&$+?#:!<=()"
		      
		      Dim result As String = ConvertToSimpleRegex(s)
		      
		      //assert result = "\Q.[]-^\?\E.*\Q+{}|$`&$+?#:!<=()\E", CurrentMethodName + " did the wrong thing with a pattern"
		      Debug.assert result = "\.\[\]\-\^\\\?.*\+\{\}\|\$\`\&\$\+\?\#\:\!\<\=\(\)", CurrentMethodName + " did the wrong thing with a pattern"
		    End If
		    
		    
		    If True Then
		      Dim message As String = "foo.bar"
		      Dim pattern As String = ConvertToSimpleRegex("foo.*")
		      
		      Debug.assert MessageIsA(pattern, message) = True, CurrentMethodName + " did match"
		    End If
		    
		    If True Then
		      Dim message As String = "foo.bar.baz"
		      Dim pattern As String = ConvertToSimpleRegex("foo.*.*")
		      
		      Debug.assert MessageIsA(pattern, message) = True, CurrentMethodName + " did match"
		    End If
		    
		    If True Then
		      Dim message As String = "foo.bar.baz"
		      Dim pattern As String = ConvertToSimpleRegex("foo.bar.*")
		      
		      Debug.assert MessageIsA(pattern, message) = True, CurrentMethodName + " did match"
		    End If
		    
		    
		    If True Then
		      Dim message As String = "bar.foo"
		      Dim pattern As String = ConvertToSimpleRegex("foo.*")
		      
		      Debug.assert MessageIsA(pattern, message) = False, CurrentMethodName + " did match"
		    End If
		    
		    If True Then
		      Dim message As String = "bar.foo.baz"
		      Dim pattern As String = ConvertToSimpleRegex("foo.*.*")
		      
		      Debug.assert MessageIsA(pattern, message) = False, CurrentMethodName + " did match"
		    End If
		    
		    If True Then
		      Dim message As String = "foo.bar.baz"
		      Dim pattern As String = ConvertToSimpleRegex("foo.baz.*")
		      
		      Debug.assert MessageIsA(pattern, message) = False, CurrentMethodName + " did match"
		    End If
		    
		    If True Then
		      Dim message As String = "foo.bar.baz"
		      Dim pattern As String = ConvertToSimpleRegex("*")
		      
		      Debug.assert MessageIsA(pattern, message) = True, CurrentMethodName + " did match"
		    End If
		    
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Subscribe(whatSubscriber as Subscriber, subscribesTo() as String)
		  
		  For Each thingToSubscribeTo As String In subscribesTo
		    Subscribe(whatSubscriber, thingToSubscribeTo)
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Subscribe(whatSubscriber as Subscriber, subscribesTo as String)
		  InitializeNotifications
		  
		  // make the subscription only be simple with . and *
		  // everything else is literals
		  subscribesTo = ConvertToSimpleRegex(subscribesTo)
		  
		  // any array already ?
		  If m_CurrentSubscriptions.Lookup(subscribesTo, Nil) Is Nil Then
		    // no so create one and add this item
		    Dim subscribers() As Subscriber
		    subscribers.Append whatSubscriber
		    m_CurrentSubscriptions.value(subscribesTo) = subscribers
		  Else
		    // yes so grab it 
		    Dim subscribers() As Subscriber = m_CurrentSubscriptions.value(subscribesTo)
		    
		    // and make sure we dont have the same subscriber in here multiple times
		    If subscribers.IndexOf(whatSubscriber) < 0 Then
		      subscribers.Append whatSubscriber
		      m_CurrentSubscriptions.value(subscribesTo) = subscribers
		    End If
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Unsubscribe(whatSubscriber as Subscriber, subscribesTo as String)
		  // this unsubscribes a subscriber from a specific message
		  // and what you subscribed TO is what you have to unsubscribe FROM
		  
		  // ie/  if you subscribed to Prefs.* 
		  //      then you unsubscribe from Prefs.*
		  
		  // you have to match subscriptions and unsubscriptions
		  
		  InitializeNotifications
		  
		  subscribesTo = ConvertToSimpleRegex(subscribesTo)
		  
		  If m_CurrentSubscriptions.Lookup(subscribesTo, Nil) Is Nil Then
		    Return
		  Else
		    Dim subscribers() As Subscriber = m_CurrentSubscriptions.value(subscribesTo)
		    Dim idx As Integer = subscribers.IndexOf( whatSubscriber )
		    If idx >= 0 Then
		      subscribers.Remove idx
		      m_CurrentSubscriptions.value(subscribesTo) = subscribers
		    End If
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			
			// the KEY is the full message that has been to
			// the value is the list of things that have subscribed
			
			// you can subscribe to something like
			// Prefs.*
			// and all messages that are like Prefs.LayoutEditor.BackColor would be sent to all those subscribers
			// basically any message prefixed "Prefs."
			
			// so the trick here is designing the message hierarchy so that wild card subscriptions are useful
			
			// what we really want is a REALLY limited regex where only . and * matter
			// . is literally a .
			// and * is "anything" and thats it
			// everything else is literally what it says
			
			// note EVERY sent message can have a "payload" ... some values that you want to send along with the message
			// say a preference for a color change then you might send the color change along
			// the INTENT is NOT to send fat objects but small simple things like colors etc
		#tag EndNote
		Private m_CurrentSubscriptions As Dictionary
	#tag EndProperty


	#tag Constant, Name = kAddedControl, Type = String, Dynamic = False, Default = \"AddedControl", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kALL, Type = String, Dynamic = False, Default = \".*", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPreferences, Type = String, Dynamic = False, Default = \"Preferences", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kProjectItemAddition, Type = String, Dynamic = False, Default = \"AddProjectItem", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kProjectItemRemoval, Type = String, Dynamic = False, Default = \"RemoveProjectItem", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPropertyChange, Type = String, Dynamic = False, Default = \"PropertyChange", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kRemovedControl, Type = String, Dynamic = False, Default = \"RemovedControl", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ReorderedControl, Type = String, Dynamic = False, Default = \"ReorderedControl", Scope = Private
	#tag EndConstant

	#tag Constant, Name = RightAdded, Type = String, Dynamic = False, Default = \"RightAdded", Scope = Private
	#tag EndConstant

	#tag Constant, Name = RightRemoved, Type = String, Dynamic = False, Default = \"RightRemoved", Scope = Private
	#tag EndConstant

	#tag Constant, Name = RoleAdded, Type = String, Dynamic = False, Default = \"RoleAdded", Scope = Private
	#tag EndConstant

	#tag Constant, Name = RoleRemoved, Type = String, Dynamic = False, Default = \"RoleAdded", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ThemeChanged, Type = String, Dynamic = False, Default = \"ThemeChanged", Scope = Private
	#tag EndConstant


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
