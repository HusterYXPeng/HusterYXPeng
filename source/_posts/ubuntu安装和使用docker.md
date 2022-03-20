---
layout: post
title: Ubuntu安装与使用docker
date: 2022-03-24 22:07 +0800
last_modified_at: 2022-03-24 22:07 +0800
tags: [Docker, 安装]
toc:  true
---

## Ubuntu安装Docker

1、在Ubuntu中添加子用户并添加root权限

```
(1) useradd -m xxx  # 创建子用户
(2) passwd xxx  # 修改子用户密码
(3) 在 /etc/sudoers 中写入 xxx ALL=(ALL) NOPASSWD:ALL  # 添加sudo权限
```

后续的操作全部在子用户中进行。

2、安装docker

（1）安装 wget：如果当前系统有 wget 可忽略

```
sudo apt-get update 
sudo apt-get install wget
```

（2）下载docker安装包并安装环境

```
wget -qO- https://get.docker.com/ | sh
```

（3）验证是否安装成功：

```
sudo docker ps   # 查看当前容器情况
```

（4）创建docker用户组，并将当前子用户（具有sudo权限）的加到用户组中

```
sudo usermod -aG docker xxxx  (xxx为子用户名)
```

验证成功与否，进入xxx子用户，直接不加sudo使用docker命令看是否报错，无错则正确。



## pull镜像并起容器

1、从DockerHub中pull镜像：

```
docker pull ubuntu:14.04   # pull ubuntu：14.04镜像
docker images 			   # 查看当前本地已有镜像
```

2、起容器：

```
docker run -t -i ubuntu:14.04 /bin/bash   # 起ubuntu容器，直接进伪终端进行交互式操作
docker ps  -a  							  # 查看当前起的容器
```

（1）创建容器并创建可以交互的伪终端：run后直接进入容器终端

```
docker run -t -i ubuntu:14.04 /bin/bash
```

注意：这种情况下，再退出容器，容器即结束状态。

（2）创建容器并以进程运行：创建后返回容器ID，使用容器ID进入容器

```
docker run -d ubuntu:14.04 /bin/bash -c "sleep 1000000000000"
-d : 指定容器在主机上以进程运行。
```

注意：这里后面 -c 指定容器创建后要执行的命令，命令执行结束后，容器就结束了。所以一般在后面可以写sleep等让容器停住的命令，可以让容器一直处于 running 状态。

这个时候 `docker ps` 可以看到刚刚起的容器。

3、看日志/停止/启动/删除容器

```
docker ps  					# 查看当前running的容器和容器ID
docker logs -f containID    # 查看容器日志
docker stop containID		# 停止容器
docker start containID      # 启动已经停止的存在的容器
docker rm containID 		# 删除容器
```

4、查看容器详细信息：（类似于k8s的deployment文件）

```
docker inspect containID
```



## 使用容器

1、创建容器—将容器的端口映射到主机：`-p`

```
docker run -d -p 10000:22 ubuntu:14.04 /bin/bash -c "sleep xxxxx"
# 将容器内的22端口映射到主机的10000端口
```

注意： `-p p1:p2` 其中p1为主机端口，p2为容器内的端口。

2、创建容器—指定容器的name

```
docker run -d --name tset-docker ubuntu:14.04 /bin/bash -c "sleep xxxxx"
```

3、根据容器ID进入running的容器：

```
docker ps   						# 查看容器ID
docker exec -it containID  bash 	# 进入容器
```


# 修改并创建自己的镜像

背景： 使用 ubuntu:14.04 镜像生成一个自带Python的新镜像（原 ubuntu:14.04 不带Python）。

## 使用 commit

1、创建一个  ubuntu:14.04  容器：

```
docker run -d ubuntu:14.04 /bin/bash -c "sleep 100000000000"
```

2、进入容器：

```
docker exec -it containerID  bash
```

3、安装Python

```
apt install python
```

4、退出容器：exit

5、生成新镜像：

```
docker commit -m="install-python" -a="yxp" containerID ubuntu-14.04:v1
其中：
 -m：指定修改，类似git的commnit
 -a： 指定修改的作者
 跟上当前修改的containerID，最后为新镜像的名和版本号。
```

6、查看新镜像： docker images

7、利用新镜像起容器即可。



## 使用 Dockerfile 

1、创建一个Dockerfile文件

内容如下：

```
from ubuntu:14.04
MAINTAINER yuxipeng
RUN apt-get update
RUN apt install python
```

MAINTAINER 指定谁在维护这个新镜像

2、执行Dockerfile

```
docker build yxp/ubuntu-14.04:v1 .
```

注意： yxp为user信息，后面的新镜像的名字和版本号， 最后 `.`表示Dockerfile在当前文件夹下。

创建后： 查看当前镜像信息如下

![1622971504421](/image/1622971504421.png)

3、对新镜像打tag信息

```
docker tag 8bd5b69956dd yxp/ubuntu-14.04:v1
# 参数1 镜像ID
# 参数2 镜像user和镜像信息
```

再查看： docker images

![1622971652513](/image/1622971652513.png)



## 容器连接与挂载

### 容器连接

1、 使用 `-p` 将容器内的端口映射到宿主机上：

`-p p1:p2`： 将宿主机上的p1端口映射到容器内的p2端口上。



### 容器挂载

作用：将宿主机上的某个目录或者磁盘挂载到容器内，实现在容器内对宿主机上文件的修改。

数据卷：数据卷是指在存在于一个或多个容器中的特定目录，此目录能够提供一些用于持续存储或共享数据的特性，即相当于在容器内部创建一个目录。

指令： `-v` 在 run容器的时候，通过-v 在容器内创建数据卷（目录）。

1、在容器内添加一个数据卷，容器结束数据卷的修改即消失

```
docker run -d --name container-yuxipeng-v1 -v /yuxipeng ubuntu-14.04:v1 bash -c "sleep 100000000000000000000000"
```

创建容器后，进入容器的根目录：（多了一个根目录）

![1623667689709](/image/1623667689709.png)

2、将容器内的数据卷挂载到宿主机的对应目录：如果宿主机对应目录（必须是绝对路径）不存在，则会自动创建。

```
docker run -d --name container-yuxipeng-v1 -v /ddd:/yuxipeng ubuntu-14.04:v1 bash -c "sleep 100000000000000000000000"
```

将宿主机上的 `/ddd`根目录映射到容器内的 `/yuxipeng`目录下，在容器内对 `/yuxipeng`目录下的修改，即是对宿主机上的 `/ddd`目录的修改，即使容器删除后，相关修改会存在。如果 `/ddd`目录在宿主机上不存在，会自动创建。

