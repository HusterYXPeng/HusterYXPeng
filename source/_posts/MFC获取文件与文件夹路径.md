---
layout: post
title: MFC中获取文件与文件夹路径
date: 2017-09-20 22:07 +0800
last_modified_at: 2017-09-20 22:07 +0800
categories: MFC
tags: [MFC]
toc:  true
---

最近做一个MFC的小界面，需要实现这样两个功能：1、在界面上加一个按钮，单击按钮弹出一个对话框选择文件，在工程中获得文件的路径；2、在界面上加一个按钮，单击按钮弹出一个对话框选择文件夹，在工程中获取文件夹的路径。
### 一、获取文件的路径

```
// -- 按钮的消息响应函数
void CDialogSampled::OnBnClickedButtonOpen()
{
	// TODO: 在此添加控件通知处理程序代码
	CString m_strFilePath = _T("");

	//打开图像文件，获取文件路径名
	LPCTSTR szFilter =_T("JPG(*.jpg)|*.jpg|BMP(*.bmp)|*.bmp|ALLSUPORTFILE(*.*)|*.*||");
	CFileDialog dlgFileOpenImg(TRUE,NULL,NULL,OFN_HIDEREADONLY|OFN_OVERWRITEPROMPT,szFilter,NULL);
	//打开图像
	if(dlgFileOpenImg.DoModal() == IDOK)
	{		
		//读取图像文件名
		m_strFilePath = dlgFileOpenImg.GetPathName();
	}
	else
	{
		return;
	}
}
```


### 二、获取文件夹的路径
此处借鉴了http://blog.csdn.net/computerme/article/details/41307849

```
//选择样本图像保存路径
void CDialogSampled::OnBnClickedButtonImageSavePathSelect()
{
	// TODO: 在此添加控件通知处理程序代码
	CString m_saveFilePath;
	//打开图像文件，获取文件路径名
	TCHAR szPath[_MAX_PATH];  
	BROWSEINFO bi;  
	bi.hwndOwner = GetSafeHwnd();  
	bi.pidlRoot = NULL;  
	bi.lpszTitle = "Please select the input path";  
	bi.pszDisplayName = szPath;  
	bi.ulFlags = BIF_RETURNONLYFSDIRS;  
	bi.lpfn = NULL;  
	bi.lParam = NULL;  
  
	LPITEMIDLIST pItemIDList = SHBrowseForFolder(&bi);  
  
	if(pItemIDList)  
	{  
		if(SHGetPathFromIDList(pItemIDList,szPath))  
		{  
			m_saveFilePath = szPath;  
			m_saveFilePath = m_saveFilePath+"\\";
		}  
  
		//use IMalloc interface for avoiding memory leak  
		IMalloc* pMalloc;  
		if( SHGetMalloc(&pMalloc) != NOERROR )  
		{  
			TRACE(_T("Can't get the IMalloc interface\n"));  
		}  
  
		pMalloc->Free(pItemIDList);  
		if(pMalloc)  
			pMalloc->Release();  
		UpdateData(FALSE);  
	}  
}
```