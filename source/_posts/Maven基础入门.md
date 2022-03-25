---
layout: post
title: Java Maven基础配置与入门
date: 2022-03-20 23:18 +0800
last_modified_at: 2022-03-20 23:18 +0800
categories: Java
tags: [Java, Maven]
toc:  true
---

### 1.maven介绍

**Maven**是一个项目管理工具，使用Maven可以来管理企业级的Java项目开发及依赖的管理

### 2.maven优势

传统项目：

- jar包我们需要手动去网上寻找，有些jar包不容易找到，比较麻烦
- 会导致项目文件的体积暴增，Java工程中将jar包放在工程根目录或者放在自建的lib目录下；JavaWeb工程会将jar包放在:/WEB-INF/lib目录下
- 当以来多个版本jar包时候，会引起版本冲突

maven项目：

- Maven团队维护了一个非常全的Maven仓库(中央仓库)，其中几乎包含了所有的jar包，使用Maven创建的工程可以自动到Maven仓库中下载jar包，方便且不易出错。
- 在Maven构建的项目中，不会将项目所依赖的jar包拷贝到每一个项目中，而是将jar包统一放在仓库中管理，在项目中只需要引入jar包的位置(坐标)即可。这样实现了jar包的复用。
- Maven采用坐标来管理仓库中的jar包，其中的目录结构为【公司名称+项目/产品名称+版本号】，可以根据坐标定位到具体的jar包。即使使用不同公司中同名的jar包，坐标不同（目录结构不同），文件名也不会冲突。
- Maven构建的项目中，通过pom文件对项目中所依赖的jar包及版本进行统一管理，可避免版本冲突。
- 在Maven项目中，通过一个命令或者一键就可以实现项目的编译（mvn complie）、测试（mvn test）、打包部署（mvn deploy）、运行（mvn install）等

### 3.Maven相关下载配置

- 官方下载地址：http://maven.apache.org/download.cgi

- 本地仓库：其实就是本地硬盘上的某一目录，该目录中会包含项目中所需要的所有jar包及插件。当所需jar包在本地仓库没有时，从网络上下载下来的jar包也会存放在本地仓库中。因此本地仓库其实就是一个jar包的仓库
- maven指定的本地仓库的默认位置是在c盘，默认在：C:\Users\{当前用户}\.m2\repository
- 修改方法：找到[MAVEN_HOME]/conf/目录中的配置文件settings.xml，修改maven仓库的路径
- 当maven项目中需要依赖jar包时，只需要在项目的pom文件中添加jar对应的坐标，Maven就会到Maven的本地仓库中引用相应的jar包，如果本地仓库没有，就会到远程仓库去下载jar包。如果不配置默认连接的是中央仓库，由于中央仓库面对的是全球用户，所以在下载jar包时，效率可能会比较低。

### 4.项目idea配置maven

- ![1647771837399](/image/1647771837399.png)

### 5.maven工程目录介绍

```
1）/src/main/java -- 主目录下的Java目录，用于存放项目中的.java文件

2）/src/main/resources – 主目下的资源目录，存放项目中的资源文件(如框架的配置文件)

3）/src/test/java -- 测试目录下的Java目录，用于存放所有单元测试类的.java文件，如Junit测试类

4）/src/test/resources – 测试目录下的资源目录，用于存放测试类所需资源文件(如框架的配置文件)

5）/target -- 项目输出目录，编译后的class文件、及项目打成的war包等会输出到此目录中

6）/pom.xml -- maven项目的核心配置文件，文件中通过坐标来管理项目中的所有jar包和插件。
```

### 6.maven项目依赖包下载

maven的依赖添加以及管理都是在/pom.xml文件下完成的

如：需要使用junit包，或者log的日志包

- 到官方的maven仓库http://www.mvnrepository.com/选择要使用的版本以及将坐标找到

![1647772771597](/image/1647772771597.png)

- 在/pom.xml文件下添加<dependency></dependency>

```
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.1</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.17.2</version>
</dependency>
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-api</artifactId>
    <version>2.17.2</version>
</dependency>
```

### 7.项目打包

maven项目打包两种方式，一种是IEDA自带打包方法，另一种是用Maven插件maven-shade-plugin打包

- idea自带的打包方式：

  - 打开IDEA项目 file -> Project Structure

  ![1647773369810](/image/1647773369810.png)

  - 选择运行的类文件

  ![1647773474350](/image/1647773474350.png)

  - 确定后重新Build Artifas–jar包，如图所示，之后在项目out输出里就会有相应的jar包了。

  ![1647773536472](/image/1647773536472.png)

- Maven插件maven-shade-plugin打包

  - pom.[xml](https://so.csdn.net/so/search?q=xml&spm=1001.2101.3001.7020)中添加以下代码，可以直接maven打包

  ```
  <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-shade-plugin</artifactId>
      <version>3.2.4</version>
      <executions>
          <execution>
              <phase>package</phase>
              <goals>
                  <goal>shade</goal>
              </goals>
              <configuration>
                  <transformers>
                      <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                          <mainClass>org.sonatype.haven.HavenCli</mainClass>
                      </transformer>
                  </transformers>
              </configuration>
          </execution>
      </executions>
  </plugin>
  ```

  ![1647773749707](/image/1647773749707.png)