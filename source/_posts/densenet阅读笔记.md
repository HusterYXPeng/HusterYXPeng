---
layout: post
title: Densenet网络介绍
date: 2018-03-26 22:07 +0800
last_modified_at: 2018-03-26 22:07 +0800
categories: 计算机视觉
tags: [计算机视觉, 模型]
toc:  true
---

#### 一、摘要
最近的研究表明： 在卷积网络中，如果靠近输出的层和靠近输入层有shorter connect的时候，网络可以设计的更深、具有更高的准确率以及更高效的训练。在这篇论文中，我们提出了denseNet的结构，在DenseNet中每个层以前向的方式与后面的层进行连接。传统的具有L层的神经网络，具有L个连接，但是DenseNet中L层的网络具有（L+1）*L/2这么多个连接。对于每个层，之前所有的网络层都作为输入，这个层也作为了之后所有层的输入。**DenseNet网络具有以下几个优势：1）网络缓和了梯度消失；2）强化了网络中特征的前向传播；3）鼓励网络中特征的重用；4）减少了网络的参数**。在实验后，这个网络可以超过现在最好的网络，需要更好的计算量，以及有了更好的表现。
#### 二、介绍
从近期的研究来看，CNN模型变得越来越深，但是随着网络模型的变深，有一个新的问题出现了，就是随着信息从网络输入传到最后，或者是梯度信息从最后传到输入，信息会丢失。现在的一些研究，比如残差网络resnet或者是其他的改进都是基于添加一些short path的连接，即：都是早期的输入层到后期的层之间添加short path的连接。该论文提出了一种网路结构：保证网络中最大的信息流动，每个层的输入为之前的所有层的输出，当前层的输出也被作为之后所有层的输入。网络的图解如图1所示：

![这里写图片描述](https://img-blog.csdn.net/20180326192023644?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
与残差网络相比：在多个输入会和的时候，resnet的处理办法是将相应的层进行累加，说的明白点，就是下图中的x和F(x)的C、H和W参数必须是一致的，在汇聚的时候，对应的元素是相加的。但是**在densenet中，多个输入是通过串联的方式叠加到一起的，因此需要多个输入的H和w参数的一致的，这里是resnet很大的区别**。在densenet中，每个层的输出都会作为后面的每个层的输入，以及当前的层的输入是前面所有层的输入的串联叠加后的结果。比如网络中的第L层，就有L个输入，但是在一般的传统的网络中，一个层只有一个输入的。
虽然从直觉上来说，这样做是使得网络的参数加大，但是反直觉的是，这样做，恰恰降低了网络的参数，因为这种结构不需要重新学习冗余的特征图了。传统的前向传播的网络结构相当于一种状态算法，状态一层层向后传递，每个层将读取前层的状态，再传递后后面的层，这样改变了状态信息，同时也传递了需要保存的信息。在resnet中，前面层的信息可以直接通过short 连接直接连到后面的后面的层。最近的关于残差网络的研究表明，很多层其实对结果贡献不大，事实上在训练的过程中被随机的丢弃了，即drop了。**DenseNet结构每层的输出很小（eg：每个层12个卷积核），这比传统的网络比如VGG等500多个卷积核相比，减少了很多，这也就是网络参数量少的原因了。每层的输出很小，这样相当于每次加了一小部分特征图到了总的特征中**，同时使部分信息不变的，最后做分类所用的信息有每个层的作用，即：在最后做分类的时候用到了之前每个层的结果。
还有一个很大的作用就是：**提升了信息和梯度在网络中的流动，使得网络更容易去训练**。因为最后的决策层用到了之前每个层的信息，因此，每个层都对最后的loss具有直接的贡献。同时，densenet在小数据集上还有很好的防止过拟合的作用。
![这里写图片描述](https://img-blog.csdn.net/20180326192136346?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
#### 三、详细细节
考虑一个图像输入X0，通过整个网络。这个网络具有L层，每个层相当于实现了一个非线性变换H，非线性变换可以被综合表示成： BN->RELU->Pooling或者Conv。在残差网络中，第l层的输出作为l+1层的输入，可以表示成： X(l+1)=Hl(X(l))，那么残差网络可以表示成如下：
![这里写图片描述](https://img-blog.csdn.net/20180326192248616?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 相比之下，DenseNet可以表示成：
 ![这里写图片描述](https://img-blog.csdn.net/20180326192325167?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 后面的实现就是前面L-1个层的输出的串联，为第L层的输入。
 ![这里写图片描述](https://img-blog.csdn.net/20180326192356291?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 **复合功能**：定义复合功能为3个连续操作， BN->RELU->ConV(3*3)。即相当于这3个操作连在一起相当于一个复合的操作，网络中每层都是这样的组合。
**Pooling实现**： 因为多个输入之间串联的时候需要保证每个输入的W和H参数一直才可以串联叠加，但是不可能保证从开始到最后map的大小不变。因为在网络中将网络分为了多个dense block的单元，**两个dense block单元之间连接的部分叫做变换层（transition layer），这个层具体操作是卷积和池化，核心就是： BN->ConV(1*1)->ave pooling(2*2).**
**增长率K**：每个层经过多个输入后输出的map的数量叫做网络的增长率，即每层的卷积核的个数。因此第L层具有 k0+（L-1）*k个输入，但是有k个输出，输出是固定的，其中k0是输入图的C，k是网络的增长率。K是一个超参数，从实验结果可以观察到，相对较小的增长率k对网络优化具有很大的作用。
**Bottleneck layer**： 虽然每个层只有K个输出，但是后面的层的输入还是很大的，这样参数量还是很大，因此为了压缩参数，在每个block内，每个3*3的卷积前加一个1*1的卷积核，进行输入的压缩，这样可以大大降低输入3*3的map的数量，降低了参数。这样的话，每个block内部，复合操作就是： BN->RELU->CONV(1*1)->BN->RELU->ConV(3*3)。为了和原始的densenet进行对比，具有这样结构的densenet叫做dense-B结构。
**参数压缩**：为了进一步压缩参数，在两个block之间的变换层做了一些改变，如果一个block的输出有m个map，我们让变换层输出为theta*m的map个数，这里的theta叫做网络的压缩因子。这个theta是一个0到1的小数，具有这样结构的网络叫做Dense-C，在实验中theta的取值是0.5。
同时具有**Bottleneck layer和Translation layer**这2种结构的叫： Dense-BC。
实验的网络模型如下：
![这里写图片描述](https://img-blog.csdn.net/20180326192434790?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIyNzMxMjc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)