Call driver()

Function driver()
	'��ʼ���������������project���ڵı���Ŀ¼��
	projectPath = getProjectPath()
	sourceDataFile = projectPath&"\testCases.xls"
	sourceDataSheet = "TestCases"
	
	Dim qtApp 'As QuickTest.Application ' Declare the Application object variable 
	Dim qtTest 'As QuickTest.Test ' Declare a Test object variable 
	Dim qtResultsOpt 'As QuickTest.RunResultsOptions ' Declare a Run Results Options object variable 
	
	Set qtApp = CreateObject("QuickTest.Application") ' Create the Application object 
	qtApp.Launch ' Start QuickTest 
	qtApp.Visible = True ' Make the QuickTest application visible 
	' Set QuickTest run options 
	qtApp.Options.Run.CaptureForTestResults = "OnError" 
	qtApp.Options.Run.RunMode = "Fast" 
	qtApp.Options.Run.ViewResults = False 
	
	' ����ڵĲ��Խű������Ҽ���testCase�Ľű�
	qtApp.Open projectPath&"\Driver", False, False  ' ����ڵĲ��Խű�,��д��������
	Set qtTest = qtApp.Test 
	
		' set run settings for the test 
		Set qtResultsOpt = CreateObject("QuickTest.RunResultsOptions") 
		qtResultsOpt.ResultsLocation = projectPath&"\result" '���н�����浽��ʱ�ļ�����
		qtTest.Run qtResultsOpt, True   

	
	qtTest.Close
	Set qtResultsOpt = Nothing ' Release the Run Results Options object 
	Set qtTest = Nothing ' Release the Test object 
	qtApp.quit
	Set qtApp = Nothing ' Release the Application object 
End Function


Function getProjectPath()
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.GetFile(wscript.scriptfullname)
	getProjectPath = objFSO.GetParentFolderName(objFile) 
	Set objFSO = Nothing
	Set objFile = Nothing
End Function
		