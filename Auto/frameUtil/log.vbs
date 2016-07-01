Public Function logPrint(ByVal logMessage)
        
        Dim fso, logFile
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set logFile = fso.OpenTextFile(Environment("Log_Dir")&"\runtime.log", 8, True) 'Open a file and write to the end of the file and open as Unicode
        
        logFile.WriteLine(date() & " " & hour(now) & ":" & minute(now) & ":" & second(now) & ": " & logMessage)
    
        logFile.Close
End Function

Public Function ErrorHandle()
        If Err.Number <> 0 Then
                logPrint "Error Num: " & Err.Number & "; Error Src: " & Err.Source & "; Error Desc: " & Err.Description
                Err.Clear
        End If
End Function