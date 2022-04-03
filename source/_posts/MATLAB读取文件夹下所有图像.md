---
layout: post
title: MATLAB读取文件夹下所有图像
date: 2017-07-26 22:07 +0800
last_modified_at: 2017-07-26 22:07 +0800
categories: MATLAB
tags: [MATLAB, 矩阵操作]
toc:  true
---

在matlab编程中经常遇到需要处理各种路径的问题，很是蛋疼，这里将最近的编程中经常遇到的有关路径的一些常见的操作进行总结。
## 1 主要函数和命令
### fullfile函数
利用文件各部分信息创建 合成完整文件名，主要用于路径的拼接。

```
%用法形式
anws = fullfile('dir1','dor2'...'filename')
%举例
fullfile('D\data\data1\','data2','img0.jpg')
%返回路径：'D\data\data1\data2\img0.jpg'
```

### dir函数
读取一个文件夹下的所有的文件，并存储到一个结构体中。在结构体中存储了该文件夹下所有的文件的名字以及文件的创建日期。

### size函数
size（data, n）返回多维矩阵的第n维的维度，eg：data为一个图像数据100*100*3，size（data, 1）返回值为100。

### strcat函数
拼接两个字符串形成路径

### imread函数

```
imgdata = imread(imgpath); %%读取图像数据
```
###imresize函数
将图像缩放到指定大小。

```
image = imresize（image,[m n]）; %将图像缩放到m*n的大小
```


## 2 MATLAB代码
### 代码
```
SamplePath1 =  'data\';  %存储图像的路径
fileExt = '*.jpg';  %待读取图像的后缀名
%获取所有路径
files = dir(fullfile(SamplePath1,fileExt)); 
len1 = size(files,1);
%遍历路径下每一幅图像
for i=1:len1;
   fileName = strcat(SamplePath1,files(i).name); 
   image = imread(fileName);
   image = imresize(image,[61 61]);
   norubbish_data(:,:,:,i) = image;
end
```
### 核心讲解
需要注意理解的是：**在matlab中所有的变量是都以矩阵的形式存在的，上面代码中files为一维的矩阵，所以索引其每一维需要一维就可以；在matlab中图像数据是三维的，所以一个存储很多图像的变量就必须是四维的，前三维是图像的参数，第四维是图像索引。**