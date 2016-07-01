Call driver()

Function driver()
	'初始化环境，包括获得project所在的本地目录。
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
	
	' 打开入口的测试脚本，并且加载testCase的脚本
	qtApp.Open projectPath&"\Driver", False, False  ' 打开入口的测试脚本,可写，不保存
	Set qtTest = qtApp.Test 
	
		' set run settings for the test 
		Set qtResultsOpt = CreateObject("QuickTest.RunResultsOptions") 
		qtResultsOpt.ResultsLocation = projectPath&"\result" '运行结果保存到临时文件夹中
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
		