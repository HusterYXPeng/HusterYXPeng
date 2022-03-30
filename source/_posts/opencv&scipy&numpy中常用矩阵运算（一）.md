# opencv&scipy&numpy中常用矩阵运算（一）

## Array常用操作

### 1、矩阵维度变换 np.transpose 函数

作用：矩阵维度变换，[2， 100， 100] 变换为 [100, 2, 100]

```
import numpy as np
np.transpose(arr, [1, 0, 2])
```

### 2 、矩阵增加维度 np.expand_dims

作用：矩阵增加维度，[100,100]变换为[1,100,100]

经常与np.repeat()函数一起使用。

```
np.expand_dims(array, 0)		# 增加一个维度
   [100, 100] => [1, 100, 100]
np.expand_dims(array, 0).repeat(4, axis=0)  # 增加一个维度，并复制该维度
   [100, 100] => [4, 100, 100]
```

### 3、删除矩阵单维度 np.squeeze

作用：矩阵维度删除，[1, 100, 100]变换为[100, 100]。注意：仅能删除维度值为1的维度

```
np.squeeze(arr, axis=0)   # 删除第一个维度，如果维度值为1，删除成功，否则报错
np.squeeze(arr)           # 删除所有维度中维度值为1的维度
```

### 4、numpy.array基本属性操作

作用：获取array的基本属性，容易记错的

```
np.Array arr;
arr.ndim     # 矩阵的维度数，三维矩阵为3，四维矩阵为4
arr.shape    # 矩阵的shape，为list，没有括号
```

### 5、np.argsort()函数对矩阵按照某一维进行排序

可以用于对矩阵的某一维度进行排序，排序的结果就是该维度从小到大的索引的下标。

```
import numpy as np
arr = np.random.rand(3, 4)
print(arr.shape)
print(arr)
arr2 = np.argsort(arr, axis=1)
print(arr2)

## output:
(3, 4)
[[ 0.25527801  0.28870203  0.13308197  0.40236823]
 [ 0.57291876  0.22652327  0.96109344  0.60414358]
 [ 0.87348642  0.43462071  0.70254728  0.88925431]]
[[2 0 1 3]    //第一行，第三个数最小，最后一个数最大
 [1 0 3 2]
 [1 2 0 3]]
```

## Scipy相关

### 1、scipy.spatial.distance.cdist函数计算矩阵之间距离

作用：scipy.spatial.distance 模块下 计算两个点集之间每2个点之间的距离

eg：有一个二维点集A，另外有一个二维点集B，A中有m个点，B中有n个点，该函数可以计算m*n个距离，即A中每个点与B中每个点依次计算距离，得到一个m * n的矩阵，代表每两个点对之间的距离。

```
import scipy
import scipy.spatial
import numpy as np

arr1 = np.random.rand(3, 2)
arr2 = np.random.rand(4, 2)
dist_arr = scipy.spatial.distance.cdist(arr1, arr2)
print(dist_arr.shape)
print(dist_arr)

# output
(3, 4)
[[ 0.79519252  0.9242954   0.91473169  0.23748187]
 [ 0.77753607  0.88705038  1.1765303   0.18053772]
 [ 0.17226682  0.22484498  0.61399408  0.74316168]]
```

### 2、使用scipy.spatial模块下的Delaunay()函数对点集进行三角剖分并显示

作用：对一个点集进行三角刨分

```
import numpy as np
from scipy.spatial import Delaunay
import matplotlib.pyplot as plt

points = np.array([[0, 0], [0, 1], [1, 2], [3, 5], [2, 7], [0, 6], [-1, 2]])
tri = Delaunay(points)

plt.triplot(points[:,0], points[:,1], tri.simplices.copy())
plt.plot(points[:,0], points[:,1], 'o')
plt.show()
```

显示结果：

![1648648957751](/Image/1648648957751.png)

### opencv相关

### 1、cv.pointPolygonTest 函数计算点是否在polygon中。

作用：可以用于判断一个二维的点是否在一个plygon中

### 2、cv2.drawContours 函数将polygon 画在 图像矩阵上。

