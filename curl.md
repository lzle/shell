# Curl 指南

curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。

它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。

## 一、常用操作

### 1、发起请求

直接在 curl 命令后加上网址，就可以看到 http 响应结果，以网址 http://ss.bscstorage.com 为例。

```shell
$ curl http://ss.bscstorage.com
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
$ curl -i http://ss.bscstorage.com
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
$ curl -v http://ss.bscstorage.com
*   Trying 223.95.58.231...
* TCP_NODELAY set
* Connected to http://ss.bscstorage.com (223.95.58.231) port 80 (#0)
> GET / HTTP/1.1
> Host: http://ss.bscstorage.com
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
* Connection #0 to host http://ss.bscstorage.com left intact
</Error>* Closing connection 0
```

如果你觉得上面的信息还不够，那么下面的命令可以查看更详细的通信过程。

```shell
$ curl --trace output.txt http://ss.bscstorage.com
```

或者

```shell
$ curl --trace-ascii output.txt http://ss.bscstorage.com
```

### 4、发送表单信息

发送表单信息有 GET 和 POST 两种方法。GET 方法相对简单，只要把数据附在网址后面就行。

```shell
$ curl http://ss.bscstorage.com?data1=xxx&data2=xxx
```

POST 方法必须把数据和网址分开，curl 就要用到 --data 参数。

```shell
$ curl -X POST -d "data1=xxx" -d "data2=xxx" http://ss.bscstorage.com
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
$ curl --header "Content-Type:application/json" http://ss.bscstorage.com
```

### 9、cookie 使用

`-c cookie-file`可以保存服务器返回的cookie到文件，`-b cookie-file`可以使用这个文件作为cookie信息，进行后续的请求。

```shell
$ curl -c cookies http://ss.bscstorage.com
$ curl -b cookies http://ss.bscstorage.com
```

### 10、x-header-trace:all

```
$ curl -vo /dev/null  -H 'x-header-trace:all'  http://heroclient.jumpwgame.com/xclient_unpack/fightmap/art/loading.png
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 112.29.218.144...
* TCP_NODELAY set
* Connected to heroclient.jumpwgame.com (112.29.218.144) port 80 (#0)
> GET /xclient_unpack/fightmap/art/loading.png HTTP/1.1
> Host: heroclient.jumpwgame.com
> User-Agent: curl/7.64.1
> Accept: */*
> x-header-trace:all
>
< HTTP/1.1 200 OK
< Date: Wed, 20 Mar 2024 08:56:45 GMT
< Content-Type: image/png
< Content-Length: 301066
< Connection: keep-alive
< Server: openresty/1.13.6.3
< x-amz-request-id: 4d27da56-2403-2016-3933-e8611f1b288f
< x-amz-s2-requester: GRPS000000ANONYMOUSE
< Last-Modified: Thu, 14 Mar 2024 17:20:51 GMT
< ETag: "2df094933ed354800007c9af42e81e14"
< x-amz-meta-s2-size: 301066
< Cache-Control: max-age=31536000
< Accept-Ranges: bytes
< X-Ser: BC145_, BC144_
< X-Refresh-Pattern: -i \.(swf|jpg|jpeg|gif|png|webp|bmp|ico)(\?|$) 1440 100% 1440 override-lastmod ignore-reload
< X-Swap-File: /ssd3/cache0/cache1/00/01/000001C1
< X-Channel-Name: heroclient.jumpwgame.com
< X-Traffic-Domain: heroclient.jumpwgame.com
< X-Store-Url: http://heroclient.jumpwgame.com/xclient_unpack/fightmap/art/loading.png
< X-Local-Addr: 112.29.218.144:18002
< X-Upstream-Addr: -
< X-Upstream-Status: -
< X-Upstream-Host: -
< X-Upstream-Url: -
< X-Upstream-Conn: -
< X-Antileech-Msg: -
< X-Uncachable-reason: -
< X-Store-Complete: YES
< X-First-Use: -
< X-Upstream-Name: -
< X-Upstream-Is-Parent: -
< X-Forward-Local-Port: 0
< X-Forward-Dst-Ip: -
< Bs-Internal-Hitstatus: TCP_HIT
< Bs-Hierarchy-Status: NONE
< X-Internal-Error: -
< X-Reason-403: -
< X-Internal-Details: -
<
{ [3142 bytes data]
100  294k  100  294k    0     0  1872k      0 --:--:-- --:--:-- --:--:-- 1860k
* Connection #0 to host heroclient.jumpwgame.com left intact
* Closing connection 0
```


