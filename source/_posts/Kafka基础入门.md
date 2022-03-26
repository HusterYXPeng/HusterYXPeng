---
layout: post
title: Kafka基础与入门
date: 2022-03-26 09:10 +0800
last_modified_at: 2022-03-26 09:10 +0800
categories: 大数据
tags: [kafka, 消息队列]
toc:  true
---

假设：当前处于 /usr/bin/kafka 的kafka安装目录

### 启动消费者
```
bin/kafka-console-consumer.sh --bootstrap-server xx.xx.x.xxx:9092 --topic myTopic --consumer.config ./config/consumer.properties 
```

### 启动生产者
```
bin/kafka-console-producer.sh --broker-list xx.xx.x.xxx:9092 --topic myTopic
```

### 创建topic
```
bin/kafka-topics.sh --create --zookeeper xxx.xx.xx.xx:2181 --replication-factor 1 --partitions 3 --topic myTopic 
```
