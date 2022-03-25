---
layout: post
title: Win安装单机版PySpark
date: 2022-03-20 12:07 +0800
last_modified_at: 2022-03-20 12:07 +0800
categories: Spark
tags: [Spark, 数据分析]
toc:  true
---

## 准备软件包

Java环境：从Oracle官方网站下载即可。

PySpark包： 从Apache网站下载

Hadoop环境：本地单机版可以不需要下载。

## 配置 Java 环境

下载Java的JDK，双击exe一直安装，并配置环境变量。

配置  **JAVA_HOME**为Java安装环境 根目录。

![1642684167470](/image/1642684167470.png)

检验，打开cmd，输入 java -version 如下图所示

![1642684205839](/image/1642684205839.png)



## 配置Spark和Hadoop环境变量

从Spark官网下载Spark安装包。

配置 SPARK_HOME和HADOOP_HOME两个环境变量。

![1642684374799](/image/1642684374799.png)



## 拷贝Spark包中包到Python环境

1、将Spark解压后的路径下的，Python环境包，拷贝到Python环境下。

```
E:\Bigdata\spark-3.2.0-bin-hadoop2.7\python\lib
```

将这个路径下的两个压缩包，解压后，放到对应Python环境中放置安装包的目录。

![1642685093362](/image/1642685093362.png)

在Python代码中 输入：

```
import pyspark
```

则证明配置正确。

## Spark初始化&Demo程序

```
# 初始化spark环境
def init_spark():
    spark_conf = SparkConf().setAppName('app')\
        .set('spark.ui.showConsoleProgress', 'false')
    sc = SparkContext.getOrCreate(conf=spark_conf)
    spark = SparkSession(sc)
    return sc, spark

if __name__=="__main__":
	sc, spark = init_spark()
```

