# Awk 编程

`awk` 是贝尔实验室 1977 年搞出来的文本出现神器，之所以叫 `awk` 是因为其取了三位创始人 Alfred Aho，Peter Weinberger, 和 Brian Kernighan 的 Family Name 的首字符。
它提供一个类编程环境来修改和重新组织文件中的数据。

## 目录

一、[命令使用](#一命令使用)

二、[内置变量](#二内置变量)

三、[自定义变量](#三自定义变量)

四、[处理数组](#四处理数组)

五、[使用模式](#五使用模式)

六、[结构化命令](#六结构化命令)

七、[格式化打印](#七格式化打印)

八、[内建函数](#八内建函数)

九、[自定义函数](#九自定义函数)

## 一、命令使用

在 `gawk` 编程语言中，你可以做下面的事情：

- [x] 定义变量来保存数据；
- [x] 使用算术和字符串操作符来处理数据；
- [x] 使用结构化编程概念（比如if-then语句和循环）来为数据处理增加处理逻辑；
- [x] 通过提取数据文件中的数据元素，将其重新排列或格式化，生成格式化报告。

### 1、命令格式

程序的基本格式如下:

```shell
gawk options program file
```

下面显示了可用的选项。

|选 项|描 述|
|---|---
|-F fs| 指定行中划分数据字段的字段分隔符
|-f file| 从指定的文件中读取程序
|-v var=value| 定义gawk程序中的一个变量及其默认值
|-mf N| 指定要处理的数据文件中的最大字段数
|-mr N| 指定数据文件中的最大数据行数
|-W keyword| 指定gawk的兼容模式或警告等级

### 2、使用数据字段变量

`gawk` 的主要特性之一是其处理文本文件中数据的能力。它会自动给一行中的每个数据元素分配一个变量。
默认情况下 `gawk` 会将如下变量分配给它在文本行中发现的数据字段：$0 代表整个文本行，$1 代表文本行中的第1个数据字段，
之后依次类推。

在文本行中，每个数据字段都是通过字段分隔符划分的。在读取一行文本时，会用预定义的字段分隔符划分每个数据字段。
默认的字段分隔符是任意的空白字符（例如空格或制表符）。

在下面的例子中，程序读取文本文件，只显示第 1 个数据字段的值。

```shell
$ cat data.txt 
one line of test text. 
two lines of test text. 
three lines of test text. 

$ gawk '{print $1}' data.txt 
one 
two 
three
```

### 3、使用多个命令值

`gawk` 编程语言允许你将多条命令组合成一个正常的程序。要在命令行上的程序脚本中使用多条命令，只要在命令之间放个分号即可。

```shell
$ echo "My name is Rich" | gawk '{$4="Christine"; print $0}'
My name is Christine
```

第一条命令会给字段变量 $4 赋值。第二条命令会打印整个数据字段。需要注意的是，原数据字段的值已经被更改。


### 4、从文件中加载脚本

跟 `sed` 编辑器一样，`gawk` 编辑器允许将程序存储到文件中，然后再在命令行中引用。

```shell
$ cat script
{print $1 "'s home directory is " $6} 

$ gawk -F: -f script /etc/passwd 
root's home directory is /root 
bin's home directory is /bin
```
上面例子从文件中读取脚本，-F 表示以冒号作为分隔符，打印 $1 以及 $6 变量的值。

注：如果你要**指定多个分隔符**，你可以这样来：

```shell
awk -F '[;:]'
```

### 5、在处理数据前、后运行脚本

BEGIN 关键字在循环开始前执行。END 关键字循环结束时执行，`gawk` 会在读完数据后执行它。

```shell
$ cat data.txt 
line 1 
line 2 
line 3

$ gawk 'BEGIN {print "The data File Contents:"} 
> {print $0} 
> END {print "End of File"}' data.txt 
The data File Contents: 
line 1
line 2 
line 3 
End of File
```

## 二、内置变量

`gawk` 程序使用内建变量来引用程序数据里的一些特殊功能。

|变 量|描 述|
|---|---
|FIELDWIDTHS| 由空格分隔的一列数字，定义了每个数据字段确切宽度
|FS| 输入字段分隔符
|RS| 输入记录分隔符
|OFS| 输出字段分隔符
|ORS| 输出记录分隔符

变量 `FS` 和 `OFS` 定义了 `gawk` 如何处理数据流中的数据字段。你已经知道了如何使用变量 `FS` 来定义记录中的字段分隔符。
变量 `OFS` 具备相同的功能，只不过是用在 `print` 命令的输出上。

```shell
$ cat data.txt
data11,data12,data13
data21,data22,data23
data31,data32,data33

$ gawk 'BEGIN{FS=","} {print $1,$2,$3}' data.txt
data11 data12 data13
data21 data22 data23
data31 data32 data33
```

默认情况下，`OFS` 设成一个空格，可以设置 `OFS` 变量，可以在输出中使用任意字符串来分隔字段。

```shell
$ gawk -F , '{OFS="-"; print $1,$2,$3}' data.txt
data11-data12-data13
data21-data22-data23
data31-data32-data33
```

变量 `RS` 和 `ORS` 定义了 `gawk` 程序如何处理数据流中的字段。默认情况下，`gawk` 将 `RS` 和 `ORS` 设为换行符。

```shell
$ cat data.txt
Riley Mullen
123 Main Street
Chicago, IL 60601
(312)555-1234

Frank Williams
456 Oak Street
Indianapolis, IN 46201
(317)555-9876

$ gawk 'BEGIN{FS="\n"; RS=""} {print $1,$4}' data.txt 
Riley Mullen (312)555-1234 
Frank Williams (317)555-9876
```

现在 `gawk` 把文件中的每行都当成一个字段，把空白行当作记录分隔符。

下面是更多的 `gawk` 内建变量。

|变 量|描 述|
|---|---
|ARGC| 当前命令行参数个数
|ARGIND| 当前文件在ARGV中的位置
|ARGV| 包含命令行参数的数组
|CONVFMT| 数字的转换格式（参见printf语句），默认值为%.6 g
|ENVIRON| 当前shell环境变量及其值组成的关联数组
|ERRNO| 当读取或关闭输入文件发生错误时的系统错误号
|FILENAME| 用作gawk输入数据的数据文件的文件名
|FNR| 当前数据文件中的数据行数
|IGNORECASE| 设成非零值时，忽略gawk命令中出现的字符串的字符大小写
|NF| 数据文件中的字段总数
|NR| 已处理的输入记录数
|OFMT| 数字的输出格式，默认值为%.6 g
|RLENGTH| 由match函数所匹配的子字符串的长度
|RSTART| 由match函数所匹配的子字符串的起始位置

`ARGC` 和 `ARGV` 变量允许从 `shell` 中获得命令行参数的总数以及它们的值。但这可能有点麻烦，因为 `gawk` 并不会将程序脚本当成命令行参数的一部分。

```shell
$ gawk 'BEGIN{print ARGC,ARGV[0],ARGV[1]}' data.txt
2 gawk data.txt
```

## 三、自定义变量

跟其他典型的编程语言一样，`gawk` 允许你定义自己的变量在程序代码中使用。自定义变量名可以是任意数目的字母、数字和下划线，
但不能以数字开头。重要的是，要记住 `gawk` 变量名区分大小写。

在脚本中给变量赋值。

```shell
$ echo "" | gawk '{test="this is a test"; print test}'
this is a test
```

赋值语句还可以包含数学算式来处理数字值。

```shell
$ echo "" |  gawk '{x=4; x= x * 2 + 3; print x}'
11
```

也可以用 `gawk` 命令行来给程序中的变量赋值。这允许你在正常的代码之外赋值，即时改变变量的值。

```shell
$ gawk -F , '{print $n}' n=1 data.txt
data11
data21
data31
```

## 四、处理数组

### 1、定义数组变量

`gawk` 编程语言使用关联数组提供数组功能。关联数组跟数字数组不同之处在于它的索引值可以是任意文本字符串。
你不需要用连续的数字来标识数组中的数据元素。这跟散列表和字典是同一个概念。

```shell
$ echo "" | gawk '{capital["Illinois"] = "Springfield";  print capital["Illinois"]}'
Springfield
```

### 2、遍历数组变量

遍历数组（索引值不会按任何特定顺序返回）。

```shell
$ echo ''| gawk '{var["a"] = 1; var["b"] = 2;  var["c"] = 3; for (key in var) { print key,var[key] }}'
a 1
b 2
c 3
```

### 3、删除数组变量

删除数组变量。

```shell
$ echo ''| gawk '{var["a"] = 1; var["b"] = 1;  var["c"] = 3; delete var["a"];for (key in var) { print key,var[key] }}'
b 1
c 3
```

## 五、使用模式

`gawk` 程序支持多种类型的匹配模式来过滤数据记录。

### 1、正则表达式

将正则表达式用作匹配模式。可以用基础正则表达式（BRE）或扩展正则表达式（ERE）来选择程序脚本作用在数据流中的哪些行上。

```shell
$ gawk 'BEGIN{FS=","} /11/{print $1}' data.txt
data11
```

正则表达式 /11/ 匹配了数据字段中含有字符串 11 的记录。`gawk` 程序会用正则表达式对记录中所有的数据字段进行匹配，包括字段分隔符。

```shell
$ gawk 'BEGIN{FS=","} /,d/{print $1}' data.txt
data11
data21
data31
```

### 2、匹配操作符

匹配操作符（matching operator）允许将正则表达式限定在记录中的特定数据字段。匹配操作符是波浪线（~）。
可以指定匹配操作符、数据字段变量以及要匹配的正则表达式。

```shell
$ gawk 'BEGIN{FS=","} $2 ~ /^data2/{print $0}' data.txt 
data21,data22,data23,data24,data25
```

匹配操作符会用正则表达式 /^data2/ 来比较第二个数据字段，该正则表达式指明字符串要以文本 data2 开头。

```shell
$ gawk -F: '$1 ~ /rich/{print $1,$NF}' /etc/passwd 
rich /bin/bash
```

这个例子会在第一个数据字段中查找文本 rich。如果在记录中找到了这个模式，它会打印该记录的第一个和最后一个数据字段值。

也可以用!符号来排除正则表达式的匹配。

```shell
$1 !~ /expression/
```

如果记录中没有找到匹配正则表达式的文本，程序脚本就会作用到记录数据。

### 3、数学表达式

除了正则表达式，你也可以在匹配模式中用数学表达式。

显示所有属于root用户组（组ID为0）的系统用户。

```shell
$ gawk -F: '$4 == 0{print $1}' /etc/passwd 
root 
sync 
shutdown 
halt 
operator
```

可以使用任何常见的数学比较表达式。

- [x] x == y：值x等于y。 
- [x] x <= y：值x小于等于y。 
- [x] x < y：值x小于y。 
- [x] x >= y：值x大于等于y。 
- [x] x > y：值x大于y。

也可以对文本数据使用表达式，跟正则表达式不同，表达式必须完全匹配。数据必须跟模式严格匹配。

```shell
$ gawk -F, '$1 == "data"{print $1}' data.txt

$ gawk -F, '$1 == "data11"{print $1}' data.txt 
data11
```

## 六、结构化命令

### 1、if 语句

`gawk` 编程语言支持标准的 if-then-else 格式的 `if` 语句。

```shell
if (condition) statement1
```

如果需要在if语句中执行多条语句，就必须用花括号将它们括起来。

```shell
$ cat data.txt
10
5
13
50
34

$ gawk '{if ($1 > 20 ) { x = $1 * 2; print x}}' data.txt
100
68
```

可以在单行上使用else子句，但必须在if语句部分之后使用分号。

```shell
$ gawk '{if ($1 > 20) print $1 * 2; else print $1 / 2}' data.txt
5
2.5
6.5
100
68
```

### 2、while 语句

`while` 语句为 `gawk` 程序提供了一个基本的循环功能。下面是 `while` 语句的格式。

```shell
while (condition) 
{ 
 statements 
}
```

`while` 循环允许遍历一组数据，并检查迭代的结束条件。

```shell
$ cat data.txt
130 120 135
160 113 140
145 170 215

$ gawk '{total=0; i=1; while (i<4) { total+=$i; i++ }; avg=total/3; print avg }' data.txt
128.333
137.667
176.667
```

还支持在 `while` 循环中使用 `break` 语句和 `continue` 语句，允许你从循环中跳出。

```shell
$ gawk '{total=0; i=1; while (i<4) { total+=$i; if(i==2) break; i++ }; avg=total/2; print avg }' data.txt
125
136.5
157.5
```

### 3、do-while 语句

`do-while` 保证了语句会在条件被求值之前至少执行一次。当需要在求值条件前执行语句时，这个特性非常方便。

```shell
$ gawk '{total=0; i=1; do {total+=$i;i++} while (total<150); print total }' data.txt
250
160
315
```

### 4、for 语句

`for` 语句是许多编程语言执行循环的常见方法。gawk 编程语言支持 C 风格的 `for` 循环。

```shell
$ gawk '{total=0; i=1;  for (i=1; i<4;i++) {total += $i}; avg=total/3; print avg }' data.txt
128.333
137.667
176.667
```

## 七、格式化打印

`gawk` 中的 `printf` 命令支持格式化打印，下面是命令的格式：

```shell
printf "format string", var1, var2 . . .
```

format string 是格式化输出的关键。它会用文本元素和格式化指定符来具体指定如何呈现格式化输出。

格式化指定符是一种特殊的代码，程序会将每个格式化指定符作为占位符，供命令中的变量使用。

|控制字母|描 述|
|---|---
|c| 将一个数作为ASCII字符显示
|d| 显示一个整数值
|i| 显示一个整数值（跟d一样）
|e| 用科学计数法显示一个数
|f| 显示一个浮点值
|g| 用科学计数法或浮点数显示（选择较短的格式）
|o| 显示一个八进制值
|s| 显示一个文本字符串
|x| 显示一个十六进制值
|X| 显示一个十六进制值，但用大写字母A~F

示例：
```shell
$ gawk 'BEGIN{ x = 10 * 100; printf "the answer is: %e\n", x}'
the answer is: 1.000000e+03
```

除了控制字母外，还有3种修饰符可以用来进一步控制输出。

- [x] width：指定了输出字段最小宽度的数字值。如果输出短于这个值，`printf` 会将文本右对齐，并用空格进行填充。如果输出比指定的宽度还要长，则按照实际的长度输出。
- [x] prec：这是一个数字值，指定了浮点数中小数点后面位数，或者文本字符串中显示的最大字符数。 
- [x] -（减号）：指明在向格式化空间中放入数据时采用左对齐而不是右对齐。

通过添加一个值为 16 的修饰符，我们强制第一个字符串的输出宽度为 16 个字符。默认情况下，
`printf` 命令使用右对齐来将数据放到格式化空间中。要改成左对齐，只需给修饰符加一个减号即可。

```shell
$ cat data.txt
Riley Mullen
123 Main Street
Chicago, IL 60601
(312)555-1234

Frank Williams
456 Oak Street
Indianapolis, IN 46201
(317)555-9876

$ gawk 'BEGIN{FS="\n"; RS=""} {printf "%-16s %s\n", $1, $4}' data2 
Riley Mullen (312)555-1234 
Frank Williams (317)555-9876
```

## 八、内建函数

`gawk` 编程语言提供了不少内置函数，可进行一些常见的数学、字符串以及时间函数运算。

### 1、数学函数

下面是 `gawk` 中内建的数学函数。

|函 数|描 述|
|---|---
|atan2(x, y)| x/y的反正切，x和y以弧度为单位
|cos(x)| x的余弦，x以弧度为单位
|exp(x)| x的指数函数
|int(x)| x的整数部分，取靠近零一侧的值
|log(x)| x的自然对数
|rand()| 比0大比1小的随机浮点值
|sin(x)| x的正弦，x以弧度为单位
|sqrt(x)| x的平方根
|srand(x)| 为计算随机数指定一个种子值

可以使用 rand() 函数和 int() 函数创建一个大的随机数。

```shell
x = int(10 * rand())
```

这会返回一个0～9（包括0和9）的随机整数值。

除了标准数学函数外，gawk还支持一些按位操作数据的函数。
 
- [x] and(v1, v2)：执行值v1和v2的按位与运算。
- [x] compl(val)：执行val的补运算。
- [x] lshift(val, count)：将值val左移count位。
- [x] or(v1, v2)：执行值v1和v2的按位或运算。
- [x] rshift(val, count)：将值val右移count位。
- [x] xor(v1, v2)：执行值v1和v2的按位异或运算。


### 2、字符串函数

`gawk` 编程语言还提供了一些可用来处理字符串值的函数。

|函 数|描 述|
|---|---
|asort(s [,d]) |将数组s按数据元素值排序。索引值会被替换成表示新的排序顺序的连续数字。另外，如果指定了d，则排序后的数组会存储在数组d中
|asorti(s [,d]) |将数组s按索引值排序。生成的数组会将索引值作为数据元素值，用连续数字索引来表明排序顺序。另外如果指定了d，排序后的数组会存储在数组d中
|gensub(r, s, h [, t]) |查找变量$0或目标字符串t（如果提供了的话）来匹配正则表达式r。如果h是一个以g 或G开头的字符串，就用s替换掉匹配的文本。如果h是一个数字，它表示要替换掉第h 处r匹配的地方
|gsub(r, s [,t]) |查找变量$0或目标字符串t（如果提供了的话）来匹配正则表达式r。如果找到了，就全部替换成字符串s
|index(s, t) |返回字符串t在字符串s中的索引值，如果没找到的话返回0
|length([s]) |返回字符串s的长度；如果没有指定的话，返回$0的长度
|match(s, r [,a]) |返回字符串s中正则表达式r出现位置的索引。如果指定了数组a，它会存储s中匹配正则表达式的那部分
|split(s, a [,r]) |将s用FS字符或正则表达式r（如果指定了的话）分开放到数组a中。返回字段的总数
|sprintf(format,variables) |用提供的format和variables返回一个类似于printf输出的字符串
|sub(r, s [,t]) |在变量$0或目标字符串t中查找正则表达式r的匹配。如果找到了，就用字符串s替换掉第一处匹配
|substr(s, i [,n]) |返回s中从索引值i开始的n个字符组成的子字符串。如果未提供n，则返回s剩下的部分
|tolower(s) |将s中的所有字符转换成小写
|toupper(s) |将s中的所有字符转换成大写

`split` 函数是将数据字段放到数组中以供进一步处理的好办法。

```shell
$ cat data.txt
1 10
2 20
3 30

$ gawk '{split($0,var); print var[1],var[2]+10}' data.txt
1 20
2 30
3 40
```

### 3、时间函数

`gawk` 编程语言包含一些函数来帮助处理时间值。

|函 数|描 述|
|---|---
|mktime(datespec) |将一个按YYYY MM DD HH MM SS [DST]格式指定的日期转换成时间戳值①
|strftime(format [,timestamp]) |将当前时间的时间戳或timestamp（如果提供了的话）转化格式化日期（采用shell函数date()的格式）
|systime() |返回当前时间的时间戳

下面是在 `gawk` 程序中使用时间函数的例子

```shell
$ gawk 'BEGIN{date = systime(); day = strftime("%A, %B %d, %Y", date); print day}'
星期四, 一月 20, 2022
```

该例用 `systime` 函数从系统获取当前的 `epoch` 时间戳，然后用 `strftime` 函数将它转换成用户可读的格式，转换过程中使用了 `shell` 命令 `date` 的日期格式化字符。

## 九、自定义函数

除了内建函数，还可以在 `gawk` 程序中创建自定义函数。

### 1、使用自定义函数

要定义自己的函数，必须用function关键字。

```shell
function name([variables]) 
{ 
statements 
}
```

定义了 myprint() 函数，然后调用。

```shell
$ cat data.txt
1 10
2 20
3 30

$ awk 'function myprint() {print $1,$2} { myprint()}' data.txt
1 10
2 20
3 30
```

### 2、创建函数库

还可以创建一个库文件，包含要使用的函数，每次使用时，调用即可。

```shell
$ cat funclib
function myprint()
{
 print $1,$2
}

$ cat script
{
 myprint()
}

$ gawk -f funclib -f script data.txt
1 10
2 20
3 30
```

## 推荐阅读：

[《AWK 简明教程》](https://coolshell.cn/articles/9070.html)

[《The AWK Programming Language》](https://book.douban.com/subject/1876898/)
