---
layout: post
title: Git-lfs命令
date: 2022-03-23 08:18 +0800
last_modified_at: 2022-03-23 08:18 +0800
categories: Git
tags: [Git基础, Git命令]
toc:  true
---

## 将当前文件中大于50M的文件，全部用lfs跟踪起来

```
find ./ -path "./.git" -prune -o -type f -size +50M -print | cut -b 3- | xargs git lfs track 
```

## 查看当前大文件track状态

```
git lfs ls-files
```


## git lfs 基础命令
```
git lfs track xxxx    // 用lfs跟踪大文件
git add .gitattr*     // 将git lfs生成的配置文件add到缓存
```
