Dim i
Dim fact_inf
Dim exp_inf
For i = 1 to DataTable.GetSheet("Action1").getRowCount
Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("username").Set DataTable("username", dtLocalSheet) @@ hightlight id_;_Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("username")_;_script infofile_;_ZIP::ssf5.xml_;_
Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("password").SetSecure DataTable("pass", dtLocalSheet) @@ hightlight id_;_Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebEdit("password")_;_script infofile_;_ZIP::ssf6.xml_;_
Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebElement("登录").Click @@ hightlight id_;_Browser("ELV 环境合规系统").Page("ELV 环境合规系统").WebElement("登录")_;_script infofile_;_ZIP::ssf7.xml_;_
fact_inf = Browser("ELV 环境合规系统").Dialog("来自网页的消息").Static("window id:=65535").Exist 
exp_inf = dataTable("exp_status",dtLocalSheet)
If   fact_inf Then
 Browser("ELV 环境合规系统").Dialog("来自网页的消息").WinButton("text:=确定").click
reporter.ReportEvent micPass,"登陆失败","登录失败！"

End If
DataTable.GetSheet("Action1").SetNextRow 
Next









