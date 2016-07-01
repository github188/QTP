'################################'
'---------------ͨ�÷���--------------------------'
'################################'
Function pathFind( searchingFolder,searchingFileName,fileType)
'���ݴ���ĸ�Ŀ¼�����Ҹ�Ŀ¼�µ�ָ������,�Լ�ָ���ļ����͵��ļ��������������·����
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
		'�������ļ���
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
   '����һ��·�����ַ�����������ϼ�Ŀ¼���ַ�������ҪĿ���Ǹ���QTP�ű������ļ��У��ҵ��������ڵ��ļ���
   tempArray = split(curPath,"\")
   tempStr =""
   For i=LBound(tempArray) to UBound(tempArray)-1
		tempStr = tempStr&tempArray(i)&"\"
   Next
   getParentFolderPath = tempStr
End Function


Function generateFilterExp(Sheet_Name,filterExp)
   ''����������䣬ֻ֧�� >= ,<= , <>, >, <, = ��6�ֱ��ʽ
   '�Ա��ʽ���˴���֧�����ĵķֺţ�������Ӣ�ĵĴ�Сд��
	If filterExp<>"" Then
				If InStr(filterExp,"��")>0 Then
					filterExp = Replace(filterExp,"��",";")
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
						MsgBox("��֧�ִ˱��ʽ")
					End If
				Next
			Else
				expressStr = "DataTable( 1 "&","&Chr(34)&Sheet_Name&Chr(34)&")"&"<>"&chr(34)&chr(34)
			End If
			'logPrint("��generateFilterExp�����У����������������"&expressStr)
			generateFilterExp = expressStr
End Function