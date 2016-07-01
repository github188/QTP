Class Collection

Function toInsert(Sheet_Name)		
	    Browser("ELV 环境合规系统").Page("ELV 环境合规系统_2").Frame("leftFrame").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA").Click
	    Browser("ELV 环境合规系统").Page("ELV 环境合规系统_2").Frame("leftFrame").Link("车型信息").Click
	    Browser("ELV 环境合规系统").Page("ELV 环境合规系统_2").Frame("mainFrame").WebButton("新增车型").Click
	    Browser("ELV 环境合规系统").Page("ELV 环境合规系统_2").Frame("mainFrame").WebButton("关闭").Click
Browser("ELV 环境合规系统").Page("ELV 环境合规系统_2").Sync
End Function

Function toCheck(Sheet_Name)		
	call menuSelect("资金结算-柜台业务-活期存款-银行收款-业务复核")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'正式业务的脚本从这里开始
	'银行收款-业务复核功能页面
		
		'收款帐户编号
		curPage.Image("index:=0","name:=button").Click
		If  popPage.Exist Then
			popPage.Link("text:="&DataTable("收款账户编号", Sheet_Name)).Click
		End If
		'开户行信息
		curPage.Image("index:=1","name:=button").Click
		If  popPage.Exist Then
			popPage.Link("text:="&DataTable("开户行", Sheet_Name)).Click
		End If
		'报单号
		curPage.WebEdit("name:=strDeclarationNo").Set DataTable("报单号", Sheet_Name)
		'金额
		curPage.WebEdit("name:=dAmount").Set DataTable("金额", Sheet_Name)
		
		'点击匹配按钮
		curPage.WebButton("name:= 匹 配 ").Click
		
		If popDialog.Exist(3) Then
		    str=popDialog.Static("window id:=65535").GetROProperty("text")
			reporter.ReportEvent micFail,"银行收款-业务复核","匹配不通过，错误信息为："&str
			popDialog.WinButton("text:=确定").Click
		End If
		
		'返回交易号
		DataTable("transNO", Sheet_Name) = curPage.WebEdit("name:=textfield2352").GetROProperty("value")
		curPage.WebButton("name:= 复 核 ").Click
		popDialog.WinButton("text:=确定").Click
		
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"成功")>0 Then
			popDialog.WinButton("text:=取消").Click
			Reporter.ReportEvent micPass,"复核成功","复核成功："&str
			logPrint("交易"&DataTable("transNO", Sheet_Name)&str)
		else
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent micFail,"复核失败","复核失败："&str
			logPrint("交易"&DataTable("transNO", Sheet_Name)&str)
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toUncheck(Sheet_Name)		
	call menuSelect("资金结算-柜台业务-活期存款-银行收款-业务复核")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'正式业务的脚本从这里开始
		
		'银行收款-业务复核功能页面
		curPage.WebButton("name:= 链接查找  ").Click
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		'输入取消复核备注信息
		curPage.WebEdit("name:=strCheckAbstractStr").Set "取消复核"
		curPage.WebButton("name:= 取消复核 ").Click
		popDialog.WinButton("text:=确定").Click
		str=popDialog.Static("nativeclass:=Static","window id:=65535").GetROProperty("text")
		If instr(str,"成功")>0 Then
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent micPass,"取消复核成功","复核成功："&str
			logPrint("交易"&DataTable("transNO", Sheet_Name)&str)
			else
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent micFail,"取消复核失败","复核失败："&str
			logPrint("交易"&DataTable("transNO", Sheet_Name)&str)
		End If
		curPage.WebButton("name:= 返 回 ").Click
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toModify(Sheet_Name)		
	call menuSelect("资金结算-柜台业务-活期存款-银行收款-业务处理")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'正式业务的脚本从这里开始
		
		'银行收款-业务处理功能页面
		curPage.WebButton("name:= 链接查找  ").Click
		
		
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		curPage.WebButton("name:= 保 存 ").Click
		popDialog.WinButton("text:=确定").Click
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"重复")>0 Then
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent  micWarning,"重复交易","重复交易："&DataTable("transNO", Sheet_Name)
			str=popDialog.Static("nativeclass:=Static","window id:=65535").GetROProperty("text")
				If instr(str,"成功")>0 Then
				popDialog.WinButton("text:=确定").Click
				Reporter.ReportEvent micPass,"修改成功","提示信息："&str
				else
				popDialog.WinButton("text:=确定").Click
				Reporter.ReportEvent micFail,"修改失败","提示信息："&str
				End If
		elseIf instr(str,"成功")>0 Then
				popDialog.WinButton("text:=确定").Click
				Reporter.ReportEvent micPass,"修改成功","提示信息："&str
		else
				popDialog.WinButton("text:=确定").Click
				Reporter.ReportEvent micFail,"修改失败","提示信息："&str
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toDelete(Sheet_Name)		
	call menuSelect("资金结算-柜台业务-活期存款-银行收款-业务处理")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'正式业务的脚本从这里开始
		
		'银行收款-业务处理功能页面
		curPage.WebButton("name:= 链接查找  ").Click
		
		
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		curPage.WebButton("name:= 删 除 ").Click
		popDialog.WinButton("text:=确定").Click
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"成功")>0 Then
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent micPass,"删除成功","删除成功："&str
			else
			popDialog.WinButton("text:=确定").Click
			Reporter.ReportEvent micFail,"删除失败","删除失败："&str
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

End Class
