---
layout: post
title: roi_pooling层caffe源码理解
date: 2017-12-01 21:18 +0800
last_modified_at: 2017-12-01 21:18 +0800
categories: 计算机视觉
tags: [FasterRCNN, 目标检测]
toc:  true
---

在看fasterrcnn以及和maskrcnn的时候，发现自己对fasterrcnn的roi_pooling层的原理还是不是很明白，之前只是知道roi_pooling是将rpn输出的一个roi的区域映射成一个固定大小的map，再送入后面的分类层进行分类。最近看了下roi_pooling层的源码，顿悟了。
### 1、roi_pooling在proto中的定义
 根据看caffe源码的原则，先看该成在caffe.proto文件中的定义：
```
// Message that stores parameters used by ROIPoolingLayer
message ROIPoolingParameter {
  // Pad, kernel size, and stride are all given as a single value for equal
  // dimensions in height and width or as Y, X pairs.
  // 设置pool后的map的高度和宽度
  optional uint32 pooled_h = 1 [default = 0]; // The pooled output height
  optional uint32 pooled_w = 2 [default = 0]; // The pooled output width
  // Multiplicative spatial scale factor to translate ROI coords from their
  // input scale to the scale used when pooling
  # 设置从原图到pool前的feature map的比例的大小
  optional float spatial_scale = 3 [default = 1];
}
```
 从这里可以看出，在网络定义文件中定义roi_pooling层需要设置3个参数，分别是pooled_h 、pooled_w 以及spatial_scale 的值。前2个值分别为pool后的map的宽度和高度，比如在fasterrcnn中即为6*6，后面这个值
 spatial_scale 为从原图到pool前的feature map的比例的大小，因为rpn输出的roi的坐标是基于原图的，转换到feature map，是有一个比例的。
 再来看看在fasterrcnn中，roi_pooling层的定义：
```
#========= RCNN ============
layer {
  name: "roi_pool_conv5"
  type: "ROIPooling"
  bottom: "conv5"
  bottom: "rois"
  top: "roi_pool_conv5"
  roi_pooling_param {
    pooled_w: 6
    pooled_h: 6
    spatial_scale: 0.0625 # 1/16
  }
}
```
 相关的参数设置和caffe.proto中定义的一致。

### 2、roi_pooling源码
 在这里，主要是关注其前向传播的函数。
