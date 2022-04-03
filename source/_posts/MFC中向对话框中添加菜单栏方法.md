---
layout: post
title: MFC中向对话框中添加菜单栏方法
date: 2017-05-06 22:07 +0800
last_modified_at: 2017-05-06 22:07 +0800
categories: C++
tags: [MFC]
toc:  true
---

在MFC中一般基于对话框的MFC界面是没有菜单栏的，基于文档视图结构的MFC界面是有菜单栏的，那么怎么在基于对话框的MFC界面中添加菜单栏。下面是基于网上的博客啥的自己整理的。
### 一、在资源视图中将menu加入资源视图中
1、在MFC中新建一个基于对话框的MFC界面工程，打开资源视图截图如下：

![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/8d132f0909781f4442f6bbf453b77234.png)

里面是默认没有menu资源的。这时就需要我们手动添加menu资源了。
2、在资源视图中添加menu资源
还是在资源视图中，任选一个空白的地方“右击”，弹出如下界面，选择“添加资源（A）”功能
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/cac64960da9ca18ffc8d96064d20e3f9.png)
之后在弹出的对话框中选择menu资源，再单击“新建”按钮，界面如下：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/7729252364fb40dde74d5dcffdb988ad.png)
**注意**：这个时候在工程的资源视图中已经有了menu资源。接下来就是新建menu资源了。
### 二、在资源视图添加菜单栏
1、在资源视图中添加菜单栏
步骤：在资源视图中，选中“menu”资源，右击，选择“插入Menu”，之后在资源视图的Menu下面就有了一个菜单栏，如下图：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/95a240694985ec1ddb38262ed83e58be.png)
双击具体新建的菜单栏就可以对菜单栏进行编辑了。
2、对插入的菜单栏进行编辑
（1）修改菜单栏的ID，**注意**：记住ID，后面有用
（2）修改菜单栏为我们想要的样子，如下：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/70328026606361fc97b595571fa6aa96.png)
**注意**：此处，菜单栏有个ID，菜单栏上每个项都会有ID。
### 三、将菜单栏添加到对话框界面
1、将菜单栏添加到界面
打开你新加入的菜单项，单击“项目”-->“添加现有项”，在这里选择已有的类，就是你要为其添加菜单的对话框的类，例如，***Dlg.cpp。然后确定。如下图所示：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/dd356f507622e76af77fdffc77b15e22.png)
**注意**：这里选择对话框的类的时候，一定要选择你需要添加菜单的对话框的cpp文件，特别是有多个对话框的时候一定要注意。
###**四、在对话框文件中添加相应的代码
1、在对话框类.h文件中声明CMenu变量
打开对话框头文件***Dlg.h，声明CMenu 变量,例如m_Menu;

```
CMenu m_Menu;
```

2、在对话框类.cpp文件中添加代码
打开***Dlg.cpp 文件，在***Dlg::OnInitDlg()中加入如下语句：

```
m_Menu.LoadMenu(IDR_MENU1);  //  IDR_MENU1
```

为你加入的菜单的ID，在Resource视图的Menu文件夹下可以找到。

```
SetMenu(&m_Menu);
```

这样就OK了，调试一下，菜单就已经出现在对应的对话框中。
成功运行之后的对话框界面如下：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/bf562c1c4ddaa9561307c936bee522ff.png)
成功添加了菜单栏之后就可以和在文档视图模式下一样对菜单进行操作，添加具体菜单项，以及为具体的菜单项添加消息处理函数等。


**参考博客**：http://blog.csdn.net/apxar/article/details/12690431