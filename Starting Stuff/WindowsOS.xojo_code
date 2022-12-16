#tag Module
Protected Module WindowsOS
	#tag Method, Flags = &h0
		Sub AllowRedraw(w As Window)
		  #Pragma Unused w
		  
		  #If targetWin32
		    
		    Const WM_SETREDRAW = &h000B
		    
		    Declare Sub SendMessage Lib "User32" alias "SendMessageW" (hwnd As Integer, msg As Integer, wParam As Boolean, lParam As Integer)
		    
		    ' SendMessage(
		    ' (HWND) hWnd,
		    ' WM_SETREDRAW,
		    ' (WPARAM) wParam,
		    ' (LPARAM) lParam
		    ' );
		    
		    SendMessage(w.handle, WM_SETREDRAW, True, 0)
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlockRedraw(w As Window)
		  #Pragma Unused w
		  
		  #If targetWin32
		    
		    Const WM_SETREDRAW = &h000B
		    
		    Declare Sub SendMessage Lib "User32" alias "SendMessageW" (hwnd As Integer, msg As Integer, wParam As Boolean, lParam As Integer)
		    
		    ' SendMessage(
		    ' (HWND) hWnd,
		    ' WM_SETREDRAW,
		    ' (WPARAM) wParam,
		    ' (LPARAM) lParam
		    ' );
		    
		    SendMessage(w.handle, WM_SETREDRAW, False, 0)
		    
		  #EndIf
		  
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
