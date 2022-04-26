# Shell 编程

学习 Bash，首先需要理解 Shell 是什么。Shell 这个单词的原意是“外壳”，跟 kernel（内核）相对应，比喻内核外面的一层，即用户跟内核交互的对话界面。

具体来说，Shell 这个词有多种含义。

首先，Shell 是一个程序，提供一个与用户对话的环境。这个环境只有一个命令提示符，让用户从键盘输入命令，所以又称为命令行环境（command line interface，简写为 CLI）。Shell 接收到用户输入的命令，将命令送入操作系统执行，并将结果返回给用户。本书中，除非特别指明，Shell 指的就是命令行环境。

其次，Shell 是一个命令解释器，解释用户输入的命令。它支持变量、条件判断、循环操作等语法，所以用户可以用 Shell 命令写出各种小程序，又称为脚本（script）。这些脚本都通过 Shell 的解释执行，而不通过编译。

最后，Shell 是一个工具箱，提供了各种小工具，供用户方便地使用操作系统的功能。

## 目录

一、[变量](#一变量)

二、[字符串](#二字符串)

三、[数组](#三数组)

四、[字典](#四字典)

五、[流程控制](#五结构化命令)

六、[函数](#六函数)

七、[运算符](#七运算符)

八、[用户参数](#八用户参数)

九、[输入/输出重定向](#九输入输出重定向)

十、[数学运算](#十数学运算)

十一、[控制脚本](#十一控制脚本)

## 一、变量

在 `shell` 中会同时存在三种变量：局部变量、环境变量、shell 变量。

### 1、 赋值

`shell` 定义变量时，变量名不加美元符号，如：

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

## 四、字典

`shell` 中的字典与数组有很多的相似之处，不过字典的下标可以不为整数。在使用字典时，需要先声明，否则结果可能与预期不同。

### 1、 定义字典

方式 1：
```shell
declare -A map
map["my03"]="03"
```

方式 2：
```shell
declare -A map=(["my01"]="01" ["my02"]="02")
map["my03"]="03"
map["my04"]="04"
```

获取指定 key 的值。
```shell
#!/bin/bash

declare -A map=(["sunjun"]="a" ["jason"]="b" ["lee"]="c")
echo ${map["sunjun"]}

# a
```

字典拼接扩展。

```shell
#!/bin/bash

declare -A map=(["sunjun"]="a")
map+=(["jason"]="b")

echo ${!map[@]}

# sunjun jason
```

获取所有的值 key、value、长度。

```shell
#!/bin/bash

declare -A map=(["sunjun"]="a" ["jason"]="b" ["lee"]="c")

echo ${!map[@]}  # key
echo ${map[@]}   # value
echo ${#map[@]}  # length

# sunjun lee jason
# a c b
# 3
```

### 2、 遍历字典

遍历所有的 key 值。

```shell
#!/bin/bash

declare -A map=(["sunjun"]="a" ["jason"]="b" ["lee"]="c")

for key in ${!map[@]};do
    echo $key
done

# sunjun
# lee
# jason
```

遍历所有的 value 值。

```shell
#!/bin/bash

declare -A map=(["sunjun"]="a" ["jason"]="b" ["lee"]="c")

for val in ${map[@]};do
    echo $val
done

# a
# c
# b
```

## 五、结构化命令

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

## 六、函数

### 1、 函数定义

有两种格式可以用来在 `shell` 脚本中创建函数。第一种格式采用关键字 `function`，后跟分配给该代码块的函数名。

```shell
function name { 
    commands 
}
```
第二种格式更接近于其他编程语言中定义函数的方式,函数名后的空括号表明正在定义的是一个函数。

```shell
name() { 
    commands 
}
```

下面的例子定义了一个函数并进行调用：

```shell
$ cat test.sh
#!/bin/bash

function demo(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demo
echo "-----函数执行完毕-----"

$ sh test.sh
-----函数开始执行-----
这是我的第一个 shell 函数!
-----函数执行完毕-----
```
### 2、 返回值

获取函数的返回值，可以显示加：`return` 返回，如果不加，将以最后一条命令运行结果，执行状态码作为返回值。 `return` 后跟数值 n(0-255)。


```shell
$ cat test.sh
#!/bin/bash

function test {
    read -p "enter a value: " value
    return $[ $value * $value ]
}
test
echo "the new value is $?"

$ sh test.sh
enter a value: 10
the new value is 100
```

还可以使用函数输出获取函数执行结果，这种方式返回值可以是任何类型。

```shell
$ cat test.sh
#!/bin/bash

function test {
    read -p "enter a value: " value
    echo $[ $value * $value ]
}
result=$(test)
echo "the new value is $result"

$ sh test.sh
enter a value: 100
the new value is 10000
```

### 3、 函数传参

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

# 第一个参数为 11 !
# 第十个参数为 110 !
# 第十个参数为 34 !
# 第十一个参数为 73 !
# 参数总数有 11 个!
# 作为一个字符串输出所有参数 11 22 3 4 5 6 7 8 9 34 73 !
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

### 4、 函数变量

默认情况下，在脚本中定义的任何变量都是全局变量，在函数外定义的变量可在函数内正常访问，**对值进行修改后，会影响全局变量的值**。

```shell
#!/bin/bash

count=1
function test {
    count=2
}
test
echo $count

# 2
```

要想在函数内部对变量值修改，不影响函数外的调用。可以在函数内部把变量声明为局部变量，只需在变量声明前加 `local` 即可。

```shell
#!/bin/bash

count=1
function test {
    local count=2
}
test
echo $count

# 1
```

### 5、数组变量和函数

把数组做个函数的参数传参，如果将该数组变量作为函数参数，函数只会取数组变量的第一个值。
必须将该数组变量的值分解成单个的值。

```shell
#!/bin/bash

function test {
    echo $@
}
array=(1 2 3 4 5)
test $array
test ${array[@]}

# 1
# 1 2 3 4 5
```

将数组作为返回值。

```shell
#!/bin/bash

function test {
   newarray=($(echo "$@"))
   elements=$[ $# - 1 ]
   for (( i = 0; i <= $elements; i++ ))
   {
      newarray[$i]=$[ ${newarray[$i]} * 2 ]
   }
   echo ${newarray[*]}
}
array=(1 2 3 4 5)
result=$(test ${array[@]})
echo ${result[@]}

# 2 4 6 8 10
```

### 6、函数递归

使用函数递归调用的特性实现阶乘算法。

```shell
#!/bin/bash

function factorial {
 if [ $1 -eq 1 ];then
    echo 1
 else
    local temp=$[ $1 - 1 ]
    local result=$(factorial $temp)
    echo $[ $result * $1 ]
 fi
}
result=$(factorial 5)
echo $result

# 120
```

### 7、创建库

一个脚本可以调用其他脚本中的函数，被调用的脚本作为公共库文件。

```shell
$ cat myfuncs
#!/bin/bash

function addem { 
 echo $[ $1 + $2 ] 
}
```

使用函数库的关键在于 `source` 命令。`source` 命令会在当前 `shell` 上下文中执行命令，而不是创建一个新 `shell`。
可以用 `source` 命令来在 `shell` 脚本中运行库文件脚本。这样脚本就可以使用库中的函数了。

`source` 命令有个快捷的别名，称作点操作符（dot operator）。

```shell
$ cat test.sh
#!/bin/bash 

. ./myfuncs 
value1=10 
value2=5 
result=$(addem $value1 $value2)
echo $result

# 15
```

## 七、运算符

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

## 八、用户参数

`bash shell` 提供了一些不同的方法来从用户处获得数据，包括命令行参数、命令行选项以及直接从键盘读取输入的能力。

### 1、命令行参数

传递数据的最基本方法是使用命令行参数，通过位置参数可以获取传入的参数值。

位置参数变量是标准的数字：`$0` 是程序名，`$1` 是第一个参数，`$2` 是第二个参数，依次类推，直到第九个参数 `$9`。

```shell
$ cat test.sh
#!/bin/bash

echo $0
echo $1

$ sh test.sh 100

test.sh
100
```

每个参数都是用空格分隔的，所以 `shell` 会将空格当成两个值的分隔符。要在参数值中包含空格，必须要用引号。

当传给 `$0` 变量是完整的脚本路径时， 变量 `$0` 就会使用整个路径。此时可以使用 `basename` 命令，
它会返回不包含路径的脚本名。

```shell
$ cat test.sh
#!/bin/bash 

name=$(basename $0) 
echo 
echo The script name is: $name

$ sh /root/test.sh

test.sh
```

当命令行参数不止 9 个时，可以在变量数字周围加上花括号，比如 `${10}` 来获取。

特殊变量 `$#` 可以获取参数的数量，`${!#}` 可以获取最后一个参数。

`$*` 和 `$@` 变量可以用来轻松访问所有的参数。`$*` 变量会将命令行上提供的所有参数当作一个单词保存。
`$@` 变量会将命令行上提供的所有参数当作同一字符串中的多个独立的单词。

```shell
#!/bin/bash

for param in "$*"
do
    echo $param
done

echo 

for param in "$@"
do
    echo $param
done

$ ./test.sh rich barbara katie jessica
rich barbara katie jessica

rich
barbara
katie
jessica
```


### 2、移动变量

`shift` 命令会根据它们的相对位置来移动命令行参数，默认情况下它会将每个参数变量向左移动一个位置。

这是遍历命令行参数的另一个好方法，尤其是在你不知道到底有多少参数时。

```shell
$ cat test.sh
#!/bin/bash

while [ -n "$1" ]
do
    echo $1
    shift
done

$ ./test.sh rich barbara katie jessica

rich
barbara
katie
jessica
```

`shift` 后还可以跟参数，指明移动的位置。例如 `shift 2` 表示移动两位。

### 3、处理选项

`getopt` 命令可以接受一系列任意形式的命令行选项和参数，并自动将它们转换成适当的格
式。它的命令格式如下：

```shell
getopt optstring parameters
```

在 optstring 中列出你要在脚本中用到的每个命令行选项字母。然后，在每个需要参数值的选项字母后加一个冒号。

```shell
$ getopt ab:cd -a -b test1 -cd test2 test3
-a -b test1 -c -d -- test2 test3
```

如果指定了一个不在 optstring 中的选项，会产生错误消息，可以使用 -q 参数进行忽略。

`getopts` 命令相比 `getopt` 多了很多扩展功能，命令格式如下：

```shell
getopts optstring variable
```

`getopts` 命令会用到两个环境变量。如果选项需要跟一个参数值，`OPTARG` 环境变量就会保存这个值。
`OPTIND` 环境变量保存了参数列表中 `getopts` 正在处理的参数位置。

```shell
$ cat test.sh
#!/bin/bash 
 
while getopts :ab:cd opt 
do 
    case "$opt" in 
    a) echo "found the -a option, with value $OPTARG" ;; 
    b) echo "found the -b option, with value $OPTARG" ;; 
    c) echo "found the -c option, with value $OPTARG" ;; 
    d) echo "found the -d option, with value $OPTARG" ;; 
    *) echo "Unknown option: $opt" ;; 
    esac 
done 

shift $[ $OPTIND - 1 ] 

echo 
for param in "$@" 
do 
 echo $param
done

$ Shell sh t.sh  -a -b test1 -d test2 test3 test4
found the -a option, with value
found the -b option, with value test1
found the -d option, with value

test2
test3
```

Linux 中用到的一些命令行选项的常用含义。

|选 项|描 述|
|---|---
|-a |显示所有对象
|-c |生成一个计数
|-d |指定一个目录
|-e |扩展一个对象
|-f |指定读入数据的文件
|-h |显示命令的帮助信息
|-i |忽略文本大小写
|-l |产生输出的长格式版本
|-n |使用非交互模式（批处理）
|-o |将所有输出重定向到的指定的输出文件
|-q |以安静模式运行
|-r |递归地处理目录和文件
|-s |以安静模式运行
|-v |生成详细输出
|-x |排除某个对象
|-y |对所有问题回答yes

### 4、获取用户输入

`read` 命令包含了 -p 选项，允许你直接在 `read` 命令行指定提示符。

```shell
$ cat test.sh
#!/bin/bash 

read -p "please enter your age: " age 
days=$[ $age * 365 ] 
echo "that makes you over $days days old! " 

$ ./test.sh
please enter your age: 10
that makes you over 3650 days old!
```

设置超时，-t 选项指定了 `read` 命令等待输入的秒数。当计时器过期后，`read` 命令会返回一个非零退出状态码。

隐藏方式读取，-s 选项可以避免在read命令中输入的数据出现在显示器上（实际上，数据会被显示，只是
read 命令会将文本颜色设成跟背景色一样）。

```shell
$ cat test.sh
#!/bin/bash 

read -s -p "enter your password: " pass
echo 
echo "is your password really $pass? " 
$ 
$ ./test.sh
enter your password: 
is your password really T3st1ng?
```

`read` 还可以从文件中读取数据，常用的命令如下。

```shell
$ cat test | while read line; do echo $line; done
```

## 九、输入/输出重定向

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

## 十、数学运算

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

## 十一、控制脚本

### 1、处理信号

Linux 系统和应用程序可以生成超过 30 个信号。下面列出了在 Linux 编程时会遇到的最常见的系统信号。

|信 号|值|描 述|
|---|---|---
|1 |SIGHUP| 挂起进程
|2 |SIGINT| 终止进程
|3 |SIGQUIT| 停止进程
|9 |SIGKILL| 无条件终止进程
|15 |SIGTERM| 尽可能终止进程
|17 |SIGSTOP| 无条件停止进程，但不是终止进程
|18 |SIGTSTP| 停止或暂停进程，但不终止进程
|19 |SIGCONT| 继续运行停止的进程

当你要离开一个交互式 `shell` 时，它会将SIGHUP信号传给所有由该shell所启动的进程（包括正在运行的 shell 脚本）。

`Ctrl+C` 组合键会生成 `SIGINT` 信号，并将其发送给当前在 `shell` 中运行的所有进程。

`Ctrl+Z` 组合键会生成一个 `SIGTSTP` 信号，停止 `shell` 中运行的任何进程。

```shell
$ sleep 100
^Z 
[1]+ Stopped sleep 100
```
方括号中的数字是分配的作业号，每个进程称为作业，作业号是累加的，通过 `ps` 可以查看。

```shell
F S UID PID PPID C PRI NI ADDR SZ WCHAN TTY TIME CMD 
0 S 501 2431 2430 0 80 0 - 27118 wait pts/0 00:00:00 bash 
0 T 501 2456 2431 0 80 0 - 25227 signal pts/0 00:00:00 sleep 
0 R 501 2458 2431 0 80 0 - 27034 - pts/0 00:00:00 ps
```

就可以用 `kill` 命令来发送一个 `SIGKILL` 信号来终止它。

```shell
$ kill -9 2456
$ 
[1]+ Killed sleep 100
```

### 2、捕获信号

`trap` 命令允许你来指定 `shell` 脚本要监看并从 `shell` 中拦截的 Linux 信号。如果脚本收到了 `trap` 命令中列出的信号，该信号不再由 `shell` 处理，而是交由本地处理。

```shell
trap commands signals
```

简单例子，展示了如何使用 `trap` 命令来忽略 `SIGINT` 信号。

```shell
$ cat test.sh
#!/bin/bash 
 
trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT 

echo This is a test script 
 
count=1 
while [ $count -le 10 ] 
do 
    echo "Loop #$count" 
    sleep 1 
    count=$[ $count + 1 ] 
done 
echo "This is the end of the test script"

$ ./test.sh
This is a test script 
Loop #1 
Loop #2 
Loop #3 
Loop #4 
Loop #5 
^C Sorry! I have trapped Ctrl-C 
Loop #6 
Loop #7 
Loop #8 
^C Sorry! I have trapped Ctrl-C 
Loop #9 
Loop #10 
This is the end of the test script
```

除了在 shell 脚本中捕获信号，你也可以在 shell 脚本退出时进行捕获。

```shell
$ cat test.sh
#!/bin/bash 

trap "echo Goodbye..." EXIT 
# 
count=1 
while [ $count -le 5 ] 
do 
 echo "Loop #$count" 
 sleep 1 
 count=$[ $count + 1 ] 
done 
 
$ ./test.sh
Loop #1 
Loop #2 
Loop #3 
Loop #4 
Loop #5 
Goodbye...
```


## 推荐阅读：

[《Linux命令行与shell脚本编程大全》](https://book.douban.com/subject/26854226/)

[《谷歌shell编码规范》](https://google.github.io/styleguide/shellguide.html)
