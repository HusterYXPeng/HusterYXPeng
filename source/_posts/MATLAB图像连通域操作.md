---
layout: post
title: MATLAB图像连通域操作
date: 2017-09-19 22:07 +0800
last_modified_at: 2017-09-19 22:07 +0800
categories: 图像处理
tags: [MATLAB, 图像处理]
toc:  true
---

最近在用MATLAB做一个图像处理算法的仿真，其中涉及到了连通域的操作，因为平时对C++比较熟悉，对matlab语言不熟悉，折腾了好久，算是做一个记载吧。

### 1、bwareaopen函数
#### *用法:
```
img = bwareaopen(img,set_noise);   
%% 作用：对img图像做连通域操作，去除那些像素数据小于set_noise数目的连通域块，将其全部置为0。
%% set_noise参数： 设置需要去除的连通域的像素数目的阈值
%% 返回的是二值图像，图像中是连通域的部分都被置为1，其余的都是0
```
**注意几点：**
1、连通域操作，**操作的连通域的是白色部分**，如果需要处理的图中需要做连通域的部分是黑色的，就需要做一个灰色反转。

#### 灰度反转
1、如果是灰度图像： img  = 255 - img;
2、如果是二值图像： img = 1 - img;



### 2、bwlabel和regionprops函数
####函数功能：
bwlabel函数  -- 对连通域进行操作，标记
regionprops函数 -- 统计连通域标识图像的连通域面积分布
```
%% 实现功能： 对二值图像做连通域操作，找到最大连通域区域的下标，将相应的连通域去掉（置0）
%% 代码：
 L = bwlabel(img2);   % 对连通区域进行标记 
 %% 这一步之后，一个连通域会被相同的数字标识，数字最大值就是连通域的个数 。不同的正整数元素对应不同的区域，例如：L中等于整数1的元素对应区域1；L中等于整数2的元素对应区域2；以此类推。
 stats = regionprops(L);  
 %% 统计上一步标记图像中的连通域的面积分布
 Ar = cat(1, stats.Area);  
 ind = find(Ar ==max(Ar));%找到最大连通区域的标号  
 img2(find(L==ind))=0;%将其区域置为0  
```

### 3、自己代码工程
```
clear all;
% 路径
SamplePath1 =  'image\';  %存储图像的路径
savepath = 'image11\';        %
fileExt = '*.jpg';  %待读取图像的后缀名
%获取所有路径
files = dir(fullfile(SamplePath1,fileExt)); 
len1 = size(files,1);
%遍历路径下每一幅图像
for i=1:len1;
   fileName = strcat(SamplePath1,files(i).name); 
   image = imread(fileName);
   image = rgb2gray(image);  %灰度化
   
   %调用自己分割函数
   img2 = segmentation(image,2,'pso');
   img2 = 1 - img2;		%灰度反转
   %连通域去掉小区域
   set_noise=500;
   % 去除
   img2=bwareaopen(img2,set_noise);
  
   %去除最大的连通域
   L = bwlabel(img2);% 对连通区域进行标记  
   stats = regionprops(L);  
   Ar = cat(1, stats.Area);  
   ind = find(Ar ==max(Ar));%找到最大连通区域的标号  
   img2(find(L==ind))=0;%将其区域置为0 
   
	%灰度反转回来
   img2 = 1 - img2;
  
   fileName2 = strcat(savepath,files(i).name); 
   imwrite(img2, fileName2);
end
```