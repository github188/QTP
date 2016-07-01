ProjectDir = getParentFolderPath(Environment.Value("TestDir")) '项目所在的根目录，如"D:\project\"，这个路径的末位是有一个反斜线的
TestSetExcelFile = ProjectDir&"testCases.xls"   '管理所有测试用例的Excel文件的路径
 testScriptFolderName =ProjectDir&"testScript" 'task脚本文件所在的根目录
 testDataFolderName = ProjectDir&"testData"'测试数据文件所在的根目录
 Environment("ProjectDir")  = ProjectDir
 Environment("TestSetExcelFile")  = TestSetExcelFile
 Environment("testScriptFolderName")  = testScriptFolderName
 Environment("testDataFolderName")  = testDataFolderName
 Environment("Log_Dir")  = ProjectDir&"logs"
 
SET_SHEET = Environment("SET_SHEET")
TEST_SHEET = Environment("TEST_SHEET")

Call Driver_Test_Set()
Function Driver_Test_Set()
	Dim row_count '记录的测试用例集一共有多少个
    
	' import the Set table to QTP's data table
	call DataTable.AddSheet(SET_SHEET)
	call DataTable.ImportSheet(TestSetExcelFile,1, SET_SHEET)
	row_count = DataTable.GetSheet(SET_SHEET).GetRowCount
	logPrint("最多执行"&row_count&"个测试用例")
	
	For i=1 to row_count
		'获取测试用例的名称，存放测试用例的Excel文件名称，是否运行这三个重要字段。默认Excel的第一个Sheet就是测试用例
		DataTable.GetSheet(SET_SHEET).SetCurrentRow(i)
		isRun	= DataTable.Value("IDX", SET_SHEET)
		caseName = datatable.value("name", SET_SHEET)
		testCaseFileName = datatable.value("table", SET_SHEET)
		testCaseSheetName = datatable.value("sheet", SET_SHEET)
		caseDesc = DataTable.Value("description", SET_SHEET)

        ' 如果该行测试用例是要被执行的，那么就执行，否则跳过。
		if isRun = "√"  then	
            table = pathFind(testDataFolderName,testCaseFileName,"xls")
			logPrint("开始运行测试用例 "&caseName&" , 数据存放位置： "&table)
		   ' rc = Driver_TestCase(table)   
		   RunAction "Driver_TestCase", oneIteration,table,testCaseSheetName
		   logPrint("执行完成。测试用例 "&caseName&" , 数据存放位置： "&table)
		end if
	Next
	DataTable.DeleteSheet(SET_SHEET)
	logPrint("所有测试用例执行完成。")
	Driver_Test_Set = rc
End Function