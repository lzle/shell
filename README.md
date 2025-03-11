# Shell 常用命令


## 目录

* [命令行](#命令行)
    * [远程多节点批量执行](#远程多节点批量执行)
    * [非交互修改账号密码](#非交互修改账号密码)
    * [对Json数据进行格式化输出](#对Json数据进行格式化输出)
    * [find 结果批量执行](#find-结果批量执行)
    * [xargs 命令使用](#xargs-命令使用)
    * [grep 命令使用](#grep-命令使用)

* [脚本](#脚本)
    * [文件中写入长字符串](#文件中写入长字符串)

* [文本操作](#文本操作)
    * [单行指定分隔符多行输出](#单行指定分隔符多行输出)
    * [多行指定分隔符单行输出](#多行指定分隔符单行输出)
    * [字符串切割](#字符串切割)
    * [curl 结果值 Format 输出](#curl-结果值-format-输出)
    * [切换用户，使用用户权限](#切换用户，使用用户权限)
    * [按频率执行命令](#按频率执行命令)
    * [汇总计算](#汇总计算)


## 命令行

### 远程多节点批量执行

执行单命令，获取 hostname。

```shell
$ cat do_ip_list | while read line; do echo $line; ip=$line; \
    ssh -n -tt -o StrictHostKeychecking=no root@$ip hostname; done
```

`&&` 执行多命令，双引号内的命令会在远程服务器执行。

```shell
$ cat do_ip_list | while read line; do echo $line; ip=$line; ssh -n -tt \ 
    -o StrictHostKeychecking=no -o ConnectTimeout=10 root@$ip \
    "ps -ef | grep ffm | wc -l && uptime"; done
```

### 非交互修改账号密码

```shell
# 修改密码
$ echo "baishancloud" | passwd --stdin root
更改用户 root 的密码 。
passwd：所有的身份验证令牌已经成功更新。

# 验证密码
$ sshpass -p bsy@2022#bs8 ssh root@10.102.10.10 -o StrictHostKeychecking=no \
 -o ConnectTimeout=5 -o PreferredAuthentications=password 'hostname'
```

### 对Json数据进行格式化输出

```shell
$ echo '{"name":"John","age":30,"city":"New York"}' | python -m json.tool
{
    "name": "John",
    "age": 30,
    "city": "New York"
}
```

### find 结果批量执行

使用 + 而不是 \; 可以一次性对所有匹配的文件执行命令，而不是对每个文件执行一次命令。这样可以提高效率。

```shell
find . -type f -exec echo {} + 

find /path/to/dir -name "*.tmp" -exec rm {} \;
```

### xargs 命令使用

xargs 命令的常用选项：

* -0：由空字符(null)分隔，而不是空白字符(whitespace)。禁用引号和反斜杠处理。
* -a：从文件读取参数，而非标准输入。
* -d：指定分隔符，缺省为空白符：空格、换行等。
* -E：设置“文件结束符”。在处理标准输入时，如果遇到“文件结束符”，则其后的所有输入都将被忽略。
* -i：参数替换，用从标准输入读取的参数替换 initial arguments 中的内容{}；如果需要指定非{}，则使用-I（i的大写）选项指定。
* -n：指定每个命令行参数的个数。
* -P：指定并行执行的最大进程数。
* -p：执行命令前提示用户确认。
* -r：忽略无法执行的命令。
* -s：限制命令及参数总字符数。
* -t：在执行命令之前先打印命令。
* -x：用于确保xargs在命令行长度（-s选项指定）超出限制时停止执行。

拷贝 100 天前的文件到指定目录

```shell
find /root/baishan/s2-init/script/ -type f -mtime +100 | xargs -i cp {} /opt/pbx/tmp/
```

处理文件名中包含空格的情况

```shell
find /path/to/dir -name "*.tmp" -print0 | xargs -0 rm
```

指定分隔符

```shell
echo "file1;file2;file3" | xargs -d ";"
file1 file2 file3

echo "file1;file2;file3" | xargs -d ";" -n 1
file1
file2
file3
```

批量执行命令

```shell
find . -name "*.txt" -print | xargs -I {} sh -c 'cp {} {}.backup; mv {} new_location/'
```

指定每行输出个数

```shell
echo {0..9} | xargs -n 2 echo
0 1
2 3
4 5
6 7
8 9
```

### grep 命令使用

匹配文本中的数字行

```shell
$ cat numfile
915492083
7
650
44197
309562834710
28
96740531289
153
7048392
```

通用匹配

```shell
$ grep -E '[0-9]{9}' numfile
915492083
309562834710
96740531289
```

精确匹配

```shell
$ grep -E '^[0-9]{9}$' numfile
915492083

$ grep -E '\b[0-9]{9}\b' numfile
915492083
```

## 脚本

### 文件中写入长字符串

```shell
$ cat > test.txt <<EOF
> first line
> second line
> EOF

$ cat test.txt
first line
second line
```

## 文本操作


### 单行指定分隔符多行输出

```shell
$ echo "10.103.10.33 10.103.10.17 10.103.10.138" | awk '{for(n=1;n<=NF;n++) print $n}'
10.103.10.33
10.103.10.17
10.103.10.138
```

### 多行指定分隔符单行输出

```shell
$ echo "
10.103.10.33
10.103.10.17
10.103.10.138
" | awk '{printf "%s ", $0}'

10.103.10.33 10.103.10.17 10.103.10.138

$ echo "
10.103.10.33
10.103.10.17
10.103.10.138
" | awk '{printf $0 " "}'

10.103.10.33 10.103.10.17 10.103.10.138
```

### 字符串切割

```shell
$ echo "every good" | awk '{print substr($1,1,1)}'
e
$ echo "every good" | awk '{print substr($1,3)}'
ery
$ echo "every good" | awk '{print substr($2,3)}'
od
$ echo "every good" | awk '{print substr($0,7,2)}'
go
```

### curl 结果值 Format 输出

获取 HTTP 建立连接、请求总时间、状态码等信息。

```shell
for i in $(seq 1 10); do
    curl -w "Iteration $i\nHTTP status code: %{http_code}\nConnect time: %{time_connect} seconds\nTime to first byte: %{time_starttransfer} seconds\nTotal time: %{time_total} seconds\nDownload size: %{size_download} bytes\n" -o /dev/null -s http://ss.bscstorage.com
done
```

#### 切换用户，使用用户权限

```shell
sudo su -
sudo su - hadoop 
sudo -u hadoop /opt/hadoop/bin/hdfs dfs -ls /
```


#### 按频率执行命令

间隔 2 秒执行一次命令

```shell
$ watch -n 2 ceph -s
```

### 汇总计算

统计每行字符串特定前缀出现的次数。

```shell
$ cat data.txt
[09/Nov/2022:22:21:53
[09/Nov/2022:22:21:53
[09/Nov/2022:22:21:53
[09/Nov/2022:22:22:04

$ cat data.txt | awk '{++a[substr($1,1,length($1)-3)]}END{for( k in a ){print k, a[k]}}'
[09/Nov/2022:22:21 3
[09/Nov/2022:22:22 1
```

统计同字符串第二个字段值的总和。

```shell
$ cat data.txt
gdsd 123
gdsd 456
gdsd 789
alpha 101
beta 202
gamma 303
delta 404
omega 505
......

$ cat data.txt | awk '{a[$1]+=$2}END{for( k in a ){print k, a[k]}}'
gdsd 1368
alpha 101
beta 202
gamma 303
delta 404
omega 505
```

统计所有第二个字段值的总和。

```shell
$ awk '{sum += $2} END {print sum}' output.txt
```



## 推荐阅读：

[《应该知道的 LINUX 技巧》](https://coolshell.cn/articles/8883.html)
[《xargs 命令教程》](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)
