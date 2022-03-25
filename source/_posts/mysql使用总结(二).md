---
layout: post
title: musql基础使用总结(二)
date: 2022-03-24 09:10 +0800
last_modified_at: 2022-03-24 09:10 +0800
tags: [mysql, 数据库]
toc:  true
---


### 使用 with...as 作子查询
```sql
with table1 as(
    select xx1 as x1,
    xx2 as x2,
    xx3 as x3
    from table0
),
table2 as(
    select x1 as a1,
    x2 as a2,
    x3 as a3
    from table1
),
table3 as(
    select a1 as m1,
    a2 as m2,
    a3 as m3
    from table2
)
select * from table3 order by m1, m2, m3
```
说明：
（1）多使用with as构建子表，特别是一个表只需要用到一次的时候，可以极大减小内存依赖；
（2）可以多个表一级级with as 可以使复杂逻辑简单化，代码更易理解，每一个子表可以select确定正确性后再级联；
（3）with里面的语句不要有分号；


### 用窗口函数row_number()对数据行进行编号
```sql
with table1 as (
    select xx1, xx2, xx3 from table0
),
table2 as (
    select 
        row_number() over(
            PARTITION BY xx1, xx2
            order by xx3
        )-1 as rn,
        *
    from table1
)
select * from table2
```
说明：
（1）关键代码 row_number() over 理解
作用：对table1表的三个字段，首先根据xx1和xx2进行分区，其次分区后数据根据xx3进行排序，最后对排序后的数据进行编号，over在这里指定了一个窗口，row_number()为一个固定的sql函数，为行生成编码。
如下所示：
```
xx1 xx2   xx3  rn
A   0101  001   0
A   0101  003   1
B   0102  008   0
B   0102  009   1
B   0102  010   2
C   0103  003   0
C   0103  004   1
```
注意这里对rn的理解，是先对xx1和xx2进行相当于group by，再对同一个xx1和xx2的行根据xx3大小进行排序，最后对数据行进行编号，其次编号是从1开始，所以要对rn进行减1的操作。
进一步扩展：有如下数据，每个ID每天1min产生一条数据，现在要统计数据中时间相邻2条数据之间缺失了多少条数据，即相邻行做对比。

```
ID    date    time  ==>>   rn1  ==>>   rn2
A     0601    02:01         1           0
A     0601    02:03         2           1
A     0601    02:05         3           2
A     0601    02:06         4           3
A     0601    02:09         5           4
A     0601    02:15         5           5
```
办法：
（1）对ID和date进行row_number() over 计算rn，从1开始
（2）对ID和date进行row_number() over 计算rn，从0开始
（3）最后基于rn1和rn2对两个表进行join操作，这样时间相邻的两条数据就在一行中了，直接做时间差值，就可以计算相邻之间差了多少条数据。


### 使用LAG()函数和LEAD()函数取某个字段
```sql
select xx1, xx2, time1,
    lag(time1, 1, "start") over(
        PARTITION BY 
            xx1, xx2, 
            order by time1
    ) as time2
from 
    table1
```
说明：对所有数据按照xx1，xx2取窗口进行排序，在窗口内，再根据time1进行排序，之后取每条数据的前一条数据的time1作为新的time2字段。
```
xx1 xx2 time1 ==>> time2
A    a  01:01        空
A    a  01:04       01:01
B    c  01:02        空
B    c  02:09       01:02
B    m  09:09        空
```
这个也可以作为实现前面的相邻数据之前相差数据的条数。


### 数据写入与数据老化、幂等
```sql
insert overwrite 
    table table1(date)
select xx1, xx2, date from 
    table2
where xx1>0
```
将数据按照date进行分区overwrite写入，假设写入01-01号的数据，这样其余天的数据不会被overwrite。
同时，01-01号的数据多次写入不会存在重复数据，保证每次写入都擦除之前的01-01的数据。
数据老化
```sql
insert overwrite table table1
select xx1, xx2, time1 from 
table2 where unix_timestamp(time1, "yyyy/MM/dd HH:mm:ss") > nix_timestamp(current(), "yyyy/MM/dd HH:mm:ss")-86400*7
```
说明：每次写入数据都是全量insert overwrite写入，会覆盖之前的所有数据，但是每次写入的时候不是所有的数据都写入，而是根据time1字段判断，只写入距离当前时间点过去7天内的数据。
