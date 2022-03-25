---
layout: post
title: mysql基础使用总结(一)
date: 2022-03-24 07:10 +0800
last_modified_at: 2022-03-24 07:10 +0800
categories: SQL
tags: [mysql, 数据库]
toc:  true
---

### from with 语句
```sql
(select * from database.table)datatable1
where datatable1.xx = "xxx"
```
说明：在from后()后的名字，代表选择这部分数据组成的一个临时数据表的别名，datatable1，别名可以用于后续的判断和筛选和排序等等，但是不能
作为表名进行插入和写操作。

### 将一个已知表的部分符合条件的数据写入另一个表中
```sql
create table if not exists database.datatable
(
    d1 string,
    d2 string
);
insert into table database.datatable1 from
(
    select * from database.datatable2
)dd2 where dd2.d1="xxxx";
```
说明：创建表先判断是否存在，并将database.datatable2表中的d1字段等于xxxx的数据写入新创建的数据库database.datatable1。

### 删除整个数据表连同定义一起删除
```sql
drop table if exists database.datatable1;
```
说明：drop命令，删除前先判断是否存在。


### 对两个表做join操作并筛选数据字段
```sql
select 
    d1.xx1 as x1, 
    d1.xx2 as x2, 
    d2.xx3 as x3, 
    d2.xx4 as x4 
from table1 d1, 
     table d2 
where 
    d1.xx1 = d2.xx3 and 
    d1.xx3 = d2.xx2
order by 
    d2.xx3,
    t2.xx1;
```
说明：对两个表d1和d2的两个表进行join操作，使用d1的xx1字段与d2的xx3字段进行关联和d1的xx3字段与d2的xx3=2字段进行关联，筛选数据后，并根据d2的xx3和xx1字段进行排序。


### 判断字段是否为NULL
```sql
select * from table1 where xx1!="null"
```
说明：选择数据库table1中xx1字段不为null的数据。


### where判断与字符串截取
```sql
select 
    count(*) 
from 
    table1 t1, 
    table2 t2 
where 
    substr(t1.xx1, 5, 2)="xxxx" and 
    t2.xx2 = "123" 
```
说明：使用substr()函数对字符串进行截取。


### 对数据进行group by
```sql
select 
    xx1 as a1, 
    xx2 as a2, 
    xx3 as a3, 
    count(*)
from 
    table1 
group by 
    xx1, 
    xx2, 
    xx3
order by 
    xx1, 
    xx2, 
    xx3
```
说明：对t1标根据xx1,xx2,xx3字段进行分组，并统计字段相同的数据的行数，最后基于xx1,xx2,xx3字段进行排序。


### 查看一个表的前N行
```sql
select * from table1 limit N
```

### 查看一个表的每个字段的数据类型
方法1：
```sql
desc table1;        
```
方法2：
```sql
show columns from table1;       
```
方法3：
```sql
show create table table1;  # 创建表的原始语句      
```













