class Login
	Function login(Sheet_Name)
		'�ر����е�IE���ڣ������������
		SystemUtil.CloseProcessByName "iexplore.exe"
	
		'��IE������վ��
		SystemUtil.Run "iexplore.exe"
		Set browsDesc = description.create()
		Set pageDesc = description.create()
		Set curPage = Browser(browsDesc).Page(pageDesc)
		curPage.Sync
		Browser(browsDesc).Navigate "http://60.30.69.61:8290/CESEMDMS/login/loginAction.action"
		curPage.Sync
	
		'�����û�������½ϵͳ
		Dim i
		Dim fact_inf
		Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ").WebEdit("username").Set DataTable("�û���",Sheet_Name)
		Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ").WebEdit("password").SetSecure DataTable("����",Sheet_Name)
		Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ").WebElement("��¼").Click
		fact_inf = Browser("ELV �����Ϲ�ϵͳ").Dialog("������ҳ����Ϣ").Static("window id:=65535").Exist 
		If   fact_inf Then
		 Browser("ELV �����Ϲ�ϵͳ").Dialog("������ҳ����Ϣ").WinButton("text:=ȷ��").click
		reporter.ReportEvent micPass,"��½ʧ��","��¼ʧ�ܣ�"
		
		End If
		
	End Function
	
	Function logout()
		SystemUtil.CloseDescendentProcesses
	End Function	
end class

