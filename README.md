# efb-qq-docker
与efb-wechat类似
但是需要注意的是：
1.非常建议挂载/mcl文件夹。因为这里保存的是mcl文件和🐧端的登录信息，如果docker image更新，且你不是挂载的这个文件夹。那么你将丢失你的登录信息，再次登录则需要重新验证。
2.第一次使用的时候需要进入docker里，手动进入~/mcl并运行./mcl -u 之后按照Mirai说明进行操作，以此登录🐧。
3.如果需要自动登陆的，可以在./mcl后，用/autoLogin add <qq号> <qq密码> ，然后再使用/autoLogin setConfig <qq号> protocol <ANDROID_PHONE, ANDROID_PAD, ANDROID_WATCH 三选一>，以此设置自动登录。
