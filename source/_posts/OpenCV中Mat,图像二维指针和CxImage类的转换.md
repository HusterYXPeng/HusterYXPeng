---
layout: post
title: OpenCV中Mat,图像二维指针和CxImage类的转换
date: 2017-04-27 22:07 +0800
last_modified_at: 2017-04-27 22:07 +0800
categories: 图像处理
tags: [OpenCV, SIFT]
toc:  true
---

在做图像处理中，常用的函数接口有Opencv中的Mat图像类，有时候需要直接用二维指针开辟内存直接存储图像数据，有时候需要用到CxImage类存储图像。本文主要是总结下这三类存储方式之间的图像数据的转换和相应的对应关系。

### 一、**OpenCV的Mat类到图像二值指针的转换**
<font size="3">以下为函数代码：
```
unsigned char** MatTopImgData(Mat img)
{
	//获取图像参数
	int row = img.rows;
	int col = img.cols;
	int band = img.channels;

	//定义图像二值指针
	unsigned char** pImgdata = new unsigned char*[band];
	for(int i=0;i<band;i++)
		pImgdata[i] = new unsigned char[row*col];
	
	for(int i=0;i<row;i++)	//行数--高度
	{
		unsigned char* data = img.ptr<unsigned char>(i); //指向第i行的数据
		for(int j=0;j<col;j++)		//列数 -- 宽度
		{
			for(int m=0;m<band;m++)		//将各个波段的数据存入数组
				pImgdata[m][i*col+j] = data[j*band+m];
		}
	}
	return pImgdata;
}
```
<font size="3">需要注意的是：

（1）在Mat类中，图像数据的存储方式是BGR形式，这样得到的二维指针的数据存储顺序则为BGR形式。

（2）在Mat类中图像无论是灰度图还是RGB图都是以以为指针的形式存储的，所以在读取每个数据时，先找到每行数据的首地址，再顺序读取每行数据的BGR的灰度值。

（3）在Mat类中的row为行数，对应平时所说的图像的高度，col为列数对用图像的宽度。

### 二、**图像二值指针到OpenCV的Mat类的转换**
<font size="3">以下为函数代码：

```
Mat ImgData(unsigned char** pImgdata, int width, int height, int band)
{
	Mat Img;
	if(band == 1)		//灰度图
		Img.create(height, width, CV_8UC1);
	else                //彩色图
		Img.create(height, width, CV_8UC3);

	for(int i=0;i<height;i++)	//行数--高度
	{
		unsigned char* data = Img.ptr<unsigned char>(i); //指向第i行的数据
		for(int j=0;j<width;j++)		//列数 -- 宽度
		{
			for(int m=0;m<band;m++)		//将各个波段的数据存入数组
				data[j*band+m]=pImgdata[m][i*width+j];
		}
	}

	return Img;
}
```

### 三、**CxImage类到图像二维指针的转换**
<font size="3">以下为函数代码：

```
unsigned char** CxImageToPimgdata(CxImage Image)
{
	int width = Image.GetWidth();
	int height = Image.GetHeight();
	
	RGBQUAD rgbdata;
	unsigned char** pImgdata = new unsigned char*[3];
	for(int m=0;m<3;m++)
		pImgdata[m] = new unsigned char[width*height];

	for(int i = 0; i < width; i++)
	{
		for(int j = 0; j < height; j++)
		{
			//获取主窗口图片每一个像素的rgb数据
			rgbdata = Image.GetPixelColor(i, (height-j-1), true);					
			pImgdata[0][j*width + i] = rgbdata.rgbRed;
			pImgdata[1][j*width + i] = rgbdata.rgbGreen;
			pImgdata[2][j*width + i] = rgbdata.rgbBlue;
		}
	}

	return pImgdata;
}
```
<font size="3">需要注意的是：CxImage读取图像数据后图像的原点是在图像的左下角，与我们的传统的图像数据原点为左上角相反，所以在读取图像时"(height-j-1)"的由来。


### 总结：
<font size="3">**不同的实际情况中可能需要用到不同的图像库和对应的函数接口，因此经常需要用到这些不同的库的图像对象之间的数据的转换，实际根据情况进行下缓缓即可。**