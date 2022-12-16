#tag Module
Protected Module HTMLViewerExtensions
	#tag Method, Flags = &h0
		Sub Copy(Extends h As HTMLViewer)
		  
		  h.ExecuteJavaScript( "document.execCommand('copy');" )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableDeveloperExtras(Extends ctl as HTMLViewer, assigns value as boolean)
		  #If TargetMacOS And DebugBuild
		    Declare Function getConfiguration Lib "WebKit" selector "configuration" (obj as integer) As Ptr
		    Declare Function getPreferences Lib "WebKit" selector "preferences" (obj as ptr) As Ptr
		    Declare sub _setDeveloperExtrasEnabled lib "WebKit" selector "_setDeveloperExtrasEnabled:" (obj as ptr, value as Boolean)
		    
		    dim config as ptr = getConfiguration(ctl.Handle)
		    dim prefs as ptr = getPreferences(config)
		    _setDeveloperExtrasEnabled(prefs, value)
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectAll(Extends h As HTMLViewer)
		  Var exec() As String
		  exec.Add( "var selection = window.getSelection()," )
		  exec.Add( "    range = document.createRange();" )
		  exec.Add( "range.selectNodeContents(document.body);" )
		  exec.Add( "selection.removeAllRanges();" )
		  exec.Add( "selection.addRange(range);" )
		  h.ExecuteJavaScript( String.FromArray( exec, "" ) )
		  
		  
		  
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
