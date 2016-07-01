'################################'
'---------------通用方法--------------------------'
'################################'
Function pathFind( searchingFolder,searchingFileName,fileType)
'根据传入的根目录，查找该目录下的指定名称,以及指定文件类型的文件，并返回其绝对路径。
	tempArray = Split(searchingFileName,".")
	fileName = tempArray(0)&"."&fileType
	Set fso=CreateObject( "Scripting.FileSystemObject" )
	Set objFolder = fso.GetFolder( searchingFolder )
	Set objFileCollection = objFolder.Files
	for each objFile in objFileCollection
		If objFile.Name = fileName Then
			i=i+1
			searchedFilePath = objFile.Path
			Exit for
		End If
	Next
	
	If i=0 then
		'遍历子文件夹
		Set objSubFoldersCollection = objFolder.SubFolders
		For each objInputSubFolder in objSubFoldersCollection
			searchedFilePath= pathFind(objInputSubFolder,searchingFileName,fileType)
			If searchedFilePath<>"" Then 
				Exit For
			End if
		Next
	End If 
	pathFind = searchedFilePath
End Function

Function getParentFolderPath(curPath)
   '输入一个路径的字符串，获得其上级目录的字符串，主要目的是根据QTP脚本所在文件夹，找到工程所在的文件夹
   tempArray = split(curPath,"\")
   tempStr =""
   For i=LBound(tempArray) to UBound(tempArray)-1
		tempStr = tempStr&tempArray(i)&"\"
   Next
   getParentFolderPath = tempStr
End Function


Function generateFilterExp(Sheet_Name,filterExp)
   ''解析条件语句，只支持 >= ,<= , <>, >, <, = 这6种表达式
   '对表达式作了处理，支持中文的分号，不区分英文的大小写。
	If filterExp<>"" Then
				If InStr(filterExp,"；")>0 Then
					filterExp = Replace(filterExp,"；",";")
				End If
				expressArray = Split(LCase(filterExp),";")
				For i=LBound(expressArray) To UBound(expressArray)
					If InStr(expressArray(i),">=") Then
						tempArray = Split(expressArray(i),">=")
						If i=LBound(expressArray) Then
							expressStr = "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&">="&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&">="&chr(34)&tempArray(1)&chr(34)
						End If
					ElseIf InStr(expressArray(i),"<=") Then
						tempArray = Split(expressArray(i),"<=")
						If i=LBound(expressArray) Then
							expressStr =  "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<="&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<="&chr(34)&tempArray(1)&chr(34)
						End If
					ElseIf InStr(expressArray(i),"<>") Then
						tempArray = Split(expressArray(i),"<>")
						If i=LBound(expressArray) Then
							expressStr =  "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<>"&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<>"&chr(34)&tempArray(1)&chr(34)
						End If
					ElseIf InStr(expressArray(i),"<") Then
						tempArray = Split(expressArray(i),"<")
						If i=LBound(expressArray) Then
							expressStr =  "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<"&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<"&chr(34)&tempArray(1)&chr(34)
						End If
					ElseIf InStr(expressArray(i),">") Then
						tempArray = Split(expressArray(i),">")
						If i=LBound(expressArray) Then
							expressStr =  "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&">"&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&">"&chr(34)&tempArray(1)&chr(34)
						End If
					ElseIf InStr(expressArray(i),"=") Then
						tempArray = Split(expressArray(i),"=")
						If i=LBound(expressArray) Then
							expressStr =  "DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"="&chr(34)&tempArray(1)&chr(34)
						else
							expressStr = expressStr&" and "&"DataTable("&Chr(34)&tempArray(0)&Chr(34)&","&Chr(34)&Sheet_Name&Chr(34)&")"&"="&chr(34)&tempArray(1)&chr(34)
						End If
					Else
						MsgBox("不支持此表达式")
					End If
				Next
			Else
				expressStr = "DataTable( 1 "&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<>"&chr(34)&chr(34)
			End If
			'logPrint("在generateFilterExp方法中，条件语句解析结果："&expressStr)
			generateFilterExp = expressStr
End Function