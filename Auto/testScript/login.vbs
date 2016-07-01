class Login
	Function login(Sheet_Name)
		'关闭所有的IE窗口，避免出现问题
		SystemUtil.CloseProcessByName "iexplore.exe"
	
		'打开IE，进入站点
		SystemUtil.Run "iexplore.exe"
		Set browsDesc = description.create()
		Set pageDesc = description.create()
		Set curPage = Browser(browsDesc).Page(pageDesc)
		curPage.Sync
		Browser(browsDesc).Navigate "http://60.30.69.61:8290/CESEMDMS/login/loginAction.action"
		curPage.Sync
	
		'输入用户名，登陆系统
		Dim i
		Dim fact_inf
		Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("username").Set DataTable("用户名",Sheet_Name)
		Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("password").SetSecure DataTable("密码",Sheet_Name)
		Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebElement("登录").Click
		fact_inf = Browser("ELV 环境合规系统").Dialog("来自网页的消息").Static("window id:=65535").Exist 
		If   fact_inf Then
		 Browser("ELV 环境合规系统").Dialog("来自网页的消息").WinButton("text:=确定").click
		reporter.ReportEvent micPass,"登陆失败","登录失败！"
		
		End If
		
	End Function
	
	Function logout()
		SystemUtil.CloseDescendentProcesses
	End Function	
end class

