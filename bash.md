
# Bash Shell

## 一、eval 函数

当我们在命令行前加上 `eval` 时，`shell` 就会在执行命令之前扫描它两次。`eval` 命令将首先会先扫描命令行进行所有的置换，然后再执行该命令。该命令适用于那些一次扫描无法实现其功能的变量。该命令对变量进行两次扫描。

常见的使用场景如下：

### 1、普通情况

```shell
$ var=100
$ echo $var
100
$ eval echo $var
```

这样和普通的没有加 `eval` 关键字的命令的作用一样。

### 2、字符串转换命令

```shell
$ cat file
helle shell
it is a test of eval

$ tfile="cat file"
$ eval $tfile
helle shell
it is a test of eval
```

从上面可以看出 eval 经历了两次扫描，第一次扫描替换了变量为字符串，第二次扫描执行了字符串内容。

### 3、获取参数

```shell
$ cat t.sh
#!/bin/bash

eval echo \$$#

$ ./t.sh a b c
c
$ ./t.sh 1 2 3
3
```

通过转义符 “|” 与 $# 结合，可以动态的获取最后一个参数。

### 4、 修改指针

```shell
$ var=100
$ ptr=var
$ eval echo \$$ptr
100
$ eval $ptr=50
$ echo $val
50
```
