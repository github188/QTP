Class Collection

Function toInsert(Sheet_Name)		
	    Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ_2").Frame("leftFrame").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA").Click
	    Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ_2").Frame("leftFrame").Link("������Ϣ").Click
	    Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ_2").Frame("mainFrame").WebButton("��������").Click
	    Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ_2").Frame("mainFrame").WebButton("�ر�").Click
Browser("ELV �����Ϲ�ϵͳ").Page("ELV �����Ϲ�ϵͳ_2").Sync
End Function

Function toCheck(Sheet_Name)		
	call menuSelect("�ʽ����-��̨ҵ��-���ڴ��-�����տ�-ҵ�񸴺�")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'��ʽҵ��Ľű������￪ʼ
	'�����տ�-ҵ�񸴺˹���ҳ��
		
		'�տ��ʻ����
		curPage.Image("index:=0","name:=button").Click
		If  popPage.Exist Then
			popPage.Link("text:="&DataTable("�տ��˻����", Sheet_Name)).Click
		End If
		'��������Ϣ
		curPage.Image("index:=1","name:=button").Click
		If  popPage.Exist Then
			popPage.Link("text:="&DataTable("������", Sheet_Name)).Click
		End If
		'������
		curPage.WebEdit("name:=strDeclarationNo").Set DataTable("������", Sheet_Name)
		'���
		curPage.WebEdit("name:=dAmount").Set DataTable("���", Sheet_Name)
		
		'���ƥ�䰴ť
		curPage.WebButton("name:= ƥ �� ").Click
		
		If popDialog.Exist(3) Then
		    str=popDialog.Static("window id:=65535").GetROProperty("text")
			reporter.ReportEvent micFail,"�����տ�-ҵ�񸴺�","ƥ�䲻ͨ����������ϢΪ��"&str
			popDialog.WinButton("text:=ȷ��").Click
		End If
		
		'���ؽ��׺�
		DataTable("transNO", Sheet_Name) = curPage.WebEdit("name:=textfield2352").GetROProperty("value")
		curPage.WebButton("name:= �� �� ").Click
		popDialog.WinButton("text:=ȷ��").Click
		
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"�ɹ�")>0 Then
			popDialog.WinButton("text:=ȡ��").Click
			Reporter.ReportEvent micPass,"���˳ɹ�","���˳ɹ���"&str
			logPrint("����"&DataTable("transNO", Sheet_Name)&str)
		else
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent micFail,"����ʧ��","����ʧ�ܣ�"&str
			logPrint("����"&DataTable("transNO", Sheet_Name)&str)
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toUncheck(Sheet_Name)		
	call menuSelect("�ʽ����-��̨ҵ��-���ڴ��-�����տ�-ҵ�񸴺�")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'��ʽҵ��Ľű������￪ʼ
		
		'�����տ�-ҵ�񸴺˹���ҳ��
		curPage.WebButton("name:= ���Ӳ���  ").Click
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		'����ȡ�����˱�ע��Ϣ
		curPage.WebEdit("name:=strCheckAbstractStr").Set "ȡ������"
		curPage.WebButton("name:= ȡ������ ").Click
		popDialog.WinButton("text:=ȷ��").Click
		str=popDialog.Static("nativeclass:=Static","window id:=65535").GetROProperty("text")
		If instr(str,"�ɹ�")>0 Then
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent micPass,"ȡ�����˳ɹ�","���˳ɹ���"&str
			logPrint("����"&DataTable("transNO", Sheet_Name)&str)
			else
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent micFail,"ȡ������ʧ��","����ʧ�ܣ�"&str
			logPrint("����"&DataTable("transNO", Sheet_Name)&str)
		End If
		curPage.WebButton("name:= �� �� ").Click
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toModify(Sheet_Name)		
	call menuSelect("�ʽ����-��̨ҵ��-���ڴ��-�����տ�-ҵ����")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'��ʽҵ��Ľű������￪ʼ
		
		'�����տ�-ҵ������ҳ��
		curPage.WebButton("name:= ���Ӳ���  ").Click
		
		
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		curPage.WebButton("name:= �� �� ").Click
		popDialog.WinButton("text:=ȷ��").Click
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"�ظ�")>0 Then
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent  micWarning,"�ظ�����","�ظ����ף�"&DataTable("transNO", Sheet_Name)
			str=popDialog.Static("nativeclass:=Static","window id:=65535").GetROProperty("text")
				If instr(str,"�ɹ�")>0 Then
				popDialog.WinButton("text:=ȷ��").Click
				Reporter.ReportEvent micPass,"�޸ĳɹ�","��ʾ��Ϣ��"&str
				else
				popDialog.WinButton("text:=ȷ��").Click
				Reporter.ReportEvent micFail,"�޸�ʧ��","��ʾ��Ϣ��"&str
				End If
		elseIf instr(str,"�ɹ�")>0 Then
				popDialog.WinButton("text:=ȷ��").Click
				Reporter.ReportEvent micPass,"�޸ĳɹ�","��ʾ��Ϣ��"&str
		else
				popDialog.WinButton("text:=ȷ��").Click
				Reporter.ReportEvent micFail,"�޸�ʧ��","��ʾ��Ϣ��"&str
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

Function toDelete(Sheet_Name)		
	call menuSelect("�ʽ����-��̨ҵ��-���ڴ��-�����տ�-ҵ����")
	Set curPage = Browser("creationtime:=0").Page("index:=0").Frame("name:=mainIframe")
	Set popPage = Browser("creationtime:=1").Page("index:=0")
	Set popDialog=browser("creationtime:=0").Dialog("text:=Microsoft Internet Explorer ")
	
	'��ʽҵ��Ľű������￪ʼ
		
		'�����տ�-ҵ������ҳ��
		curPage.WebButton("name:= ���Ӳ���  ").Click
		
		
		curPage.Link("text:="&DataTable("transNO", Sheet_Name)).Click
		
		curPage.WebButton("name:= ɾ �� ").Click
		popDialog.WinButton("text:=ȷ��").Click
		str=popDialog.Static("window id:=65535").GetROProperty("text")
		If instr(str,"�ɹ�")>0 Then
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent micPass,"ɾ���ɹ�","ɾ���ɹ���"&str
			else
			popDialog.WinButton("text:=ȷ��").Click
			Reporter.ReportEvent micFail,"ɾ��ʧ��","ɾ��ʧ�ܣ�"&str
		End If
		
	Set curPage = Nothing
	Set popPage = Nothing
	Set popDialog = Nothing	
End Function

End Class
