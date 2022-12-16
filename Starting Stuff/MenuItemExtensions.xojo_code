#tag Module
Protected Module MenuItemExtensions
	#tag Method, Flags = &h0
		Function FindItem(extends mBar as MenuBar, menuItemName as String) As MenuItem
		  For i As Integer = 0 To mBar.Count - 1
		    
		    Dim mnuItem As MenuItem = mBar.item(i).FindItem(menuItemName) 
		    
		    If mnuitem <> Nil Then
		      Return mnuItem
		    End If
		    
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindItem(extends item as MenuItem, menuItemName as String) As MenuItem
		  For i As Integer = 0 To item.Count - 1
		    
		    If item.Item(i).Name = menuitemName Then
		      Return item.Item(i)
		    Elseif item.Item(i).Count > 0 then
		      Dim foundItem As MenuItem = item.Item(i).FindItem(menuItemName)
		      If (foundItem Is Nil) = False Then
		        Return foundItem
		      End If
		    End If
		  Next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindItemWithText(extends mBar as MenuBar, menuItemText as String) As MenuItem
		  For i As Integer = 0 To mBar.Count - 1
		    
		    If mBar.item(i).Text = menuItemText Then
		      Return mBar.item(i)
		    End If
		    
		    Dim mnuItem As MenuItem = mBar.item(i).FindItemWithText(menuItemText)
		    
		    If mnuitem <> Nil Then
		      Return mnuItem
		    End If
		    
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindItemWithText(extends item as MenuItem, menuItemText as String) As MenuItem
		  For i As Integer = 0 To item.Count - 1
		    
		    If item.Item(i).Text = menuItemText Then
		      Return item.Item(i)
		    Elseif item.Item(i).Count > 0 then
		      Dim foundItem As MenuItem = item.Item(i).FindItemWithText(menuItemText)
		      If (foundItem Is Nil) = False Then
		        Return foundItem
		      End If
		    End If
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetAsAlternate(extends item as MenuItem)
		  #If targetMacOS
		    Declare Sub setAlternate Lib "AppKit" Selector "setAlternate:" (obj As Integer, flag As Boolean)
		    
		    // by calling set alternate on macOS the following menu items will disappear from the normal menu
		    // and will show up when you press extra modifiers
		    
		    // since this ones short cut is set to CTL + CMD + W it will show when you press the CTRL key
		    // as an alternatve for whatever is set to CDM + W (which is FileCloseTab)
		    setAlternate(item.Handle(MenuItem.HandleType.CocoaNSMenuItem), True)
		    
		    // // since this ones short cut is set to CTL + SHIFT + CMD + W it will show when you press 
		    // // the CTRL & SHIFT keys
		    // // as an alternatve for whatever is set to CDM + W (which is FileCloseTab)
		    // setAlternate(FileCloseYetanotherTab.Handle(MenuItem.HandleType.CocoaNSMenuItem), True)
		    // 
		    // // and note that they are properly enabled / disabled automatically based on how they are set in the IDE
		    // 
		    // // since FileCloseOtherTab HAS an autoenabled menu handler it is enabled when you press CTRL + CMD + W
		    // // but FileCloseYetanotherTab is NOT as there is no menu handler
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetAsAlternate(item as MenuItem)
		  item.SetAsAlternate
		  
		End Sub
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
