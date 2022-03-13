---
layout: post
title: Git提交代码基础应用
date: 2020-01-01 23:18 +0800
last_modified_at: 2020-10-01 01:08:25 +0800
tags: [代码提交, Github, Git提交代码]
toc:  true
---
{: .message }


## 删除无效的分支

```
git branch -d branch1   //不一定成功删除
git branch -D branch2   //一定成功删除，强制删除
```



## 修改最新commit的message

已经提交了commit，但是其message写错了，需要修改下：（即修改最新commit的message）

```
git commit --amend   //进一步编辑后保存即可
```



## 修改老旧commit的message

即修改非第一个commit的mesage：

```
git rebase -i commitID  // commitID为待修改message的前一个commit的ID（注意是前一个commit的ID）

第二步：在弹出vim中，将待修改的message的commit的ID前的pick改为r，再wq退出。

再修改对应的commit的message即可。
```

注意：这种处理方式，会修改待修改message的commit的ID以及其后面的所有commit的ID。

但是其所有commit的内容和修改都不会改变，只改了待修改message的commit的message。


## 将连续的多个commit合并为1个commit

假设 commit 的提交记录为： commit1、commit2、commit3、commit4、commit5，这是时间顺序，head在commit5，要将中间的commit2、commit3和commit4合并。

```
git rebase -i commit1 
在弹出的vim中：
将commit2和commit3前面的pick改为 squash，再wq  （注意：不能三个commit都改为squash，要保留一个不变）
在vim中：
写新的commit的信息。
```

注意： git rebase -i commitX

- 接下来vim中会展示从commitX之后一直到head的所有的commit（包括head，但不包括commitX）
- 排列顺序：从上到下，commit的顺序依次靠前



## 将不连续的多个commit合并为一个commit

假设 commit 的提交记录为： commit1、commit2、commit3、commit4、commit5，这是时间顺序，head在commit5，要将中间的commit2和commit4合并。

```
git rebase -i commit1 
在弹出的vim中：
将 commit2和commit3的顺序换下
将commit2前面的pick改为 squash，再wq  （注意：不能三个commit都改为squash，要保留一个不变）
在vim中：
写新的commit的信息。
```


## 比较修改 git diff

1、比较**当前修改与暂存区**对应版本的差异：（这个时候修改还没在缓存区，即没有add）

```
git diff
```

2、add后就到了缓存区，比较**暂存区与head**指针对应版本的差异：

```
git diff --cached
```

注意：理解暂存区的概念，修改只有add后才能到暂存区中去。

进一步：一次性修改了多个文件，可以一个个的add到暂存区，git diff 后再一个个commit。



## 工作区、暂存区和两者的diff

1、工作区：当前修改的，还未add的时候，修改在工作区

2、暂存区：修改 add 后，修改就到了暂存区。

3、**git diff  -- filename**： 代表比较某个filename文件的差异。

**git diff --cached 后面可以加 -- 再加 filename**。



## 将暂存区的修改（恢复到HEAD版本）去掉恢复到工作区

背景：对代码进行修改，并已经add到暂存区，但是现在不想要这个修改，咋办。

```
git reset HEAD   //将暂存区恢复到与HEDA指针相同的版本的代码
git reset HEAD -- filename    // 将暂存区的某个文件恢复到与HEDA指针相同的版本的代码
```

这个时候要注意：暂存区的修改不是完全都没有了，而是恢复到了工作区。

这个时候： git status ，之前add的修改，就变成了红色了。



## 将工作区恢复成暂存区的版本

背景：开始进行了修改，并进行了add，修改添加到了暂存区；后面又一次在工作区进行了修改，但是呢发现这个修改不好（并未add还在工作区的修改），想把工作区恢复成暂存区的代码版本。

```
git checkout -- filename     //对工作区中filename文件恢复成暂存区的版本
```



## 暂存区与工作区

```
git status
```

- 绿色：暂存区
- 红色：工作区



