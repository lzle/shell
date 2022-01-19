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

