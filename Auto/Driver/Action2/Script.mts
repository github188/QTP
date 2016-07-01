testCaseFile =parameter("testCaseFile")  
testCaseSheetName =parameter("testCaseSheetName")    
call Driver_TestCase(testCaseFile,testCaseSheetName)

function Driver_TestCase(testCaseFile,testCaseSheetName)
   'testCaseFile 该传入参数是一个绝对路径的 Excel文件
   'testCaseSheetName该传入参数是Excel文件中存放测试用例数据 的 Sheet的名称，
	TEST_SHEET = Environment("TEST_SHEET")

	' 导入测试用例的数据，默认为第一个Sheet
	call DataTable.AddSheet(TEST_SHEET)
	If testCaseSheetName<>"" Then
		call DataTable.ImportSheet(  testCaseFile, testCaseSheetName, TEST_SHEET )
	else
		call DataTable.ImportSheet(  testCaseFile, 1, TEST_SHEET ) 
	End If
	logPrint("测试用例的数据加载完成。"&testCaseFile)
	row_count = DataTable.GetSheet(TEST_SHEET).GetRowCount
	set taskFile = createobject("scripting.dictionary") ' taskFIle Key为存放task的文件名称，值为其路径
	set testDataTable = createobject("scripting.dictionary") ' testDataSheet ，Key为存放Excel文件名+Sheet名，值为Sheet名

	'首先找到需要加载的task文件
	DataTable.GetSheet(TEST_SHEET).SetCurrentRow( 1 )
    For i=1 to row_count
		If DataTable("IDX",TEST_SHEET) = "√" Then
			taskFileName = DataTable("bizName",TEST_SHEET)
			If NOT taskFile.Exists(taskFileName) Then
				taskFilePath = pathFind(Environment("testScriptFolderName"),taskFileName,"vbs")
                call taskFile.add(taskFileName,taskFilePath)
			    ExecuteFile taskFilePath '加载task脚本文件
				logPrint("加载Task脚本文件完成。"&taskFilePath)
				Execute "Set obj"&taskFileName&" = new "&taskFileName '初始化task的类
			End If
		End If
		DataTable.GetSheet(TEST_SHEET).SetNextRow
	Next
	'存放业务的Task的文件加载完毕

	'加载测试数据所在的Sheet
	DataTable.GetSheet(TEST_SHEET).SetCurrentRow( 1 )
	For i=1 to row_count
		If DataTable("IDX",TEST_SHEET) = "√" Then
			testDataSheetName = DataTable("bizDataTable",TEST_SHEET)
			If NOT testDataTable.Exists(testDataSheetName)  and testDataSheetName<>"" Then
				tempArray = split(testDataSheetName,".") 'tempArray(0)是sheet名称
				If Ubound(tempArray)=0 and tempArray(0)<>"" Then
					'如果只有Sheet名称，则加载当前Excel文件的Sheet
					call testDataTable.add(testDataSheetName,tempArray(0))
					call DataTable.AddSheet(tempArray(0))
					call DataTable.ImportSheet( testCaseFile, tempArray(0), tempArray(0) )   
				elseif Ubound(tempArray)=1 and tempArray(1)<>"" Then
					'如果是引用的外部Excel的sheet，那么。。。
					call testDataTable.add(testDataSheetName,tempArray(1))
					testDataFilePath = pathFind(Environment("testDataFolderName"),tempArray(0),"xls")
					call DataTable.AddSheet(tempArray(1))
					call DataTable.ImportSheet( testDataFilePath, tempArray(1), tempArray(1) )  
					logPrint("加载测试数据完成。"&tempArray(1)) 
				else
					logPrint("数据文件的dataTable列格式错误。"&testDataSheetName)   
				End If
			End If
		End If
		DataTable.GetSheet(TEST_SHEET).SetNextRow
	Next
	
	'开始按照顺序执行测试用例中的具体的各个Task
	DataTable.GetSheet(TEST_SHEET).SetCurrentRow( 1 )
	For i = 1 to row_count
		If DataTable("IDX",TEST_SHEET) = "√" Then
			'执行该脚本文件中的具体方法，方法名称为Excel表格中的taskName的值，暂时不做中英文名称的字典匹配，直接使用英文
			className = DataTable("bizName",TEST_SHEET)
			taskName = DataTable("taskName",TEST_SHEET)
			bizDataTableName = DataTable("bizDataTable",TEST_SHEET)
			filterExp =DataTable("filter",TEST_SHEET)   '过滤测试数据的条件语句

			If bizDataTableName<>"" Then
				'如果task有对应的测试数据，那么加载对应的测试数据
				Sheet_Name = testDataTable.item(DataTable("bizDataTable",TEST_SHEET))
				test_data_row_count = DataTable.GetSheet(Sheet_Name).GetRowCount
				For j=1 To test_data_row_count
					DataTable.GetSheet(Sheet_Name).SetCurrentRow( j )
					If Eval(generateFilterExp(Sheet_Name,filterExp)) Then
							'Eval(generateFilterExp(Sheet_Name,filterExp)) ，解析测试数据的条件语句，符合此条件的，则执行该行测试数据，否则不执行
                            str = "obj"&className&"."&taskName&" "&chr(34)&Sheet_Name&chr(34)
							logPrint("执行测试步骤 "&i&", "&str)
							Execute str     ''执行 objlogin.login "login","TEST_SHEET"
					End If
					DataTable.GetSheet(Sheet_Name).SetNextRow
				Next
			else
				'如果task没有对应的测试数据，则不加载测试数据，如退出登录logout()方法
				str = "Call obj"&className&"."&taskName&"()"
				logPrint("执行测试步骤 "&i&", "&str)
				Execute str
			end if	
		End If
		DataTable.GetSheet(TEST_SHEET).SetNextRow
	Next

	logPrint("所有测试步骤执行完成。")
	'释放定义的所有对象
	tempArray = taskFile.keys
	For i=0 to taskFile.Count-1
		Execute "Set obj"&tempArray(i)&" = nothing"
	Next
   Set taskFile = nothing
   tempArray = testDataTable.items
   For i=0 to testDataTable.Count -1
	   If tempArray(i)<>"" Then
		   Call DataTable.DeleteSheet(tempArray(i))
	   End If
   Next
   Set testDataTable = nothing
   Call DataTable.DeleteSheet(TEST_SHEET)
   Driver_TestCase= 0
End Function