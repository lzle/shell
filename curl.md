# Curl 指南

curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。

它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。

## 一、常用操作

### 1、发起请求

直接在 curl 命令后加上网址，就可以看到 http 响应结果，以网址 ss.bscstorage.com 为例。

```shell
$ curl ss.bscstorage.com
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>AccessDenied</Code>
  <Message>anonymous is not allowed for operation: REST.GET.SERVICE</Message>
  <Resource>/</Resource>
  <RequestId>09c67c33-2205-0622-3840-e8611f1b287d</RequestId>
</Error>%
```

如果要把这个网页保存下来，可以使用 `-o` 参数，这就相当于使用 wget 命令了。

```shell
$ curl -o [文件名] www.bscstorage.com
```

### 2、显示头信息

`-i` 参数可以显示 http response 的头信息，连同网页代码一起。

```shell
$ curl -i ss.bscstorage.com
HTTP/1.1 403 Forbidden
Server: openresty/1.13.6.3
Date: Fri, 06 May 2022 14:41:46 GMT
Content-Type: application/xml
Connection: keep-alive
x-amz-s2-requester: GRPS000000ANONYMOUSE
x-amz-request-id: 7a8f1c32-2205-0622-4146-e8611f1b288f
x-error-code: AccessDenied
Content-Length: 248

<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>AccessDenied</Code>
  <Message>anonymous is not allowed for operation: REST.GET.SERVICE</Message>
  <Resource>/</Resource>
  <RequestId>7a8f1c32-2205-0622-4146-e8611f1b288f</RequestId>
</Error>%
```

`-I` 参数则是只显示 http response 的头信息。

### 3、显示通信过程

`-v` 参数可以显示一次http通信的整个过程，包括端口连接和 http request 头信息。

```shell
$ curl -v ss.bscstorage.com
*   Trying 223.95.58.231...
* TCP_NODELAY set
* Connected to ss.bscstorage.com (223.95.58.231) port 80 (#0)
> GET / HTTP/1.1
> Host: ss.bscstorage.com
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 403 Forbidden
< Server: openresty/1.13.6.3
< Date: Fri, 06 May 2022 14:46:48 GMT
< Content-Type: application/xml
< Connection: keep-alive
< x-amz-s2-requester: GRPS000000ANONYMOUSE
< x-amz-request-id: 50c06904-2205-0622-4648-a0369fd80cca
< x-error-code: AccessDenied
< Content-Length: 248
<
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>AccessDenied</Code>
  <Message>anonymous is not allowed for operation: REST.GET.SERVICE</Message>
  <Resource>/</Resource>
  <RequestId>50c06904-2205-0622-4648-a0369fd80cca</RequestId>
* Connection #0 to host ss.bscstorage.com left intact
</Error>* Closing connection 0
```

如果你觉得上面的信息还不够，那么下面的命令可以查看更详细的通信过程。

```shell
$ curl --trace output.txt ss.bscstorage.com
```

或者

```shell
$ curl --trace-ascii output.txt ss.bscstorage.com
```

### 4、发送表单信息

发送表单信息有 GET 和 POST 两种方法。GET 方法相对简单，只要把数据附在网址后面就行。

```shell
$ curl ss.bscstorage.com?data1=xxx&data2=xxx
```

POST 方法必须把数据和网址分开，curl 就要用到 --data 参数。

```shell
$ curl -X POST -d "data1=xxx" -d "data2=xxx" ss.bscstorage.com
```

### 5、HTTP 动词

curl 默认的HTTP动词是 GET，使用 `-X` 参数可以支持其他动词。

```shell
$ curl -X POST www.example.com
$ curl -X DELETE www.example.com
```

### 6、Referer 字段

有时你需要在 http request 头信息中，提供一个 referer 字段，表示你是从哪里跳转过来的。

```shell
$ curl --referer http://www.example.com http://www.example.com
```

### 7、User Agent 字段

这个字段是用来表示客户端的设备信息。 curl 可以这样模拟：

```shell
$ curl --user-agent "[User Agent]" [URL]
```

### 8、增加头信息

有时需要在 http request 之中，自行增加一个头信息。`--header` 参数就可以起到这个作用。

```shell
$ curl --header "Content-Type:application/json" ss.bscstorage.com
```

### 9、cookie 使用

`-c cookie-file`可以保存服务器返回的cookie到文件，`-b cookie-file`可以使用这个文件作为cookie信息，进行后续的请求。

```shell
$ curl -c cookies ss.bscstorage.com
$ curl -b cookies ss.bscstorage.com
```





