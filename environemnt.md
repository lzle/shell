# Linux 环境配置


## 基础

安装基础包

```shell
yum -y install epel-release htop vim git
```

关闭selinux

```shell
vim /etc/selinux/config
SELINUX=disabled

setenforce 0
```

关闭防火墙

```shell
systemctl disable firewalld

service iptables stop
```

## 编译

### C 编译

```shell
yum -y install gcc* cmake
```

如果`cmake`版本太低，使用源码安装

```shell
wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
```

解压

```shell
tar zxvf cmake-3.13.4.tar.gz
```

build

```shell
cd cmake-3.13.4
sudo ./bootstrap
sudo make
sudo make install
cmake  --version 
```



