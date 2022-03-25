---
layout: post
title: 常用Linux命令
date: 2022-03-23 12:10 +0800
last_modified_at: 2022-03-23 12:10 +0800
categories: Linux
tags: [Linux, 命令]
toc:  true
---

## 常用Linux命令

#### 将数据从一个机器拷贝到另一个远程机器
```
scp ./xxxxx root@xx.xx.xx.xx:/home/xxx/xxxx     // 将本地文件拷贝到远程其他linux机器上
scp root@xx.xx.xx.xx:/home/xxx/xxxx ./xxxxx     // 将远程机器上某个文件拷贝到本地机器
```

#### 当前机器访问远程机器的文件夹

```
sudo sshfs -o allow other -o reconnect root@xx.xx.xx.xx:/home/data1
// 在本地机器访问远程机器上的 data1 文件夹
```

#### 列举文件夹下所有文件的大小按MB统计
```
du -csh ./xxx/xx/*
```