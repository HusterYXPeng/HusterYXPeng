---
layout: post
title: Git常用命令使用总结
date: 2020-01-18 23:18 +0800
last_modified_at: 2020-01-19 01:08:25 +0800
tags: [Git基础, Git命令]
toc:  true
---

#### 在本地一个文件夹新创建一个 git 仓库

```
git init 
```

这句命令后会在本地文件夹中创建一个 .git 文件夹。

默认情况下这个文件夹是无法显示的，是隐藏的，但是该文件夹是存在的。



#### git remote 相关操作

（1）创建本地库与远程库的链接

```
git remote add xxx(连接名字)    xxx.git
```

![1572437584873](/image/1572437584873.png)

连接名字用于确定一个连接。

（2）查看当前所有的remote连接

```
git remote -v
```

![1572437693305](/image/1572437693305.png)

可以查看当前所有的连接

（3）删除远程连接

```
git remote remove   xxx(连接名)
```



#### Clone

知道一个远程库的git地址，直接通过  git clone 就代码库的地址就将代码下载下来。

```
git clone   https:xxxxx.xxx.git
```

注意：这个时候会在本地自动创建一个 origin 的远程连接，这个分支默认的。



#### fetch：将远程库的某个分支拉到本地就形成新的分支

```
git fetch origin develop:dev1
#将远程origin库的develop分支最新代码拉到本地就形成新的分支dev1
```

这样好处：在于每次最新开发都可以从远程库上develop分支的最新的代码开始开发，并在本地建新的分支，到时候MR的时候，将dev1分支提到远程的develop分支。



#### 当有多个分支的时候，分支之间切换、删除分支、查看分支

（1）切换分支：

```
git checkout dev1    //由当前分支切换到dev1分支
```

注意：切换分支了当前本地目录的内容会变化。

（2）查看当前仓库有哪些分支（本地/远程）：

```
git branch       //仅查看本地分支
git branch -a    //查看当前本地和远程仓库的所有分支
```

![1572438860560](/image/1572438860560.png)

执行结果中：带*号的为当前分支

（3）删除某一分支（本地/远程）：

```
git branch dev1                           //删除本地库的dev1分支
git push origin --delete [branchname]     //删除远程库的某个分支
```

（4）本地创建分支（本地）：

- 通过fetch拉分支，可以在本地创建分支以外，还有另外办法可以创建分支。
- 通过checkout在本地创建分支。

```
git checkout -b dev4    //创建dev4分支，并切换到dev4分支，并且这个时候，假设之前在dev1分支，这时候，dev4分支下面还会有dev1分支下的内容。
---------------------------------------------------------------------------
```

（5）将本地当前分支推送到远程新分支，如果远程分支不存在，则会自动创建分支（远程）：

```
git push origin dev2:dev1    //将本地的dev2的push到远程仓库origin的dev1分支，如果远程没有dev1分支会自动创建新的dev1分支
```

#### git配置github用户名和邮箱

```
git config --global user.name "HusterYXPeng"
git config --global user.email "xxxx.@" 
```

#### 修改已经提交commit的名字和配置commit的文字

（1）修改commit名字

```
git commit --amend  # 修改提交的commit的 -m 的信息
```

（2）如何标准配置commit后面 -m 的描述信息

- 创建一个commit模板txt文件，文本内容可如下：

```
D://commit.txt
-----------------------
单号：
特性/模块名称：
修改原因：
修改内容：
修改人：
检视人：
-----------------------
```

- git配置下该txt，这样后面每次 git commit 的时候，后面不用加 -m 描述信息，后自动弹出上面txt的内容，再自己补上相关的内容即可。git 配置命令如下：

```
git config --global commit.template 模板txt的路径（eg："D://commit.txt"）
```



#### 多个已经commit的commit合并

比如现在你已经提了一个commit，现在又想改了，并生成了一个commit，加这两个commit合并。

```
git rebase -i HEAD~n  （n表示将最前面的n个commit合并）
```

然后在显示的bash中，将准备合并的n-1个commit前面的单词由 pick 改为 squash， 另外一个的commit信息可以修改为合并后commit的信息，但其前面单词还是pick，最后，保存退出即可。



#### 查看当前的commit 记录

```
git log -n    # 查看当前前n个commit的详细信息
git log    # 查看当前所有commit的详细信息
```



#### 分支合并：git merge

本地有dev1和dev2分支，将dev2合并到dev1分支。

```
git checkout dev1 # 先切换到dev1分支
git merge dev2 # 将dev2分支合并到dev1分支，合并后当前还是处于dev1分支
```



#### 将本地分支推到远程主库的分支

将本地的dev1分支push到远程主库的dev2分支。

```
git push origin dev1:dev2  # 注意本地分支在前
git push origin dev1:dev2 -f    # 将本地dev1强制推到远程dev2分支，注意这个时候，即使有冲突，也会push成功，远程库dev2分支就是本质dev1的分支一模一样，会覆盖之前dev2分支的内容。
```