## 二、参数使用

### 1、-A

-A 参数指定客户端的用户代理标头，即 User-Agent。curl 的默认用户代理字符串是 curl/[version]。

```shell
$ curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'  http://ss.bscstorage.com
```

上面命令将 User-Agen t改成 Chrome 浏览器。

```shell
$ curl -A ''  http://ss.bscstorage.com
```

上面命令会移除User-Agent标头。

也可以通过-H 参数直接指定标头，更改 User-Agent。

```shell
$ curl -H 'User-Agent: php/1.0'  http://ss.bscstorage.com
```

### 2、-b

-b 参数用来向服务器发送 Cookie。

```shell
$ curl -b 'foo=bar' http://ss.bscstorage.com
```

上面命令会生成一个标头 Cookie: foo=bar，向服务器发送一个名为 foo、值为 bar 的 Cookie。

```shell
$ curl -b 'foo1=bar;foo2=bar2' http://ss.bscstorage.com
```

上面命令发送两个 Cookie。

```shell
$ curl -b cookies.txt http://ss.bscstorage.com
```

上面命令读取本地文件 cookies.txt，里面是服务器设置的 Cookie（参见-c参数），将其发送到服务器。

### 3、-c

-c 参数将服务器设置的 Cookie 写入一个文件。

```shell
$ curl -c cookies.txt http://ss.bscstorage.com
```

上面命令将服务器的 HTTP 回应所设置 Cookie 写入文本文件 cookies.txt。

### 4、-d

-d 参数用于发送 POST 请求的数据体。

```shell
$ curl -d'login=emma＆password=123'-X POST http://ss.bscstorage.com/login
# 或者
$ curl -d 'login=emma' -d 'password=123' -X POST  http://ss.bscstorage.com/login
```

使用 -d 参数以后，HTTP 请求会自动加上标头 Content-Type : application/x-www-form-urlencoded。并且会自动将请求转为 POST 方法，因此可以省略-X POST。

-d 参数可以读取本地文本文件的数据，向服务器发送。

```shell
$ curl -d '@data.txt' http://ss.bscstorage.com/login
```

上面命令读取 data.txt 文件的内容，作为数据体向服务器发送。

### 5、-e

-e 参数用来设置 HTTP 的标头 Referer，表示请求的来源。

```shell
curl -e 'http://google.com?q=example' http://www.example.com
```
上面命令将Referer标头设为 http://google.com?q=example。

-H 参数可以通过直接添加标头 Referer，达到同样效果。

```shell
curl -H 'Referer: http://google.com?q=example' http://www.example.com
```

### 6、-F

-F 参数用来向服务器上传二进制文件。

```shell
$ curl -F 'file=@photo.png' http://ss.bscstorage.com/profile
```

上面命令会给 HTTP 请求加上标头 Content-Type: multipart/form-data，然后将文件 photo.png 作为 file 字段上传。

-F 参数可以指定 MIME 类型。

```shell
curl -F 'file=@photo.png;type=image/png' http://ss.bscstorage.com/profile
```

上面命令指定 MIME 类型为 image/png，否则 curl 会把 MIME 类型设为 application/octet-stream。

-F 参数也可以指定文件名。

```shell
$ curl -F 'file=@photo.png;filename=me.png'http://ss.bscstorage.com/profile
```

上面命令中，原始文件名为 photo.png，但是服务器接收到的文件名为 me.png。

### 7、-G

