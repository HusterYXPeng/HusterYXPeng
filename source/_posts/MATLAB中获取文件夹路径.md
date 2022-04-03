---
layout: post
title: Matlab中获取文件夹路径
date: 2017-09-20 22:07 +0800
last_modified_at: 2017-09-20 22:07 +0800
categories: MATLAB
tags: [MATLAB]
toc:  true
---

需要写一个MATLAB的小程序，其中需要指定一个文件夹，返回这个文件夹下所有文件夹的名字，以及文件夹的个数。
### 代码如下：
```
function [names,class_num] = GetFiles()
files = dir('data\多类样本\');
size0 = size(files);
length = size0(1);
names = files(3:length);
class_num = size(names);
end
```

### 结果：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/82c9beef0be06d4a6975aab0af3924e1.png)

电脑上文件夹目录： data->多类样本->1\2\3\4\5,为5个文件夹。但是返回的files变量中有7个路径。![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/23f7fe4f0a391880329a92e9cf7fb66e.png)
前两个可以忽略，用dir命令，在matlab中因为采用了类似于linux的文件结构，所以会产生前面2个路径。
最后获取files的第3到7行赋值给names变量后的结构如下：
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/754774d73a389fda67a5edd14b787ae3.png)

### 总函数：

```
function [names,class_num] = GetFiles(SamplePath1 )
SamplePath1 = 'data\sample\';
files = dir(SamplePath1);
size0 = size(files);
length = size0(1);

for i=3:length;
   fileName = strcat(SamplePath1,files(i,1).name); 
   names(:,:,i-2) = fileName;
end
class_num = size(names);
end
```
