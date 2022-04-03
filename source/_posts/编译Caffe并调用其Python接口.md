---
layout: post
title: 编译caffe并调用Python接口
date: 2017-11-23 22:07 +0800
last_modified_at: 2017-11-23 22:07 +0800
categories: 深度学习
tags: [深度学习, Caffe]
toc:  true
---

### 1  linux下调用调用caffe的C++接口
 方法1：直接写sh脚本文件，再运行sh文件即可，这种最简单，也是最常用的，新手可以参照./examples/下的各种实例sh文件。
 方法2：在CAFFE_ROOT目录下，直接在linux的命令行窗口运行 ./build/tools/caffe 后面加上相应的参数即可。
### 2、、linux下调用调用caffe的python接口
 在linux中编译caffe的时候，一般会编译生成C++的接口，但是不会生成python或者是matlab的接口，需要手动编译python的接口。
 1、编译python接口，在CAFFE_ROOT下执行以下命令：
```
make pycaffe -j32
```
 即可，这个32的值与自己的GPU有关。编译后的文件主要在CAFFE_ROOT/python文件夹下。
 2 调用python接口
 编译成功后，如果直接进入python的环境，再import caffe会提示，caffe不存在：
 ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/a364bdf0e7ceaad178fe9f216d8ea2de.png)
 是因为编译后，python接口的caffe还没有进python的环境。
 **3、方法1:临时使用的方法：**
在CAFFE_ROOT下执行以下命令：

```
 export PYTHONPATH=python   #后面就是生成python接口文件的存储位置，如果这里不是caffe的根目录，后面的python文件夹的位置路径需要对应修改
```
 注意：这里必须是PYTHONPATH，这是规定好的。
 以上命令相当于将python接口临时加入了python环境。
 ![这里写图片描述](https://img-blog.csdnimg.cn/img_convert/1e5beda4cabeb881cd24b81de30e1cd6.png)

 方法2：直接将CAFFE_ROOT/python这个路径加到.bashrc文件中。一般.bashrc文件在你用户的路径下，在用户的home目录下，输入**ls -al** 这个命令就可以查看home目录下所有的文件，包括隐藏的文件。
 打开.bashrc文件，将python的路径加到环境变量里就可以了，即将下面这个加到文件最后即可。
```
export PYTHONPATH=home/yxp/caffe/caffe/python   #这里必须是绝对路径，从后home开始
```
 一定注意:这里必须是绝对路径，从整个系统的home路径开始，不然还是错的。这样后，就可以一直生效了。而且在自己的用户下所有的目录中都是生效的。上面的临时就不是的。