# 注意事项
* 拖入Podfile,因为贴牌可能需要引入自己的pod，且开发时只需对自己的贴牌进行pod install,固加入.gitignore自行管理  

# 创建新贴牌步骤：
> 1、新建Project，其中workspace和group都选择MCOEM，MCOEM.workspace中将出现新建的工程  
> 2、改造main.m文件   
> 3、修改AppDelegate 继承自 MCAppDelegate，并去掉遵守的协议  
> 4、重写AppDelegate的setupApp方法， 在此进行app的配置   
> 5、贴牌配置见AppDelegate.m 

# 项目说明
* KaDeShiJie            #示例工程  
* OEMSDK                #o单功能的私有pod，做贴牌时切勿修改该文件夹下所有内容，将会影响到所有项目  
* 替换项目模块可以通过MCBrandConfiguration的注入方法进行覆盖
* 项目依赖见./OEMSDK/OEMSDK.podspec，第三方库在./OEMSDK/Vendor中，第三方依赖的bundle在./OEMSDK/TXAuth中，OEMSDK资源文件./EMSDK/Assets
```
[BCFI registerURLPattern:rt_notice_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCMessageController new];
    }];
```

```
├── Base
│   ├── App #app基础的配置
├       ├── Application_TimeOut.h   #长时间没有交互提醒
├       ├── MCApp.h #封装一些app相关的方法
├       ├── MCAppDelegate.h #作为AppDelegate父类
├       ├── MCBrandConfiguration.h  #贴牌可以设置的属性
├── Component   #常用组件
│   ├── Alert
│   ├── AppUpdate
│   ├── BQLCalendar
│   ├── BigShowImage
│   ├── ChoosePayment
│   ├── LYScrollTextLabel
│   ├── Loading
│   ├── MCBannerView
│   ├── MCEmpty
│   ├── MCGradientView
│   ├── MCRunTextView
│   ├── Models
│   ├── Toast
│   ├── UserHeader
│   └── WaveView
├── Module  #模块，在MCModuleHeader.h中导入，默认的模块见MCBrandConfiguration.m
│   ├── Balance #余额模块
│   ├── Card    #银行卡模块
│   ├── Collection  #收款模块
│   ├── Custom  #一些贴牌定制化的
│   ├── MCModuleListController  #展示所有注册的路由，方便测试
│   ├── News    #咨询
│   ├── Notice  #通知
│   ├── Order   #订单
│   ├── Profit  #收益
│   ├── QRCode  #二维码
│   ├── Rate    #费率
│   ├── Service #客服
│   ├── Setting #设置
│   ├── Share   #分享
│   ├── Team    #团队
│   ├── Update  #升级
│   ├── User    #用户
│   ├── WKWebview   #加载url的控制器
│   ├── operation   #操作教程
│   ├── pengyouquan #朋友圈
│   ├── sharemany   #分享
│   ├── shequ   #社群
│   └── video   #视频教程
├── OEMSDK.h    #头文件，既能对外公开，又能对内起到pch的效果
└── Tools   #常用的一些工具
    ├── Categories
    ├── GVUserDefaults
    ├── ImageTool
    ├── MCDateStore
    ├── MCLocationTools
    ├── MCModelStore    #数据
    ├── MCNetwork   #网络请求
    ├── MCPayStore  
    ├── MCServiceStore
    ├── MCStore
    ├── MCTXManager
    ├── MCVerifyStore
    ├── Router  #路由相关
    ├── STModal
    └── ShareStore
```


 ### 详细说明
  ```
 项目主要采用xib+代码的方式进行编写，使用MVC的设计模式开发。
 ```
 ---
 #### 登陆
 登陆注册一体化，在app进入到登陆页面的时候，如果app是第一次登陆，用户需要进行登陆，在登陆之后，判断用户的实名状态。如果用户还没有实名，需要用户去实名。如果已经实名，保存用户信息，注册极光推送，然后进入到首页
