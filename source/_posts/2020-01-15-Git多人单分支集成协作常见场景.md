---
layout: post
title: Git多人单分支集成协作常见场景
date: 2020-01-15 23:18 +0800
last_modified_at: 2020-01-15 01:08:25 +0800
tags: [Git基础, Git提交代码]
toc:  true
---
{: .message }


针对多人协作使用Git的场景

## 不同人修改不同文件场景

即：p1修改了工程的f1文件，p2修改了工程的f2文件，p2已经提交了commit，p1再来提交的时候，就会显示不是fast-forward的情况。

1、使用 git clone 的时候注意点：

```
git clone  xxx.git   xxxx2
```

作用：在git clone后指定clone到本地后的文件夹命名为xxxx2。

2、git fetch 说明：

```
git fetch origin     //吧origin远端代码fetch到本地	
```

注意：这个时候，远程分支到本地后，不会对本地代码有影响。

使用：

```
git branch -av       //查看本地和远程分支情况
```

3、使用 get merge 命令对本地代码与刚fetch的远程分支的代码进行merge

```
git merge   xxx       //xxx为刚fetch下来的远程分支
```

由于是不同人修改的不同的文件，可以直接merge，不会有冲突。



## 不同人修改同一文件的不同区域

1、本地修改代码前使用 git pull

在每次修改代码中，先执行 git pull 命令，将远程分支与本地分支同步，将本地分支做一个更新。

```
git pull
```

直接 git pull 即可，无需任何其他命令。

2、解决步骤：同上。



## 不同人修改同一文件的相同区域

即：merge的时候存在 conflict 的时候。

1、方法1：

直接使用git merge 命令：

```
git merge xxx   // xxx为远程分支
```

有conflict：打开冲突文件，修改

注意：修改后一定要git add 和commit  将修改再提交一个commit；或者是直接add，再使用 git merge --continue即可。

最后再提交。

2、方法2： git cherry-pick commitID

- 将远程分支fetch到本地
- 切换到fetch的分支
- cherry-pick 后加原来冲突分支的那个commit的ID

遇到冲突：修改。

修改后：git add后，提交一个commit 或者 git cherry-pick --continue 即可。


## 不同人修改同一个文件的名字

1、方法： git push 会有冲突。

pull一下，本地会有两个文件，自己决定用哪个文件名，删除哪几个，再git add和commit即可。

注意git 中删除文件：git rm xxxx；