```
namespace caffe {

// 从net定义文件中获取roi_pooling层的相关参数
template <typename Dtype>
void ROIPoolingLayer<Dtype>::LayerSetUp(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top) {
  //获取解析后的roi_pooling层的参数
  ROIPoolingParameter roi_pool_param = this->layer_param_.roi_pooling_param();
  // 如果设置的pooling后的宽度高度小于9，则报错
  CHECK_GT(roi_pool_param.pooled_h(), 0)
      << "pooled_h must be > 0";
  CHECK_GT(roi_pool_param.pooled_w(), 0)
      << "pooled_w must be > 0";
  // 以下三个参数都是在网络定义中设置的。
  // 经过pooling后的map的高度
  pooled_height_ = roi_pool_param.pooled_h();
  // 经过pooling后的map的宽度
  pooled_width_ = roi_pool_param.pooled_w();
  // 从原图到pool前feature map的比例参数，在fasterrcnn中是1/16
  spatial_scale_ = roi_pool_param.spatial_scale();
  LOG(INFO) << "Spatial scale: " << spatial_scale_;
}

template <typename Dtype>
void ROIPoolingLayer<Dtype>::Reshape(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top) {
	// 获取输入pool层feature map的C、H和W
  channels_ = bottom[0]->channels();
  height_ = bottom[0]->height();
  width_ = bottom[0]->width();
  // 设置top即输出层的blob的参数，这里的输出blob，num与输入的roi的个数一致
  // channel和输入图的feature map的输入一致； 高度和宽度是自己在net定义中设置的。
  top[0]->Reshape(bottom[1]->num(), channels_, pooled_height_,
      pooled_width_);
  // max_idx_为类定义的辅助的变量，用于记录max_pool时的最大值的来源，用于反向传播梯度的反传
  max_idx_.Reshape(bottom[1]->num(), channels_, pooled_height_,
      pooled_width_);
}

template <typename Dtype>
void ROIPoolingLayer<Dtype>::Forward_cpu(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top) {
  const Dtype* bottom_data = bottom[0]->cpu_data();			// 输入的feature map的数据的指针
  const Dtype* bottom_rois = bottom[1]->cpu_data();			//输入的roi的数据的指针
  // Number of ROIs
  int num_rois = bottom[1]->num();			// roi的个数
  int batch_size = bottom[0]->num();			// 输入的feature map的batch数
  int top_count = top[0]->count();			//输出top的blob的总的元素个数

  Dtype* top_data = top[0]->mutable_cpu_data();		//输出top的blob的数据的首地址
  caffe_set(top_count, Dtype(-FLT_MAX), top_data);			//将输出的top的blob的数据全部置为负的最大值，这样在max_pool时有用
  int* argmax_data = max_idx_.mutable_cpu_data();			//获取临时的max_idx_这个blob的数据指针
  caffe_set(top_count, -1, argmax_data);		//获取临时的max_idx_这个blob的数据全部置为-1

  // For each ROI R = [batch_index x1 y1 x2 y2]: max pool over R
  for (int n = 0; n < num_rois; ++n) 
  {
	  // 注意;实际处理的时候一次性处理的是一个batch的图像，所以feature map是一个batch的，即num数
    int roi_batch_ind = bottom_rois[0];		//获取当前roi属于输入的feature map中batch中第几个图的roi
	// 获得roi区域对应到feature map上的区域，这里round是四舍五入求近似
    int roi_start_w = round(bottom_rois[1] * spatial_scale_);
    int roi_start_h = round(bottom_rois[2] * spatial_scale_);
    int roi_end_w = round(bottom_rois[3] * spatial_scale_);
    int roi_end_h = round(bottom_rois[4] * spatial_scale_);
	// 当前roi所属于的batch的值必须小于feature map的batch_size的值，但是大于0
    CHECK_GE(roi_batch_ind, 0);
    CHECK_LT(roi_batch_ind, batch_size);

	 // 获取一个roi映射到feature map上的区域的大小
    int roi_height = max(roi_end_h - roi_start_h + 1, 1);
    int roi_width = max(roi_end_w - roi_start_w + 1, 1);
	// 根据 获取一个roi映射到feature map上的区域的大小和roi_pool后map大小，获取pool的map上一个元素在feature map上的大小
    const Dtype bin_size_h = static_cast<Dtype>(roi_height)
                             / static_cast<Dtype>(pooled_height_);
    const Dtype bin_size_w = static_cast<Dtype>(roi_width)
                             / static_cast<Dtype>(pooled_width_);

	// 获取输入的batch_size个feature map上的第roi_batch_ind个feature map的数据的地址
    const Dtype* batch_data = bottom_data + bottom[0]->offset(roi_batch_ind);

	// 遍历
    for (int c = 0; c < channels_; ++c) {
      for (int ph = 0; ph < pooled_height_; ++ph) {
        for (int pw = 0; pw < pooled_width_; ++pw) {
          // Compute pooling region for this output unit:
			// 获取每个pool后的map上每个元素所对应在feature map上的起始和终止的相对坐标
          int hstart = static_cast<int>(floor(static_cast<Dtype>(ph)
                                              * bin_size_h));
          int wstart = static_cast<int>(floor(static_cast<Dtype>(pw)
                                              * bin_size_w));
          int hend = static_cast<int>(ceil(static_cast<Dtype>(ph + 1)
                                           * bin_size_h));
          int wend = static_cast<int>(ceil(static_cast<Dtype>(pw + 1)
                                           * bin_size_w));

		  //获取每个pool后的map上每个元素所对应在feature map上的起始和终止的绝对坐标
          hstart = min(max(hstart + roi_start_h, 0), height_);
          hend = min(max(hend + roi_start_h, 0), height_);
          wstart = min(max(wstart + roi_start_w, 0), width_);
          wend = min(max(wend + roi_start_w, 0), width_);

          bool is_empty = (hend <= hstart) || (wend <= wstart);

          const int pool_index = ph * pooled_width_ + pw;
          if (is_empty) 
		  {
            top_data[pool_index] = 0;
            argmax_data[pool_index] = -1;
          }

		  // 求最大值
          for (int h = hstart; h < hend; ++h) {
            for (int w = wstart; w < wend; ++w) {
              const int index = h * width_ + w;
              if (batch_data[index] > top_data[pool_index]) 
			  {
				  // 将最大值存储
                top_data[pool_index] = batch_data[index];		//得到最大的那个数据值
                argmax_data[pool_index] = index;			//反向的时候需要用到的，需要记录最大值的那个下标
              }
            }
          }
        }
      }
      //feature map 的一个channel遍历完后，batch_data指针feature map的下一个channel
      batch_data += bottom[0]->offset(0, 1);
	  //feature map 的一个channel遍历完后，top_data指针自身的下一个channel
      top_data += top[0]->offset(0, 1);
	  //argmax_data 同上
      argmax_data += max_idx_.offset(0, 1);
    }
    // Increment ROI data pointer，转到下一个roi区域
	// 转到下一个roi的位置
    bottom_rois += bottom[1]->offset(1);
  }
}
```
需要注意以下几点:

1、输入roi_pool前的feature map是一个batch_size 的。
 
2、输出的top的blob的形状参数如下： num * C* H * W，其中num与roi区域的个数是一致的。C的值和输入feature map的通道数是一致的， H和W分别是设置的值。

3、注意3个函数，celi函数向上取整，round函数四舍五入取整，floor函数向下取整。比如数据2.7，三个函数的取值分别为： 3、 3、 2。

4、实际在执行maxpool的时候，是对feature map上的每个通道分别执行max的操作的，最后输出的top的通道和输入feature map的C通道数是一致的。
 
