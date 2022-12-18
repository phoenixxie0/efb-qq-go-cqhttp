参考链接：

1.[go-cqhttp帮助中心](https://docs.go-cqhttp.org/)
部分移动大内网打不开。大部分问题都能在里面得到解决。

2.[efb-qq-plugin-go-cqhttp配置文档](https://github.com/ehForwarderBot/efb-qq-plugin-go-cqhttp#efb-qq-plugin-go-cqhttp)

3.[efb-qq-go-cqhttp的Docker地址](https://hub.docker.com/r/phoenixxie/efb-qq-go-cqhttp)

4.[efb官方文档](https://github.com/ehForwarderBot/ehForwarderBot/wiki/Modules-Repository)

5.[go-cqhttp下载](https://github.com/Mrs4s/go-cqhttp/releases/)

6.[efb-filter-middleware中间件](https://github.com/xzsk2/efb-filter-middleware)

**本文多以图形化界面演示，喜欢命令行的自行操作。**



# 一、下载efb-qq-go-cqhttp镜像
登录ssh，输入下列代码
```
docker pull phoenixxie/efb-qq-go-cqhttp:latest
```
或者直接去群晖检索下载，url地址点击[这里](https://hub.docker.com/r/phoenixxie/efb-qq-go-cqhttp)
![image](https://user-images.githubusercontent.com/50565072/177001693-7642f1f1-9b61-436c-95ab-b7da799d816e.png)
![image](https://user-images.githubusercontent.com/50565072/177001698-e7714cde-c806-402e-9abb-50c6c7e7a935.png)


# 二、获取电报机器人token和UID
## 1.创建机器人
TG搜索botfather，认准官方账号
![image](https://user-images.githubusercontent.com/50565072/177001854-a87c40ec-7435-46c2-aef8-1c991b225178.png)

在对话框输入/ 点击
```
/newbot
```

即可创建新机器人
按照指示取名字，就好像你的QQ昵称可以随时修改。

![image](https://user-images.githubusercontent.com/50565072/177001870-21fea189-8f99-4241-bc94-4a07bc5a5b18.png)

按照指示取机器人号，类似你的QQ号，必须用bot结尾，不可修改。

创建成功会收到这样一条信息：

![image](https://user-images.githubusercontent.com/50565072/177001884-343cd9de-3ea4-46e5-af3e-7c12002b37b7.png)

第二处马赛克部分就是我们需要的bot token，这个请保存好，注意不要泄露。
点击第一处马赛克的链接，跳转到你的机器人，点击开始。这样就添加好了你的机器人啦。
## 2.设置机器人
继续对botfather对话
```
/setcommands
```
选择你的bot
粘贴如下命令并发送
```
help - 显示命令列表
link - 将远程会话绑定到 Telegram 群组
chat - 生成会话头
info - 显示当前 Telegram 聊天的信息
unlink_all - 将所有远程会话从Telegram 群组解绑
update_info - 更新当前群组名称和头像，和QQ同步
rm - 撤回某条消息。和QQ的撤回时间是一样的，具体使用为回复要撤回的内容，发送 /rm
extra - 掉线重新登录或强制刷新对话列表
```
与botfather对话
```
/setjoingroups  
```
选择``enable``，来允许您的 bot 加入群组。


```
/setprivacy 
```
选择``disable``，来禁用隐私限制，以使其能读取群组内的所有消息。

还可以在botfather处给你的机器人添加头像、修改昵称、修改描述。

## 3.获取UID
（1）如果你是plus messager用户，直接点开设置，在个人资料卡就能直接看到id。

（2）常规获取方法：搜索@get_id_bot ，输入/start，就能获得你的ID


# 三、创建容器
注：此处只讲群晖的安装方法，需要纯命令行的，请自行查阅资料依葫芦画瓢。
## 1.在群晖创建一个目录efb-qq-go-cqhttp
用于存放备份配置等数据，迁移重装的时候只需要备份整个efb-qq-go-cqhttp目录即可。
目录结构如下

```
efb-qq-go-cqhttp
├── go-cqhttp
└── profiles
    └── default
        ├── blueset.telegram
        │   ├── config.yaml
        ├── config.yaml
        └── milkice.qq
            ├── config.yaml
```

具体配置内容见参考链接，本人贴出的仅供参考，每项代表什么也请自行查阅官方文档说明。

``/docker/efb-qq-go-cqhttp/profiles/default/milkice.qq/config.yaml``

```
Client: GoCQHttp                      # 指定要使用的 QQ 客户端（此处为 GoCQHttp）
GoCQHttp:
    type: HTTP                        # 指定 efb-qq-plugin-go-cqhttp 与 GoCQHttp 通信的方式 现阶段仅支持 HTTP
    access_token:
    api_root: http://127.0.0.1:5700/  # GoCQHttp API接口地址/端口
    host: 127.0.0.1                # efb-qq-slave 所监听的地址用于接收消息
    port: 8000                        # 同上
```


``/docker/efb-qq-go-cqhttp/profiles/default/blueset.telegram/config.yaml``

```
token: "00000000:AAAAAAAAAA" #引号内请替换为自己的bottoken
admins:
  - 111111111 #替换为自己的Telegram UID 
request_kwargs:                         #不需要请删除第4-7行代码。支持添加代理文件，HTTP和SOCKS5均支持，具体格式请自行查阅 https://github.com/ehForwarderBot/efb-telegram-master/wiki/Network-Configuration-and-Proxy
    read_timeout: 6
    connect_timeout: 7
    proxy_url: http://XXX.XXX.XXX:端口号/
#实验性功能 我照抄wechat的
flags:
  chats_per_page: 20 #选择/ chat和/ link命令时显示的聊天次数。过大的值可能导致这些命令的故障
  network_error_prompt_interval: 100 #每收到n个错误后再通知用户有关网络错误的信息。 设置为0可禁用它
  multiple_slave_chats: true #默认true #将多个远程聊天链接到一个Telegram组。使用未关联的聊天功能发送和回复。禁用以远程聊天和电报组一对一链接。
  prevent_message_removal: true  #当从通道需要删除消息时，如果此值为true，EFB将忽略该请求。
  auto_locale: true #自动从管理员的消息中检测区域设置。否则将使用在环境变量中定义的区域设置。
  retry_on_error: false #在向Telegram Bot API发送请求时发生错误时无限重试。请注意，这可能会导致重复的消息传递，因为Telegram Bot API的响应不可靠，并且可能无法反映实际结果
  send_image_as_file: false #将所有图片消息以文件发送，以积极避免 Telegram 对于图片的压缩。
  message_muted_on_slave: "mute" #normal:作为普通信息发送给Telegram silent:发送给Telegram作为正常消息，但没有通知声音 mute:不要发送给Telegram
  your_message_on_slave: "silent" #在从属通道平台上收到消息时的行为。这将覆盖message_muted_on_slave中的设置。
  animated_stickers: true #启用对动态贴纸的实验支持。注意：您可能需要安装二进制依赖 ``libcairo`` 才能启用此功能。
  send_to_last_chat: true #在未绑定的会话中快速回复。enabled：启用此功能并关闭警告。warn：启用该功能，并在自动发送至不同收件人时发出警告。disabled：禁用此功能。
```


``/docker/efb-qq-go-cqhttp/profiles/default/config.yaml``

中间件有不少，但需要的安装环境、文件、配置，请查询官方文档。目测QQ只有下面这一个可以用。本文也有部分举例描述，可以参考。
```
master_channel: blueset.telegram
slave_channels:
  - milkice.qq
middlewares:     #新手小白待阅读完全文后再按需添加，否则启动会报错。
#  - xzsk2.filter #根据自己的情况决定是否启用[使用参考]https://github.com/xzsk2/efb-filter-middleware
```

## 2.创建容器
在群晖的docker套件里面双击下载好的镜像文件。
创建容器，点击高级设置。

![Snipaste_2022-09-27_15-24-23](https://user-images.githubusercontent.com/50565072/192477074-992d83a2-d7b5-4a62-9b73-4389a1da1d49.png)


卷→添加文件夹。
将对应目录挂载到``/root/.ehforwarderbot/profiles/default/``和``/root/go-cqhttp/``即可。
非常建议挂载``/go-cqhttp``文件夹。因为这里保存的是go-cqhttp文件和🐧端的登录信息，如果docker image更新，且你未挂载该文件夹。那么你将丢失你的登录信息，再次登录则需要重新验证，容易触发风控。

![Snipaste_2022-09-27_15-31-14](https://user-images.githubusercontent.com/50565072/192477601-2a3e6700-3806-46c5-9924-5e8d28e400a8.png)


# 四、登录QQ
## 1.安装go-cqhttp
运行一次docker，查看docker日志。

![Snipaste_2022-09-26_15-31-59](https://user-images.githubusercontent.com/50565072/192477868-0b94a130-860f-4e52-b658-ba7b4b0ae582.png)
![Snipaste_2022-09-26_15-32-12](https://user-images.githubusercontent.com/50565072/192477876-6591ace2-cc90-41c8-ad03-d3877a8800e4.png)

如果提示连接github失败、解压失败等报错，请手动下载对应架构的[go-cqhttp](https://github.com/Mrs4s/go-cqhttp/releases/)，压缩包放置于/docker/efb-qq-go-cqhttp/go-cqhttp/文件夹内，不要解压。再次重启docker，观察日志是否正常，是否解压相关文件。

进入ssh，输入下列代码。
```
docker exec -it efb-qq-go-cqhttp ash
cd /root/go-cqhttp
./go-cqhttp
0
```

![Snipaste_2022-09-26_16-23-12](https://user-images.githubusercontent.com/50565072/192479065-94dc234c-2a33-479d-acce-81efd755a52c.png)

## 2.填写go-cqhttp配置文件并重新启动docker

查看nas上挂载的go-cqhttp文件夹是否产生了默认配置文件``config.yml``，填写并保存\docker\efb-qq-go-cqhttp\go-cqhttp\config.yml，具体说明查看参考链接1、2。

只修改如下部分，其余的默认配置不懂的就不要修改。

```
account:         # 账号相关
  uin: 000000000 # QQ 账号
  password: ''   # QQ 密码，为空时使用扫码登录

message:
  # 上报数据类型
  # efb-qq-plugin-go-cqhttp 仅支持 array 类型
  post-format: array
  # 为Reply附加更多信息
  extra-reply-data: true


# 默认中间件锚点
default-middlewares: &default
  # 访问密钥，强烈推荐在公网的服务器设置
  access-token: ''

servers:
  # HTTP 通信设置
  - http:
      # HTTP监听地址
      address: 0.0.0.0:5700
      # 反向 HTTP 超时时间, 单位秒
      # 最小值为 5，小于 5 将会忽略本项设置
      timeout: 5
      middlewares:
        <<: *default # 引用默认中间件
      # 反向 HTTP POST 地址列表
      post:
        - url: 'http://127.0.0.1:8000' # 地址
          secret: ''                   # 密钥保持为空
```

保存后重新启动docker。

## 3.登录QQ

进入ssh，输入下列代码。根据提示进行登陆操作。

```
docker exec -it efb-qq-go-cqhttp ash
cd /root/go-cqhttp
./go-cqhttp
```

登陆成功后，文件夹出现如下全部文件。

![Snipaste_2022-09-27_17-29-33](https://user-images.githubusercontent.com/50565072/192489608-a6c9fd84-5366-42c7-9a9c-909e23229530.png)

如果需要重新更换账号之类的操作，保留选中的几个文件，其余全部删除，重新进行登录操作即可。

## 注意事项：

1.如果端口冲突需要对几个配置文件均进行相应修改。


2.关于滑条验证码登录：

该登录方式为默认选择，但近期出现了登陆失败的问题。如果你出现了图中的提示，请选择扫码登录。

![image](https://user-images.githubusercontent.com/50565072/207818823-626c0d0f-e38e-4a0f-999d-1f83ceaeb295.png)

3.关于扫码登录：需要手动选择登录方式为扫码登录。

若docker的宿主机和手机不处于同一个局域网，密码留空的扫码登录会失败。


![Snipaste_2022-09-26_16-37-28](https://user-images.githubusercontent.com/50565072/192487005-5f7978ad-da88-45bb-a8d0-92f6d6a9f96f.png)

若扫码登录遇到提示：当前设备网络不稳定或处于复杂网络环境，为了你的帐号安全，建议将两个设备连接同一网络或将被扫描设备连接你的手机热点后，重新扫码登录。

![image](https://img-blog.csdnimg.cn/cd4bdb954093417facb8a16fe5937590.png)

可以首先查看[对应issue](https://github.com/Mrs4s/go-cqhttp/issues/1469) ，里面提到包括：手机连接服务器的代理进行扫码、使用爱加速等app挂到服务器所在城市……可以自行尝试。

本人提供的解决方法是：

（1）有条件的进行局域网扫码，最简单粗暴。

（2）没有条件的在windows环境登录go-cqhttp，在[go-cqhttp的release界面](https://github.com/Mrs4s/go-cqhttp/releases/)选择windows对应客户端下载并打开。按照前面的配置文件写好config.yaml，进行登录。复制电脑文件夹里面的device.json、session.token到服务器go-cqhttp所在文件夹。


4.如果中途退出了，再进go-cqhttp出现被占用提示，不用反复删除登陆文件，用下面的代码。

![Snipaste_2022-09-26_18-14-23](https://user-images.githubusercontent.com/50565072/192490691-85fbb850-976c-4b02-a502-9ed8fe9e53b3.png)

```
kill -9 $( ps -e|grep go-cqhttp |awk '{print $1}') 
./go-cqhttp
```

5.若确定配置文件和端口没有任何的错误，但登陆时go-cqhttp反复出现如下错误

```
[2022-09-26 18:29:00] [WARNING]: 上报 Event 数据到 http://127.0.0.1:8000 失败: Post "http://127.0.0.1:8000": dial tcp 127.0.0.1:8000: connect: connection refused 将进行第 1 次重试 
[2022-09-26 18:29:01] [WARNING]: 上报 Event 数据到 http://127.0.0.1:8000 失败: Post "http://127.0.0.1:8000": dial tcp 127.0.0.1:8000: connect: connection refused 将进行第 2 次重试 
[2022-09-26 18:29:03] [WARNING]: 上报 Event 数据到 http://127.0.0.1:8000 失败: Post "http://127.0.0.1:8000": dial tcp 127.0.0.1:8000: connect: connection refused 将进行第 3 次重试 
[2022-09-26 18:29:04] [WARNING]: 上报 Event 数据 {"post_type":"meta_event","meta_event_type":"heartbeat","time":1664188140,"self_id":QQ号,"status":{"app_enabled":true,"app_good":true,"app_initialized":true,"good":true,"online":true,"plugins_good":null,"stat":{"packet_received":317,"packet_sent":306,"packet_lost":0,"message_received":2,"message_sent":0,"last_message_time":1664188130,"disconnect_times":0,"lost_times":0}},"interval":5000}
 到 http://127.0.0.1:8000 失败: Post "http://127.0.0.1:8000": dial tcp 127.0.0.1:8000: connect: connection refused 停止上报：已达重试上限 
 ```
 docker日志也提示
 
```
Exception: We're unable to communicate with CoolQ Client.
Please check the connection and credentials provided.
Unable to connect to CoolQ Client!Error Message:
HTTP request failed
During handling of the above exception, another exception occurred:
```
可能是机器性能不够启动太慢，进入ssh，输入下列代码。

```
docker exec -it efb-qq-go-cqhttp ash
cd /root/go-cqhttp
ehforwarderbot
```
如果提示正常识别，且配置的telegram机器人能正常收到QQ信息，那么尝试进入docker修改``start.sh``文件。

我使用winscp在如下图位置找到了相关文件修改。不知道是哪个docker文件夹可以通过创建时间的新旧判断，两个名字相似的文件夹均进行了修改。

![Snipaste_2022-09-27_17-38-49](https://user-images.githubusercontent.com/50565072/192492755-5d2e5d46-8108-4618-a1a7-16215e7051da.png)

![Snipaste_2022-09-27_17-39-42](https://user-images.githubusercontent.com/50565072/192492620-78ff94de-4f23-4ba1-a94e-97cbc1f93ae0.png)

修改后重启docker，发现docker日志已经正常，不再需要手动启动efb。

![Snipaste_2022-09-27_17-43-38](https://user-images.githubusercontent.com/50565072/192493033-936f6d92-c79a-45a4-9a30-44843b40e8e2.png)

# 五、登录后玩法
## 1.分组
登录后机器人会开始帮你接收信息，然而不管是群组还是私聊，都会推送信息到这一个机器人，信息非常繁杂，不利于辨认，所以很有必要进行分组。
###### （1）创建群组

![image](https://user-images.githubusercontent.com/50565072/177025778-080408a1-2922-46d6-9923-e4b0159c4a83.png)


群组名字设置：如果是单个私聊或者单个群聊，随便设置一个名字，之后可以通过机器人命令同步信息，不用自己挨个设置。如果是想归类，一个群组关联很多聊天对话，就按需设置。例如：“游戏”、“同事”。

记得每个群组都必须把自己创建的机器人拉进群。

###### （2）进行筛选分组
在机器人对话界面操作：
可以针对已经给你发送信息的账户，直接左滑回复，输入/link，发送，选择link，然后选择你创建好的群组即可。
一个群组可以link多个QQ账户，达到分组功能。

![image](https://user-images.githubusercontent.com/50565072/177025791-6439baa6-4e5f-4b00-afb4-97b9b30ed5cf.png)


###### （3）更新群组信息
当你的群组只绑定了一个QQ私聊或者群组时，可以在群组中输入/update_info，即可自动同步QQ头像、昵称、群组成员（在简介中）。这项功能需要给机器人管理员权限。
## 2.中间件设置
本文只举例一个中间件，其余的还请自己查阅官方链接。不少中间件只是适用于微信，不适用于QQ。不需要启动的中间件直接在最前面加上#注释掉即可。
###### xzsk2.filter：信息过滤

[efb-filter-middleware中间件](https://github.com/xzsk2/efb-filter-middleware)

新建一个文件config.yaml，位置在``/docker/efb-qq-go-cqhttp/profiles/default/xzsk2.filter``。没有的文件夹自己创建。

```
version: 3.46   #随便写
match_mode: fuzz  
#fuzz是关键字命中即可匹配；exact是需要完整词组精确匹配
work_mode:
        - black_persons   #黑名单好友，过滤他的信息。如果你不想漏收私聊信息，也一定要启用这个。
        - white_groups    #白名单群组，仅接受列表内群组的信息
#white_persons:
#        - libai
white_groups:
        - 1234
        - "*"
        #特殊字符需要打引号
black_persons:   #如果你不想漏收私聊信息，也一定要启用这个。
        - nopppppppp   #如果没有想过滤的人，就填一个好友里面没有的名字吧
#black_groups:
#        - testsyou
```
在/docker/efb-qq-go-cqhttp/profiles/default/config.yaml中添加下列代码，保存并重启docker，日志如无报错正常识别运行中间件则成功。
```
- xzsk2.filter   
```
![image](https://user-images.githubusercontent.com/50565072/177003098-3154b5d0-4b7f-4824-92b5-b55ab293c1d6.png)


该docker已经内置此中间件，无需安装。
如没有安装则在容器内运行下列代码。
```
apk update
apk add git
pip3 install git+https://github.com/xzsk2/efb-filter-middleware
```
