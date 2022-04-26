
# Bash Shell

Bash 是 Unix 系统和 Linux 系统的一种 Shell（命令行环境），
是目前绝大多数 Linux 发行版的默认 Shell。


## 一、echo 

### 1、无参数

echo 命令的作用是在屏幕输出一行文本，可以将该命令的参数原样输出。

```shell
$ echo hello world
hello world
```

上面例子中，echo的参数是hello world，可以原样输出。

如果想要输出的是多行文本，即包括换行符。这时就需要把多行文本放在引号里面。

```shell
$ echo "<HTML>
    <HEAD>
          <TITLE>Page Title</TITLE>
    </HEAD>
    <BODY>
          Page body.
    </BODY>
</HTML>"
```
上面例子中，echo可以原样输出多行文本。

### 2、-n 参数 

默认情况下，echo 输出的文本末尾会有一个回车符。-n 参数可以取消末尾的回车符，使得下一个提示符紧跟在输出内容的后面。

```shell
$ echo -n hello world
hello world$
```

上面例子中，world后面直接就是下一行的提示符 $。

```shell
$ echo a;echo b
a
b

$ echo -n a;echo b
ab
```

上面例子中，-n 参数可以让两个 echo 命令的输出连在一起，出现在同一行。

### 3、-e 参数

-e 参数会解释引号（双引号和单引号）里面的特殊字符（比如换行符\n）。如果不使用 -e 参数，即默认情况下，
引号会让特殊字符变成普通字符，echo 不解释它们，原样输出。

```shell
$ echo "Hello\nWorld"
Hello\nWorld

# 双引号的情况
$ echo -e "Hello\nWorld"
Hello
World

# 单引号的情况
$ echo -e 'Hello\nWorld'
Hello
World
```

上面代码中，-e参数使得\n解释为换行符，导致输出内容里面出现换行。

## 二、eval 

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

## 三、declare 
