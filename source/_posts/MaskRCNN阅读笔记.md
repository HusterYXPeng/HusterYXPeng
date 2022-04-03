---
layout: post
title: MaskRCNN阅读笔记
date: 2017-11-30 22:07 +0800
last_modified_at: 2017-11-30 22:07 +0800
categories: 计算机视觉
tags: [实例分割, MaskRCNN]
toc:  true
---

### 一、摘要
 mask-rcnn本质上在fasterrcnn的基础上加了一个预测每个二值掩膜mask的分支，相当于在之前fasterrcnn的基础上，fasterrcnn将目标框出，maskrcnn在目标框内对目标做一个实例分割。整理思路如下：
 ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/e5dbeb9678afee54cf311ddeb67e4f77.png)
  在faster的基础上预测出了每个目标框，maskrcnn在框内对每个像素再进行预测，预测每个像素是否属于这个框所属的类别。eg：上图上，最大的那个框预测为人这一类别，那么mask相当于对这个框内每个像素是不是人做了一个二分类，最后生成了一个二值的掩膜。
### 2、介绍
 在fasterrcnn的基础上添加一个mask的分支，对rpn之后的每个roi区域，预测一个二值的mask掩膜。提出了一种roialign的层，roialign层在roipooling层的基础上做了改进。在roipooling层计算时，是将RPN的输出的结果即roi区域（注意这时的roi区域信息是对应原图的坐标信息），映射到feature map上，再对feature map上对应的区域划分成7*7的区域，再对每个区域进行maxpooling最终得到了7*7的feature，给后面的网络进行预测。这么做在做分类的时候影响不大，但是在做像素级的实例分割有很大的问题，即7*7
 的图和原图上对应的区域没有很好的空间位置对应关系，出现了misalignment的问题。因此，提出了roialign层，roialign层对提高分割精度有很大的作用，大约提高了10%到50%的精度。
### 3、roialign层
 最核心的点。相对roipooling会造成最后的7*7和原始的roi区域对不齐的情况，首先roi的坐标是对应的原图的，从原图到feature map有一个stride的对应关系，  比如原始roi是100*100的，在原图的(15,15)的位置，考虑stride=16，那么对应到feature map上会是 100/16和100/16的区域，坐标是(15/16, 15/16)的点，再对该区域做7*7 划分，7*7的图上，横坐标1的距离对应到feature上就是100/112的距离，那么7*7的图上第一个点(0,0)的点对应到feature map上对应的坐标是(15/16, 15/16)，那么怎么得到7*7的图上的(0,0)处的值呢，很明显，根据(15/16, 15/16)在feature map上对这个坐标周围的4个整点的坐标进行双线性插值，即得到了*7的图上的(0,0)处的值。同理，得到7*7的图上的坐标为(x,y)处对应到feature map上的坐标为(15/16+x * 100/112, 15/16+y* 100/112)，这个坐标是是一个小数，即在feature map上对该坐标点周围的4个整点坐标进行插值即可。这也就对应了文中的：
 
![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/6735ff370a8d6b01e073d0c5ba927aef.png)
### 4、mask分支
 经过roialign后后每个roi区域对应的就是m*m的图（在上面的例子上m=7），mask分支就是对每个roi产生的K+1个m*m的二值掩膜，如果目标由20种，那么这里会预测20个m*m的二值掩膜，这里为啥这么需要遇到21个呢，一方面20种目标还有一种是背景，所以是21；另一方面，在计算loss的时候，21个二值mask只有一个有作用，比如这个roi区域的fastrcnn的部分预测为类别1，吧么这21个mask只有第2个参与loss的计算，这样相当于将roi的类别预测和这里的二值分割分开了，也就是论文说的解耦了。每个mask都是二值的0或者1，对应的就是该值是否就是roi对应的类别，最后计算的也是一个二进制损失，最后在roi上的整体损失是： cls分类损失+box坐标回归损失+mask掩膜损失。对应论文中的：
 ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/6037c46e565826ab6d43760e48dc0df5.png)
 注意的就是：最后m*m的mask是resize到roi的大小和原图做的损失。
  ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/4d104a14bf9127243de26f812355d781.png)
 
### 5、拓展
  在论文的最后指出，该方法不仅可以用于像素级的实例分割，还可以用于人体姿态估计等。下面是论文的结果：
  ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/2a1b6d12cdc6eb1080247f7d85cf9ff0.png)
 以及在人体姿态估计上的结果：
 ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/9c53d4e7dd97e78c9ffd0c098ac07e2c.png)
 
 


## 后记
 以上也是自己的一些理解，因为官方的代码一直没有出来，所以还是有些不确定。感觉整个文章核心的点就是RoiAlign层的理解。（https://github.com/zuokai/roialign/blob/master/roi_align_layer.cpp）这是网上的一个基于caffe的roialign层的实现源码，可以对比caffe的roi_pooling层的源码进行对比，可以发现两者的区别。