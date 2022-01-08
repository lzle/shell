# Shell 编程

Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。它是操作系统最外层的接口，
负责直接面向用户交互并提供内核服务。

## 目录

一、[变量](#一变量)

二、[字符串](#二字符串)

三、[数组](#三数组)

四、[流程控制](#四结构化命令)

五、[函数](#五函数)

六、[运算符](#六运算符)

七、[输入/输出重定向](#七输入输出重定向)

八、[eval 函数](#八eval-函数)

九、[数学运算](#九数学运算)

## 一、变量

在 `shell` 中会同时存在三种变量：局部变量、环境变量、shell 变量。

### 1、 赋值

`Shell` 定义变量时，变量名不加美元符号，如：

```shell
$ content="hello world"
```

变量名的命名须遵循如下**规则：**

- 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
- 中间不能有空格，可以使用下划线 _。
- 不能使用标点符号。
- 不能使用shell里的关键字（可用help命令查看保留关键字）。

### 2、 引用

使用一个定义过的变量，只要在变量名前面加美元符号即可，如：

```shell
#!/bin/bash

content="hello world"
echo $content
echo ${content}

# hello world
# hello world
```

变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界。

```shell
#!/bin/bash

content="hello world"
echo "name:${content}"

# name:hello world
```

**推荐给所有变量加上花括号，这是个好的编程习惯。**

已定义的变量，可以被重新定义，如：

```shell
#!/bin/bash

content="hello world"
echo $content
content="hello shell"
echo $content

# hello world
# hello content
```

### 3、 只读变量

使用 `readonly` 命令可以将变量定义为只读变量，只读变量的值不能被改变。

```shell
#!/bin/bash

content="hello world!"
readonly content
content="hello shell!"
```

运行脚本，结果如下：

```shell
/bin/sh: NAME: This variable is read only.
```

### 4、 局部变量

`Shell` 中默认定义的变量是**全局变量**，可以使用 `global` 进行显式声明，其作用域从被定义的地方开始，一直到脚本结束或者被删除的地方。

`local` 可以定义局部变量，在函数内部使用。

```shell
#!/bin/bash

name="global variable"
function func(){
    local name="local variable"
    echo $name
}

func
echo $name

# local variable
# global variable
```

### 5、 命令替换

有两种方法可以将命令输出赋给变量：

- 反引号字符（`）
- $()格式

```shell
testing=$(date) 
echo "The date and time are: " $testing

# The date and time are:  2022年 01月 08日 星期六 15:52:39 CST
```

只要将命令的输出放到了变量里，就可以做很多事情。

## 二、字符串

字符串是最常用最有用的数据类型，字符串可以用**单引号**，也可以用**双引号**，也可以**不用引号**。

### 1、单引号

```shell
str='this is a string'
echo '$str'

# $str
```

单引号字符串的限制：

- 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
- 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。

### 2、 双引号

```shell
name="shell"
str="Hello, I know you are \"$name\"! \n"
echo $str

# Hello, I know you are "shell"!
```

双引号的优点：

- 双引号里可以有变量;
- 双引号里可以出现转义字符。

### 3、 字符串长度

```shell
string="abcd"
echo ${#string} 

# 4
```

### 4、 提取子字符串

以下示例从字符串第 2 个字符开始截取 4 个字符：

```shell
string="huawei is a great compan"
echo ${string:1:4} 

# uawe
```

### 5、 查找子字符串

查找字符 i 或 o 的位置(哪个字母先出现就计算哪个)：

```shell
string="huawei is a great company"
echo $(expr index "$string" io) 

# 6
```

### 6、去除字符串两边空白字符

```shell
echo " A B  C   " | awk '{gsub(/^\s+|\s+$/, "");print}'

# A B  C
```

### 7、显示输出不换行

```shell
echo -n "The time and date are: " ; date

# The time and date are: 2022年 01月 08日 星期六 15:27:47 CST
```

### 8、输出文件中每行内容

```shell
#!/bin/bash

while read line; do
    echo $line
done < filename
```
或者

```shell
cat filename | while read line; do echo $line; done
```


### 9、字符串与数字比较

```shell
#!/bin/bash

s="5"
n=5

if [ $s -eq $n ];then
    echo "true"
else
    echo "flase"
fi

# true
```


## 三、数组

`Shell` 只支持一维数组（不支持多维数组），并且没有限定数组的大小。类似于 `C` 语言，数组元素的下标由 0 开始编号。

### 1、 定义数组

在 `shell` 中，用括号来表示数组，数组元素用"空格"符号分割开。

```shell
array=("value0" "value1" "value2" "value3")
```

还可以单独定义数组的各个元素：

```shell
array[0]="value0"
array[1]="value1"
array[n]="valuen"
```

### 2、 读取数组

读取数组元素值的一般格式是：

```shell
value=${array_name[n]}
```

使用 `@` 符号可以获取数组中的所有元素，例如：

```shell
echo ${array_name[@]}

# value0 value1 value2 value3
```

### 3、 获取长度

获取数组长度的方法与获取字符串长度的方法相同，例如：

```shell
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

注意：数组不可以进行切割，错误用法 `${array[1:2]}`。

## 四、结构化命令

### 1、 if 语句

最基本的结构化命令就是 if-then 语句。if-then 语句有如下格式。

```shell
if command; then 
commands
fi
```

如果 `if` 后的 command 命令的退出状态码是 0 ，会执行 `then` 后的 comands。这与其他编程语言的是不一样的，
其他编程语言中 `if` 语句之后的对象是一个等式，这个等式的求值结果为 true 或 false 。

```shell
#!/bin/bash 
# testing the if statement 
if pwd; then 
 echo "it worked" 
fi

# /root
# it worked
```

如果 command 命令的退出状态码是其他值，then 部分的命令就不会执行。

除了上面判断普通命令外，在 bash shell 中 `test` 命令提供了测试不同条件的途径，如果 `test` 命令中列出的条件成立， 
`test` 命令就会退出并返回退出状态码 0。 反之，`test` 命令返回非 0 状态码，后面的命令不会执行。

```shell
if test condition; then 
commands
fi
```

`test` 命令可以判断三类条件([参考运算符](#六运算符))：

- [x] 数值比较
- [x] 字符串比较
- [x] 文件比较

bash shell 还提供了另一种方式条件测试方法，无需声明 `test` 命令，使用方括号定义测试条件。

```shell
if [ condition ]; then 
commands
fi
```
注意，第一个方括号之后和第二个方括号之前必须加上一个空格， 否则就会报错。

下面示例，判断两个变量是否相等。

```shell
#!/bin/bash

a=10
b=20
if [ $a -eq $b ]; then
    echo "a 等于 b"
elif [ $a -gt $b ]; then
    echo "a 大于 b"
elif [ $a -lt $b ]; then
    echo "a 小于 b"
else
    echo "没有符合的条件"
fi

# a 小于 b
```

不能使用 `if [ $a > $b ]`，正确的方式是 `if (( $a > $b ))`。

**此外，有两项可在 if-then 语句中使用的高级特性**。

- [x] 用于数学表达式的双括号
- [x] 用于高级字符串处理功能的双方括号

**双括号**命令允许你在比较过程中使用高级数学表达式。test命令只能在比较中使用简单的
算术操作。双括号命令提供了更多的数学符号。双括号命令的格式如下：
```shell
val++ 后增
val-- 后减
++val 先增
--val 先减
! 逻辑求反
~ 位求反
** 幂运算
<< 左位移
>> 右位移
& 位布尔和
| 位布尔或
&& 逻辑和
|| 逻辑或
```

使用示例：

```shell
#!/bin/bash 

val1=10 

if (( $val1 ** 2 > 90 )) 
then 
  (( val2 = $val1 ** 2 )) 
  echo "the square of $val1 is $val2" 
fi

# the square of 10 is 100
```

**双方括号**命令提供了针对字符串比较的高级特性，除了提供标准字符串比较外，还提供了另一个特性模式匹配。

```shell
#!/bin/bash 
# using pattern matching 
# 
if [[ $USER == r* ]] 
then 
    echo "hello $USER" 
else 
    echo "sorry, I do not know you" 
fi

# hello root
```

### 2、 case 命令

`case` 命令会将指定的变量与不同模式进行比较。如果变量和模式是匹配的，那么 shell 会执行
为该模式指定的命令。

```shell
case variable in 
pattern1 | pattern2) commands1;; 
pattern3) commands2;; 
*) default commands;; 
esac
```

使用示例如下：

```shell
#!/bin/sh

site="runoob"

case "$site" in
   "runoob") 
        echo "runoob" ;;
   "google") 
        echo "google" ;;
   "taobao") 
        echo "taobao" ;;
esac

# runoob
```


### 3、 for 循环

`for` 循环即执行一次所有命令，**空格**进行元素分割，使用变量名获取列表中的当前取值。

示例，顺序输出当前列表中的数字，loop 会保存最后一次迭代值：

```shell
#!/bin/bash

for loop in 1 2 3; do
    echo "The value is: $loop"
done
echo $loop

# The value is: 1
# The value is: 2
# The value is: 3

# 3
```

循环字符串内容：

```shell
#!/bin/bash

for str in This is a string; do
    echo $str
done

# This
# is
# a
# string
```

循环数组中元素：

```shell
#!/bin/bash

array=("value0" "value1" "value2" "value3")
# array[*]与array[@]两者皆可
for loop in ${array[*]}; do    
    echo ${loop}
done

# value0
# value1
# value2
# value3
```

从命令读取值：

```shell
#!/bin/bash

for loop in $(ls /root/); do    
    echo ${loop}
done

# package
# work
```

**更改字段分隔符**

特殊的环境变量 IFS，叫作内部字段分隔符。IFS 环境变量定义了 bash shell 用作字段分隔符的一系列字符。默认情况下，
bash shell 会将下列字符当作字段分隔符：

- [x] 空格
- [x] 制表符
- [x] 换行符

可以在shell脚本中临时更改IFS环境变量的值来限制被bash shell当作字段分隔符的字符。

```shell
#!/bin/bash 
# reading values from a file 

file="states" 
IFS=$'\n' 
for state in $(cat $file) 
do 
    echo "visit beautiful $state" 
done
```

上面代码中忽略空格和制表符，只识别换行符。

如果要指定多个IFS字符，只要将它们在赋值行串起来就行。

```shell
IFS=$'\n':;"
```

这个赋值会将换行符、冒号、分号和双引号作为字段分隔符。

**用通配符读取目录**

可以用for命令来自动遍历目录中的文件，但是必须在文件名或路径名中使用通配符。它会强制 shell 使用文件扩展匹配。

```shell
#!/bin/bash

for file in /home/rich/test/* 
do 
    if [ -d "$file" ]; then 
        echo "$file is a directory" 
    elif [ -f "$file" ]; then 
        echo "$file is a file" 
    fi 
done
```

`for` 命令会遍历 /home/rich/test/* 输出的结果。 也可以在for命令中列出多个目录通配符，将目录查找和列表合并进同一个for语句。

```shell
for file in /home/rich/.b* /home/rich/badtest
```

**C 语言风格**

在 shell 中使用 C 语言风格的 for 命令。
```shell
#!/bin/bash

for (( i=1; i <= 3; i++ ))
do
    echo $i
done

# 1
# 2
# 3
```

还允许为迭代使用多个变量。尽管可以使用多个变量，但你只能在 for 循环中定义一种条件。

```shell
#!/bin/bash

for (( a=1, b=3; a <= 3; a++, b-- ))
do
    echo "$a - $b"
done

# 1 - 3
# 2 - 2
# 3 - 1
```

### 4、 while 循环

`while` 循环用于不断执行一系列命令，也用于从输入文件中读取数据。

命令的格式是：

```shell
while test command 
do 
    other commands 
done
```
`while` 命令中定义的 test command 和 `if-then` 语句中的格式一模一样。


以下是一个基本的 `while` 循环，测试条件是：如果 int 小于等于 5，那么条件返回真。int 从 1 开始，每次循环处理时，int 加 1。运行上述脚本，返回数字 1 到 5，然后终止。

```shell
int=1
while [ $int -le 5 ]; do
    echo $int
    let "int++"
done
```

无限循环

```shell
while true; do
    command
done
```

### 5、 循环控制

在循环语句中，可以使用 `break` 命令，允许跳出所有循环（终止执行后面的所有循环）。

```shell
#!/bin/bash

while :; do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
    1 | 2 | 3 | 4 | 5)
        echo "你输入的数字为 $aNum!"
        ;;
    *)
        echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
        break
        ;;
    esac
done
```

`break` 命令接受单个命令行参数值：

```shell
break n
```
其中 n 指定了要跳出的循环层级。默认情况下，n 为 1，表明跳出的是当前的循环。如果你将 n 设为2，`break` 命令就会停止下一级的外部循环。


`continue` 命令与 `break` 命令类似，只有一点差别，它不会跳出所有循环，仅仅中止当前循环中的命令。

```shell
#!/bin/bash

while :; do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
    1 | 2 | 3 | 4 | 5)
        echo "你输入的数字为 $aNum!"
        ;;
    *)
        echo "你输入的数字不是 1 到 5 之间的!"
        continue
        echo "游戏结束"
        ;;
    esac
done
```

运行代码发现，当输入大于5的数字时，该例中的循环不会结束，语句 echo "游戏结束" 永远不会被执行。


`continue` 命令也接受单个命令行参数值：

```shell
continue n
```

### 6、处理循环的输出

在 shell 脚本中，你可以对循环的输出使用管道或进行重定向。这可以通过在 done 命令之后添加一个处理命令来实现。

获取循环的输出重定向到文件中。

```shell
#!/bin/bash

for file in /home/rich/* 
do 
    if [ -d "$file" ]; then 
        echo "$file is a directory" 
    elif 
        echo "$file is a file" 
    fi 
done > output.txt
```

使用管道符对循环输出进行排序。

```shell
#!/bin/bash

for state in "North Dakota" Connecticut Illinois Alabama Tennessee
do 
    echo $state 
done | sort 

# Alabama 
# Connecticut 
# Illinois 
# North
# Tennessee
```

## 五、函数

### 1、 函数定义

`Shell` 中可以用户定义函数，然后在 `shell` 脚本中可以随便调用。

下面的例子定义了一个函数并进行调用：

```shell
#!/bin/bash

function demo(){
     echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demo
echo "-----函数执行完毕-----"
```

可以带 `function fun()` 定义，也可以直接 `fun()` 定义,不带任何参数。

参数返回，可以显示加：`return` 返回，如果不加，将以最后一条命令运行结果，作为返回值。 `return` 后跟数值n(0-255)。

函数脚本执行结果：

```shell
-----函数开始执行-----
这是我的第一个 shell 函数!
-----函数执行完毕-----
```

### 2、 函数参数

在 `shell` 中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，例如，$1 表示第一个参数，$2 表示第二个参数...

带参数的函数示例：

```shell
#!/bin/bash

function param(){
     echo "第一个参数为 $1 !"
     echo "第十个参数为 $10 !"
     echo "第十个参数为 ${10} !"
     echo "第十一个参数为 ${11} !"
     echo "参数总数有 $# 个!"
     echo "作为一个字符串输出所有参数 $* !"
}
param 11 22 3 4 5 6 7 8 9 34 73
```

输出结果：

```shell
第一个参数为 11 !
第十个参数为 110 !
第十个参数为 34 !
第十一个参数为 73 !
参数总数有 11 个!
作为一个字符串输出所有参数 11 22 3 4 5 6 7 8 9 34 73 !
```

参数获取时 `$n` 与 `${n}` 还是有区别的，特别是第二行的打印。

`$10` 不能获取第十个参数，获取第十个参数需要 `${10}`。当n>=10时，需要使用 `${n}` 来获取参数。

另外，还有几个特殊字符用来处理参数：

```shell
$#	传递到脚本或函数的参数个数
$*	以一个单字符串显示所有向脚本传递的参数
$$	脚本运行的当前进程ID号
$!	后台运行的最后一个进程的ID号
$@	与$*相同，但是使用时加引号，并在引号中返回每个参数。
$-	显示Shell使用的当前选项，与set命令功能相同。
$?	显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
```

### 3、 获取函数结果

获取函数的执行结果。

```shell
#!/bin/bash

function get_hostname(){
    echo "$(hostname)"
}

hostname=$(get_hostname)
echo $hostname

# localhost
```


## 六、运算符

### 1、算术运算符

下表列出了常用的算术运算符。

```shell
+	加法	
-	减法	
*	乘法	
/	除法
%	取余
```
注意：条件表达式要放在方括号之间，并且要有空格，例如: `[$a==$b]` 是错误的，必须写成 `[ $a == $b ]`。

示例：

```shell
#!/bin/bash

a=10
b=20

val=$(expr $a + $b)
echo "a + b : $val"

val=$(expr $a \* $b)
echo "a * b : $val"

val=$(expr $b / $a)
echo "b / a : $val"

val=$(expr $b % $a)
echo "b % a : $val"

# a + b : 30
# a * b : 200
# b / a : 2
# b % a : 0
```

还可以使用下面的运算符替换，结果都一致：

```shell
#!/bin/bash

a=10
b=20

val=$(expr $a + $b)
echo "a + b : $val"

var=$(($a + $b))
echo "a + b : $val"

var=$[$a + $b]
echo "a + b : $val"

# a + b : 30
# a + b : 30
# a + b : 30
```

***注意：***

- 乘号(*)前边必须加反斜杠(\)才能实现乘法运算；
- **$((表达式))** 此处表达式中的 "*" 不需要转义符号 "\"。

### 2、数字运算符

关系运算符只支持数字，不支持字符串，除非字符串的值是数字。

下表列出了常用的关系运算符。

```shell
-eq	检测两个数是否相等
-ne	检测两个数是否不相等
-gt	检测左边的数是否大于右边的	
-lt	检测左边的数是否小于右边的	
-ge	检测左边的数是否大于等于右边的	
-le	检测左边的数是否小于等于右边的
```

使用示例如下：

```shell
#!/bin/bash

a=10
b=20

if [ $a -eq $b ]; then
    echo "$a -eq $b : a 等于 b"
else
    echo "$a -eq $b: a 不等于 b"
fi
if [ $a -gt $b ]; then
    echo "$a -gt $b: a 大于 b"
else
    echo "$a -gt $b: a 不大于 b"
fi

# 10 -eq 20: a 不等于 b
# 10 -gt 20: a 不大于 b
```

***注意***：只支持整数，不支持浮点数。

### 3、字符串运算符

下表列出了常用的字符串运算符。

```shell
==	检测两个字符串是否相等。
!=	检测两个字符串是否不相等。
<   检测左边字符是否比右边小。比较ASCII大小。
>	检测左边字符是否比右边大。使用时要转义。
-z	检测字符串长度是否为0。	
-n	检测字符串长度是否不为0。
$	检测字符串是否为空。	
```

字符串运算符示例如下：

```shell
#!/bin/bash

if [ -z $a ]
then
   echo "-z $a : 字符串长度为 0"
else
   echo "-z $a : 字符串长度不为 0"
fi
if [ -n "$a" ]
then
   echo "-n $a : 字符串长度不为 0"
else
   echo "-n $a : 字符串长度为 0"
fi
if [ $a ]
then
   echo "$a : 字符串不为空"
else
   echo "$a : 字符串为空"
fi

# -z  : 字符串长度为 0
# -n  : 字符串长度为 0
#  : 字符串为空
```

### 4、文件比较运算符

文件测试运算符用于检测 Unix 文件的各种属性。

```shell
-d file 检查file是否存在并是一个目录
-e file 检查file是否存在
-f file 检查file是否存在并是一个文件
-r file 检查file是否存在并可读
-s file 检查file是否存在并非空
-w file 检查file是否存在并可写
-x file 检查file是否存在并可执行
-O file 检查file是否存在并属当前用户所有
-G file 检查file是否存在并且默认组与当前用户相同
file1 -nt file2 检查file1是否比file2新
file1 -ot file2 检查file1是否比file2旧
```

### 5、逻辑运算符

常用的逻辑运算符。

```shell
&&	逻辑的 AND	[[ a && b ]] 或者 [ a ] && [ b ]
||	逻辑的 OR	[[ a || b ]] 或者 [ a ] || [ b ]
```

使用示例如下：

```shell
#!/bin/bash

a=10
b=20

if [ $a -lt 100 ] && [ $b -gt 100 ]; then
    echo "返回 true"
else
    echo "返回 false"
fi

if [[ $a -lt 100 || $b -gt 100 ]]; then
    echo "返回 true"
else
    echo "返回 false"
fi

# 返回 false
# 返回 true
```


## 七、输入/输出重定向

### 1、 输出重定向

将命令的完整的输出重定向在用户文件中。

```shell
# 覆盖
$ echo "hello world" >./test.file

# 追加
$ echo "hello world" >>./test.file
```

### 2、 输入重定向

从用户文件中的内容输出到命令行。

```shell
$ wc -l  < ./test.file
1
```

可以与 while 语句结合，遍历文件内容，按行打印：

```shell
while read line; do
    echo $line
done < ./test.file
```

### 3、 标准输入输出

一般情况下，每个 `Unix/Linux` 命令运行时都会打开三个文件：

- 标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
- 标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
- 标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

默认情况下，command > file 将 stdout 重定向到 file，command < file 将stdin 重定向到 file。

如果希望 stderr 重定向到 file，可以这样写：

```shell
$ command 2>file
```

如果希望 stderr 追加到 file 文件末尾，可以这样写：

```shell
$ command 2>>file
```

**2** 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：

```shell
$ command > file 2>&1

或者

$ command >> file 2>&1
```

如果希望对 stdin 和 stdout 都重定向，可以这样写：

```shell
$ command < file1 >file2
```

command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。


## 八、eval 函数

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

## 九、数学运算

### 1、expr 命令

`expr` 命令允许在命令行上处理数学表达式，但是特别笨拙。

```shell
$ expr 5 + 1

# 6
```

操作符与数值之间要有空格。下面是 expr 命令操作符。

|操 作 符|描 述|
|---|---
|ARG1 &#124; ARG2 |如果ARG1既不是null也不是零值，返回ARG1；否则返回ARG2
|ARG1 & ARG2 |如果没有参数是null或零值，返回ARG1；否则返回0
|ARG1 < ARG2 |如果ARG1小于ARG2，返回1；否则返回0
|ARG1 <= ARG2|如果ARG1小于或等于ARG2，返回1；否则返回0
|ARG1 = ARG2 |如果ARG1等于ARG2，返回1；否则返回0
|ARG1 != ARG2|如果ARG1不等于ARG2，返回1；否则返回0
|ARG1 >= ARG2|如果ARG1大于或等于ARG2，返回1；否则返回0
|ARG1 > ARG2 |如果ARG1大于ARG2，返回1；否则返回0
|ARG1 + ARG2 |返回ARG1和ARG2的算术运算和
|ARG1 - ARG2 |返回ARG1和ARG2的算术运算差
|ARG1 * ARG2 |返回ARG1和ARG2的算术乘积
|ARG1 / ARG2 |返回ARG1被ARG2除的算术商
|ARG1 % ARG2 |返回ARG1被ARG2除的算术余数

尽管标准操作符在 expr 命令中工作得很好，但是一些特殊字符会有一些诡异的结果。
```shell
$ expr 5 * 2

# expr: syntax error
```

解决办法是使用转义字符标记。
```shell
$ expr 5 \* 2

# 10
```

在脚本中使用，需要将结果赋值给一个变量。

```shell
#!/bin/bash 
var1=10 
var2=20 
var3=$(expr $var2 / $var1) 
echo The result is $var3

# The result is 2
```

### 2、使用方括号

使用方括号是一种更简单的方法来执行数学表达式。

```shell
$ var1=$[1 + 5] 
$ echo $var1 

#6
 
$ var2=$[$var1 * 2] 
$ echo $var2 

#12
```
在使用方括号来计算公式时，不用担心 shell 会误解乘号或其他符号。shell知道它不是通配符，因为它在方括号内。

```shell
#!/bin/bash 

var1=100 
var2=45 
var3=$[$var1 / $var2] 
echo The final result is $var3

# The final result is 2
```

bash shell数学运算符只支持整数运算。

### 3、浮点运算

`bc` 是内建的 bash 计算器，可以克服数学运算中的整数限制。基本格式如下：

```shell
variable=$(echo "options; expression" | bc)
```

第一部分options允许你设置变量。如果你需要不止一个变量，可以用分号将其分开。
expression参数定义了通过bc执行的数学表达式。

```shell
#!/bin/bash 

var1=100 
var2=45 
var3=$(echo "scale=4; $var1 / $var2" | bc) 
echo The answer for this is $var3

# The answer for this is 2.2222
```

还支持内联输入重定向，允许你直接在命令行中重定向数据。
```shell
variable=$(bc << EOF 
options 
statements 
expressions 
EOF 
)
```

下面是使用示例：

```shell
#!/bin/bash

var1=10.46
var2=43.67
var3=33.2
var4=71

var5=$(bc << EOF
scale = 4
a1 = ($var1 * $var2)
b1 = ($var3 * $var4)
a1 + b1
EOF
)
echo The final answer for this mess is $var5

# The final answer for this mess is 2813.9882
```


***
## 推荐阅读：

[《Linux命令行与shell脚本编程大全》](https://book.douban.com/subject/26854226/)

[《谷歌shell编码规范》](https://google.github.io/styleguide/shellguide.html)
