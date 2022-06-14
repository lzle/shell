# Centos 系统


## 一、系统环境

### 1、PATH

PATH 是可执行文件路径 命令行中的命令，如ls等等，都是系统通过 PATH 找到了这个命令执行文件的所在位置，再 run 这个命令（可执行文件）。
所以，PATH 配置的路径下的文件可以在任何位置执行，并且可以通过 which 可执行文件 命令来找到该文件的位置

```shell
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

设置临时生效：


```shell
$ export PATH=$PATH:/test/bin
$ echo  $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/test/bin
```

设置永久生效：

```shell
cat >>/etc/profile <<EOF

export PATH=\$PATH:/test/bin
EOF
source /etc/profile
```

### 2、LIBRARY_PATH

LIBRARY_PATH环境变量用于在程序编译期间查找动态链接库时指定查找共享库的路径， 例如，指定gcc编译需要用到的动态链接库的目录。

设置永久生效：

```shell
cat >>/etc/profile <<EOF

export LIBRARY_PATH=\$LIBRARY_PATH:/usr/local/lib
EOF
source /etc/profile
```


### 3、LD_LIBRARY_PATH

LD_LIBRARY_PATH环境变量用于在程序加载运行期间查找动态链接库时指定除了系统默认路径之外的其他路径，
注意，LD_LIBRARY_PATH中指定的路径会在系统默认路径之前进行查找。

设置永久生效：

```shell
cat >>/etc/profile <<EOF

export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib
EOF
source /etc/profile
```

举个例子，我们开发一个程序，经常会需要使用某个或某些动态链接库，为了保证程序的可移植性，可以先将这些编译好的动态链接库放在自己指定的目录下，
然后按照上述方式将这些目录加入到LD_LIBRARY_PATH环境变量中，这样自己的程序就可以动态链接后加载库文件运行了。