## 消除最近几次的commit，暂存区和工作区都恢复到某个commit的版本

背景：文件进行了3次修改，提交了三个commit，分别是commit1、commit2、commit3（最后一个），现在要把代码（HEAD指针、工作区、暂存区）都恢复到 commit1的代码版本。

```
git reset --hard commit1(ID)
```

命令慎用：因为会直接将commit删除，修改都没了，commit2和3的修改永远都找不回来了。这种操作会直接导致本地文件的改变。


## 比较不同commit的指定（所有）文件的差异

背景：比较不同commit对应代码版本的区别，或者某个文件的区别

```
git diff commitID1 commitID2 -- filename   //比较 commit1和2对应代码版本中 filename文件的差异
git diff commitID1 commitID2  //不加filename代表所有比较所有文件的区别
```

注意理解：不同分支名就是代表了分支了HEAD指针，不同分支HEAD指针本质上也是指向了某个commitID，所以可以直接：（不同分支分支名本质就是对应分支最新commit的ID）

```
git diff branch1 branch2 -- filename    
//比较 branch1和2两个分支最新代码版本的filename文件的差异
```



## 正确删除文件

背景：一般情况下 删除文件，都是现在工作区  rm -rf  filename， 删除文件。然后在add，提交一个删除文件的commit。可以直接通过 git  的 rm命令：

```
git rm filename   //从工作区和暂存区同时删除了该文件
```



## stash相关操作

背景：当前在工作区修改，修改还没有到缓存区，又接到一个新的需求，要开发，那么，可以当前工作区的修改存起来，然后再在当前的工作区进行新需求的开发，开发后需求的修改保存到暂存区后，再进行吧之前保存的工作区的修改拿出来继续修改。

```
git stash    //将当前工作区的修改缓存起来
```

注意：git stash  再 git status 工作区就是clean的了。

```
git stash list   //查看当前保存了那些 stash的内容，每次stash一下都会压栈保存，pop后就没了
```

注意：git stash本质是将修改放到一个堆栈中，可以多次 stash，每次pop一下弹出一个最新保存的。

恢复缓存区的修改：

```
git stash apply   //将当前缓存区的修改拿出来放到工作区，但是缓存区的堆栈不变
git stash pop     //将当前缓存区堆栈的最新修改拿出来放到工作区，但是现在缓存区会改变，即 git stash                       list 的结果会改变。
```



## 指定不需要Git管理的文件

进： www.github.com/github/gitignore  可以看官方的 ignore文件如何写。（github针对不同的编程语言和框架会有不同的gitingore的模板）

写在 gitignore 中文件都是不会被 git 管理的。

eg：比如一些编译后的结果，比如C++编译后的exe文件等都是需要加到git管控中的，因为exe文件是可以由代码编译生成的。

注意：gitignore必须在代码工程目录下，且必须是隐藏文件，即 **.gitignore** 文件。

将不需要管的文件夹、文件、或者特定后缀的文件添加到 .gitignore 文件中即可。



## GIt仓库本地备份

1、常用协议：

（1）本地协议：（本地之间 git 仓库的移动与备份）

- 哑协议
- 智能协议

哑协议传输进度不可见，智能协议传输速度课件，智能协议更快。

（2）非本地协议

- http/https：采用账号和密码对接
- ssh：采用一堆秘钥对接

2、注意理解：

Git中的仓库的概念，仓库可以理解为一个代码库，这个Git代码库可以在本地，也可以在远程，那么就存在远程与远程、远程与本地、本地与本地三种形式的Git仓库之间的传输。

要注意的是：GIt本地仓库之间也是可以通过协议传输复制、push等操作的。eg：可以在C盘创一个Git仓库，在D盘clone一下，然后，提MR、push等都push到C盘的那个仓库。这个时候 git remote add xx的时候，给一个本地的git仓库的地址就可以了。然后还是和正常一样提MR等一样了。
