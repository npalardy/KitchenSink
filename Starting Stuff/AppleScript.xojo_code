#tag Module
Protected Module AppleScript
	#tag Method, Flags = &h1
		Protected Function EncodeParamsForCommandLine(params() as variant, byref outputStrings() as string, root as boolean = false) As boolean
		  dim currentParam as variant
		  dim currentParamObject as object
		  dim currentParamType as integer
		  
		  for i as integer=0 to UBound(params)
		    currentParam=params(i)
		    currentParamType=currentParam.type
		    
		    if currentParamType>4096 then
		      select case currentParamType-4096
		      case variant.TypeString
		        dim localStringArray() as string
		        
		        localStringArray=currentParam
		        
		        outputStrings.Append join(localStringArray, EndOfLine.macOS)
		        
		      case variant.TypeInteger
		        dim localIntegerArray() as integer
		        
		        localIntegerArray=currentParam
		        
		        dim localIntegerStrings() as string
		        dim localIntegerVariant as variant
		        
		        for n as integer=0 to UBound(localIntegerArray)
		          localIntegerVariant=localIntegerArray(n)
		          
		          if EncodeParamsForCommandLine(array(localIntegerVariant), localIntegerStrings, false) then
		          else
		            'Somehow not an encodable integer?
		            return false
		          end
		        next
		        
		        outputStrings.Append join(localIntegerStrings, EndOfLine.macOS)
		      end
		      
		    else
		      select case currentParamType
		      case variant.TypeInteger, variant.TypeInt32, variant.TypeInt64
		        outputStrings.Append currentParam.StringValue
		        
		      case variant.TypeDouble, variant.TypeSingle
		        outputStrings.Append currentParam.StringValue
		        
		      case variant.TypeBoolean
		        if currentParam.BooleanValue then
		          outputStrings.Append "true"
		        else
		          outputStrings.Append "false"
		        end
		        
		      case variant.TypeString, variant.TypeText
		        outputStrings.Append EscapeStringForShell(currentParam.StringValue)
		        
		      case variant.TypeObject
		        currentParamObject=currentParam.ObjectValue
		        
		        if currentParamObject isa FolderItem then
		          outputStrings.Append EscapeStringForShell(FolderItem(currentParamObject).NativePath)
		        else
		          return false
		        end
		        
		      else
		        return false
		      end
		    end
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EscapeStringForShell(sourceString as string) As string
		  dim result as string
		  
		  result=ReplaceAll(sourceString, "\", "\\")
		  
		  result=ReplaceAll(sourceString, chr(34), "\"+chr(34))
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExecuteAsAppleScript(extends f as FolderItem, params() as variant, byref result as string) As boolean
		  if not(f.Exists) then
		    return false
		  end
		  
		  'Build the parameter strings
		  dim paramPieces() as string
		  dim consolidatedParameters as string
		  
		  if params<>nil then
		    if EncodeParamsForCommandLine(params, paramPieces, true) then
		    else
		      'Couldn't encode a parameter for some reason
		      return false
		    end
		    
		    dim shellEncodedParameters() as string
		    
		    for i as integer=0 to UBound(paramPieces)
		      shellEncodedParameters.Append EscapeStringForShell(paramPieces(i))
		    next
		    
		    consolidatedParameters=" "+chr(34)+join(shellEncodedParameters, chr(34)+" "+chr(34))+chr(34)
		  end
		  
		  dim s as shell
		  
		  s=new shell
		  
		  dim theCommand as string
		  
		  theCommand="osascript "+f.ShellPath+consolidatedParameters
		  
		  s.Execute theCommand
		  
		  'Trim off the trailing linefeed
		  result=s.result.Left(s.result.Length-1)
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseScriptShellResponseAsStringArray(sourceText as string) As string()
		  'Decode the string
		  
		  return split(sourceText.ReplaceLineEndings(EndOfLine.macOS), EndOfLine.macOS)
		End Function
	#tag EndMethod


	#tag Note, Name = How to/About this module
		From https://forum.xojo.com/t/run-applescript-via-shell-with-parameters/80136
		
		Eric Williams Run AppleScript via shell with parameters
		General
		Apr 26
		3h
		
		
		I’d like to share this little module that lets you run an AppleScript with parameters in a shell 
		and retrieve the result. There are good reasons to do this: first, you can run a script from any 
		location (so you can keep a folder of scripts in a user-accessible location for editing); you 
		can execute the script asynchronously; and you can execute multiple scripts at once.
		
		By default, the code executes script synchronously, because that was all I needed for my 
		application. However, it could easily be extended to support asynchronous calls. The important 
		parts of this code are the parameter encoding for the shell.
		
		The key entry function is ExecuteAsAppleScript, which extends the Folderitem object and 
		accepts an array of parameters. These parameters will be presented in order to your script. 
		For example, consider this sample script:
		
		    on run(name, age, favoriteColor, likesIceCream)
		        (...AppleScript code...)
		    end
		
		You would call it like this using the module:
		
		  dim scriptParams() as variant
		
		  scriptParams.Add("Terry")
		  scriptParams.Add(12)
		  scriptParams.Add("Fuscia")
		  scriptParams.Add(true)
		
		  dim someScriptFile as Folderitem
		  dim scriptResult as String
		  dim result as Boolean
		
		re  sult=someScriptFile.ExecuteAsAppleScript(scriptParams, scriptResult)
		
		Your AppleScript will receive the parameters as strings, so some parameters may need to be converted:
		
		  set age to age as number
		
		  if likesIceCream="true" then
		     set likesIceCream to true
		  else
		     set likesIceCream to false
		  end if
		
		
	#tag EndNote


End Module
#tag EndModule
