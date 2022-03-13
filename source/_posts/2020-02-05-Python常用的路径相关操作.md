---
layout: post
title: Python常用的路径相关操作
date: 2020-02-05 23:18 +0800
last_modified_at: 2020-02-05 01:08:25 +0800
tags: [Python, 路径操作]
toc:  true
---
{: .message }

## 遍历文件夹

```
root  = "C\yyy"
os.listdir(root)
```

作用：遍历root文件夹下所有的文件名

注意：

- 可以获取root文件夹下所有文件夹和文件的名字
- 返回值是一个list

## 判断一个路径是文件名还是文件夹

（1）判断一个路径是不是已经存在的文件的文件名

```
root  = "C\yyy\a.txt"
os.path.isfile(root)
```

注意：

- 路径必须是已经存在的文件的路径名

（2）判断一个路径是不是已经存在的一个文件夹的路径

```
root  = "C\yyy"
os.path.isdir(root)
```

## 判断一个路径(文件名或者文件夹名)是否存在

无论是文件路径还是文件夹路径，判断该路径是否是存在的

```
root  = "C\yyy"
os.path.exists(rootpath)
```

## 路径合并

将多个路径合并成一个综合路径

```
rootpath = "F:"
path2 = "11.txt"
os.path.join(rootpath,path2)
```

注意：

- 合并操作会自动处理路径最后的斜杠问题
- 可以合并多个路径，即join的参数可以有三个及以上

## 路径分离相关

（1） 分离路径获得**后缀名**

输入一个文件路径，返回该文件的文件名路径和后缀名。以点号分离字符串。

```
rootpath = "F:\总结\Python语言\环境配置\mm.txt"
temp = os.path.splitext(rootpath)

# 输出：temp = ('F:\总结\Python语言\环境配置\mm','.txt')
```

注意：

- 输出的文件名是路径
- 函数返回值是一个tuple，即（）

（2）分离路径获得**文件名**

输入一个文件路径，返回该文件的文件名（含后缀）。以最后一个"/"分离字符串。

```
rootpath = "F:\总结\Python语言\环境配置\mm.txt"
temp = os.path.split(rootpath)

# 输出：temp = ('F:\总结\Python语言\环境配置','mm.txt')
```

注意：

- 可以获得路径中的文件名（含后缀）
- 函数返回值是一个tuple，即（）

（3）分离路径获得**磁盘名**

输入一个文件路径，返回该路径的磁盘名。以第一个"/"分离字符串。

```
rootpath = "F:\总结\Python语言\环境配置\mm.txt"
temp = os.path.splitdrive(rootpath)

# 输出：('F:', '\\总结\\Python语言\\环境配置\\mm.txt')
```

（4）直接获得路径最后文件名

```
path = "F:\总结\Python语言\环境配置\mm.txt"
os.path.basename(path)

# 输出： “mm.txt”
```

作用：输入一个路径，返回该路径中最后的文件名（含后缀）

注意：

- 与前面的不同，这里返回的就是一个字符串

## 绝对路径相关

（1）判断一个路径是否是绝对路径

```
rootpath = "F:\总结\Python语言\环境配置\mm.txt"
os.path.isabs(rootpath)

# 判断一个路径是不是绝对路径
```

（2）返回一个路径的绝对路径

```
path = "../txt.txt"
pp = os.path.abspath(path)

# 输出：C:\Users\hust_yxp\Desktop\txt.txt
```

## 获得文件的一些属性信息

（1）获得path的文件的大小（字节）

```
>>> os.path.getsize('c:\\boot.ini') 
299L 
```

（2）获得path的文件或者目录最后存取时间

```
os.path.getatime(path) 
```

（3）获得path的文件或者目录最后修改时间

```
os.path.getmtime(path) 
```

（4）获得path的文件或者目录创建时间

```
os.path.getmtime(path)
```

注意：2到4中获得时间无法直接显示成时间，要做处理。以2为例：

```
import time
import os
fileName=‘m.txt‘
fileTimesOfAccess=time.localtime(os.path.getatime(fileName))

# 获取详细具体时间
yearOfAccess=fileTimesOfAccess.tm_year
monthOfAccess=fileTimesOfAccess.tm_mon
dayOfAccess=fileTimesOfAccess.tm_mday
hourOfAccess=fileTimesOfAccess.tm_hour
minuteOfAccess=fileTimesOfAccess.tm_min
secondOfAccess=fileTimesOfAccess.tm_sec

print('文件最近访问时间:  ',yearOfAccess,'年',monthOfAccess,'月',dayOfAccess,'日','  ',hourOfAccess,'时',minuteOfAccess,'分',secondOfAccess,'秒')

```

## 返回当前path的上一级目录

作用：输入一个路径获得path的上一级目录

```
path = "F:\csji\sji"
pp = os.path.dirname(path)

# 输出： 'F:\csji'
```

## 获得当前目录

```
os.getcwd()

# 返回当前运行的工程目录
```

注意：

- 返回的是当前运行的工程目录，注意不是代码py文件所在的目录

## 路径的规范化

规范化路径

```
path = "F:\csji\sji\sxuio\sacua\mmscji\../../"
pp = os.path.normpath(path)

# 返回：'F:\csji\sji\sxuio'
```
