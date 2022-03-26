---
layout: post
title: K8S和Yarn命令总结(一)
date: 2022-03-25 08:11 +0800
last_modified_at: 2022-03-25 09:10 +0800
categories: Docker
tags: [k8s, yarn, docker]
toc:  true
---

### Yarn管理任务
查看当前yarn管理的任务
```
yarn application --list
```
kill掉当前taskId的任务
```
yarn application -kill taskId  
```

### Yarn查看容器日志
```
yarn logs -applicationId taskID
```

### k8s停止和删除容器
```
docker stop containID       // 停止容器
dokcer rm containID       // 删除容器
```
必须先停止再删除


### 查看当前容器和镜像
```
docker images       // 查看当前镜像
docker ps           // 查看当前容器
```

### 查看某个命名空间下的pod
```
kubectl get pod -n namespace
```

### 对pod进行重启
```
kubectl get pod podID -n namespace -o yaml | kubectl replace --force -f
```


待写
