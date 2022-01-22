# Shell 编程

## 一、 常用技巧

### 1、 多服务器批量执行命令

```shell
$ cat do_ip_list | while read line; do echo $line; ip=$line; ssh -n -tt root@$ip hostname; done
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
```


## 推荐阅读：

[《应该知道的 LINUX 技巧》](https://coolshell.cn/articles/8883.html)
