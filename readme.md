# Shell 编程

## 一、 常用技巧

### 1、 多服务器批量执行命令

```shell
$ cat do_ip_list | while read line; do echo $line; ip=$line; ssh -n -tt -o StrictHostKeychecking=no root@$ip hostname; done
```

### 2、文件中写入长字符串

```shell
$ cat > test.txt <<EOF
> first line
> second line
> EOF

$ cat test.txt
first line
second line
```

### 3、非交互修改账号密码

```shell
$ echo "baishancloud" | passwd --stdin root
更改用户 root 的密码 。
passwd：所有的身份验证令牌已经成功更新。

$ sshpass -p bsy@2022#bs8 ssh root@10.102.10.10 -o StrictHostKeychecking=no -o ConnectTimeout=5 -o PreferredAuthentications=password 'hostname'
```

### 4、单行按照指定字符分割成多行输出

```shell
$ echo "10.103.10.33 10.103.10.17 10.103.10.138" |  awk -F" " '{for(i=1;i<=NF;i++) print $i}'
10.103.10.33
10.103.10.17
10.103.10.138
```

### 5、字符串切割

```
$ echo "every good" | awk '{print substr($1,1,1)}'    #returns e
$ echo "every good" | awk '{print substr($1,3)}'     #returns ery
$ echo "every good" | awk '{print substr($1,3)}'     #returns ery
$ echo "every good" | awk '{print substr($2,3)}'     #returns od
$ echo "every good" | awk '{print substr($0,7,2)}'   #returns go
```

### 6、根据时间统计次数

```
$ cat data.txt
[09/Nov/2022:22:21:53
[09/Nov/2022:22:21:53
[09/Nov/2022:22:21:53
[09/Nov/2022:22:22:04

$ cat data.txt | awk '{++a[substr($1,1,length($1)-3)]}END{for( k in a ){print k, a[k]}}'
[09/Nov/2022:22:21 3
[09/Nov/2022:22:22 1
```

### 7、对Json数据进行格式化输出

```
$ echo '{"name":"John","age":30,"city":"New York"}' | python -m json.tool
{
    "name": "John",
    "age": 30,
    "city": "New York"
}
```


### 8、配置ulimit文件描述符限制10240

```
sudo su -

ulimit -n 102400

echo "# /etc/security/limits.conf
#
#This file sets the resource limits for the users logged in via PAM.
#It does not affect resource limits of the system services.
#
#Also note that configuration files in /etc/security/limits.d directory,
#which are read in alphabetical order, override the settings in this
#file in case the domain is the same or more specific.
#That means for example that setting a limit for wildcard domain here
#can be overriden with a wildcard setting in a config file in the
#subdirectory, but a user specific setting here can be overriden only
#with a user specific setting in the subdirectory.
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#
#Where:
#<domain> can be:
#        - a user name
#        - a group name, with @group syntax
#        - the wildcard *, for default entry
#        - the wildcard %, can be also used with %group syntax,
#                 for maxlogin limit
#
#<type> can have the two values:
#        - "soft" for enforcing the soft limits
#        - "hard" for enforcing hard limits
#
#<item> can be one of the following:
#        - core - limits the core file size (KB)
#        - data - max data size (KB)
#        - fsize - maximum filesize (KB)
#        - memlock - max locked-in-memory address space (KB)
#        - nofile - max number of open file descriptors
#        - rss - max resident set size (KB)
#        - stack - max stack size (KB)
#        - cpu - max CPU time (MIN)
#        - nproc - max number of processes
#        - as - address space limit (KB)
#        - maxlogins - max number of logins for this user
#        - maxsyslogins - max number of logins on the system
#        - priority - the priority to run user process with
#        - locks - max number of file locks the user can hold
#        - sigpending - max number of pending signals
#        - msgqueue - max memory used by POSIX message queues (bytes)
#        - nice - max nice priority allowed to raise to values: [-20, 19]
#        - rtprio - max realtime priority
#
#<domain>      <type>  <item>         <value>
#

#*               soft    core            0
#*               hard    rss             10000
#@student        hard    nproc           20
#@faculty        soft    nproc           20
#@faculty        hard    nproc           50
#ftp             hard    nproc           0
#@student        -       maxlogins       4

# End of file
* soft nofile 102400
* hard nofile 102400
* soft nproc 102400
* hard nproc 102400
* soft memlock unlimited
* hard memlock unlimited
" > /etc/security/limits.conf
```


## 推荐阅读：

[《应该知道的 LINUX 技巧》](https://coolshell.cn/articles/8883.html)
