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

## 推荐阅读：

[《应该知道的 LINUX 技巧》](https://coolshell.cn/articles/8883.html)