-G 参数用来构造 URL 的查询字符串。

```shell
$ curl -G -d 'q=kitties' -d 'count=20' http://ss.bscstorage.com/search
```

上面命令会发出一个 GET 请求，实际请求的 URL 为http://ss.bscstorage.com/search?q=kitties&count=20。如果省略--G，会发出一个 POST 请求。

如果数据需要 URL 编码，可以结合 --data--urlencode 参数。

```shell
$ curl -G --data-urlencode 'comment=hello world' http://ss.bscstorage.com
```

### 8、-H

-H 参数添加 HTTP 请求的标头。

```shell
$ curl -H 'Accept-Language: en-US' http://ss.bscstorage.com
```

上面命令添加 HTTP 标头Accept-Language: en-US。

```shell
curl -H 'Accept-Language: en-US' -H 'Secret-Message: xyzzy' http://ss.bscstorage.com
```

上面命令添加两个 HTTP 标头。

```shell
 curl -d '{"login": "emma", "pass": "123"}' -H 'Content-Type: application/json' http://ss.bscstorage.com/login
```

上面命令添加 HTTP 请求的标头是 Content-Type: application/json，然后用-d参数发送 JSON 数据。

### 9、-i

-i 参数打印出服务器回应的 HTTP 标头

```shell
$ curl -i http://ss.bscstorage.com
```

上面命令收到服务器回应后，先输出服务器回应的标头，然后空一行，再输出网页的源码。

### 10、-I

-I 参数向服务器发出 HEAD 请求，然会将服务器返回的 HTTP 标头打印出来。

```shell
$ curl -I http://ss.bscstorage.com
```

上面命令输出服务器对 HEAD 请求的回应。

--head参数等同于-I。

```shell
$ curl --head http://ss.bscstorage.com
```

### 11、-k

-k 参数指定跳过 SSL 检测。

```shell
$ curl -k https://ss.bscstorage.com
```

上面命令不会检查服务器的 SSL 证书是否正确。

### 12、-L

-L 参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向。

```shell
$ curl -L -d 'tweet=hi' https://api.twitter.com/tweet
```

### 13、--limit-rate

--limit-rate 用来限制 HTTP 请求和回应的带宽，模拟慢网速的环境。

```shell
$ curl --limit-rate 200k http://ss.bscstorage.com
```

上面命令将带宽限制在每秒 200K 字节。

### 14、-o

-o 参数将服务器的回应保存成文件，等同于 wget 命令。

```shell
$ curl -o bscstorage.html http://ss.bscstorage.com
```

### 15、-O

-O 参数将服务器回应保存成文件，并将 URL 的最后部分当作文件名。

```shell
$ curl -O http://ss.bscstorage.com/foo/bar.html

```
上面命令将服务器回应保存成文件，文件名为 bar.html。

### 16、-u

-u参数用来设置服务器认证的用户名和密码。

```shell
$ curl -u 'bob:12345' http://ss.bscstorage.com/login
```

上面命令设置用户名为 bob，密码为 12345，然后将其转为 HTTP 标头Authorization: Basic Ym9iOjEyMzQ1。

curl 能够识别 URL 里面的用户名和密码。

```shell
$ curl http://bob:12345@ss.bscstorage.com/login
```

上面命令能够识别 URL 里面的用户名和密码，将其转为上个例子里面的 HTTP 标头。

```shell
$ curl -u 'bob' http://ss.bscstorage.com/login
```

上面命令只设置了用户名，执行后，curl 会提示用户输入密码。

### 17、-x

-x 参数指定 HTTP 请求的代理。

```shell
$ curl -x socks5://james:cats@myproxy.com:8080 http://ss.bscstorage.com
```

上面命令指定 HTTP 请求通过 myproxy.com:8080的 socks5 代理发出。

如果没有指定代理协议，默认为 HTTP。

```shell
$ curl -x james:cats@myproxy.com:8080 http://ss.bscstorage.com
```

上面命令中，请求的代理使用 HTTP 协议。


