//
//  MCAppDelegate.m
//  MCOEM
//
//  Created by wza on 2020/6/29.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCAppDelegate.h"

#import "MCApp.h"
#import <JAnalytics/JANALYTICSService.h>
#import <JShare/JSHAREService.h>
#import "Application_TimeOut.h"
#import <MeiQiaSDK/MeiQiaSDK.h>

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>

#import "WMDragView.h"
#import "MCNewsModel.h"
#import "KDCommonAlert.h"

@interface MCAppDelegate ()<JPUSHRegisterDelegate>

/// 返回h5悬浮按钮
@property(nonatomic, strong) WMDragView *backToH5;

@end

@implementation MCAppDelegate
- (void)setupApp {
    // 子类重写，在此进行app配置
    
}

- (void)ShowBackToH5 {
    
    WMDragView * backToH5 = [[WMDragView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 74 - 13.5, SCREEN_HEIGHT - TabBarHeight - 10 - 74, 74, 74)];
    backToH5.imageView.image = [UIImage mc_imageNamed:@"suspendimg"];
    backToH5.isKeepBounds = YES;
    backToH5.backgroundColor = UIColor.clearColor;
    __weak __typeof(self)weakSelf = self;
    [self.window addSubview:backToH5];
    backToH5.clickDragViewBlock = ^(WMDragView *dragView) {
        //点击返回H5
        [MCSessionManager.shareManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:@{@"brandId":SharedConfig.brand_id,@"size":@"999",@"classifiCation":@"功能跳转"} ok:^(MCNetResponse * _Nonnull resp) {
                NSArray *array = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
                for (MCNewsModel *model in array) {
                    if ([model.title isEqualToString:@"商城"] || [model.title isEqualToString:@"自营商城"]) {
                        NSMutableString *ms = [NSMutableString stringWithFormat:@"%@",model.content];
                        [ms appendFormat:
                         @"?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@",
                         SharedUserInfo.phone,TOKEN,SharedConfig.brand_id,SharedUserInfo.userid,BCFI.pureHost];
                        MCBaseViewController *webVC = [MGJRouter objectForURL:rt_web_controller withUserInfo:@{@"title":model.title, @"url":ms}];
                        if ([BCFI.native_limit isEqualToString:@"native"]) {
                            MCNavigationController *navVC = [[MCNavigationController alloc] initWithRootViewController:webVC];
                            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
                        } else {
                            [UIApplication sharedApplication].keyWindow.rootViewController = webVC;
                        }
                        return;
                    }
                }
            //没找到
            [MCToast showMessage:@"暂未开通"];
        }];
    };
    
    self.backToH5 = backToH5;
}
- (void)hideBackToH5 {
    [self.backToH5 removeFromSuperview];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupApp];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    
    [MCApp setup:application options:launchOptions appDelegate:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnd) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //监听 rootViewController 变化，如果是 MCTabBarViewController 则展示悬浮按钮
    [self.window addObserver:self forKeyPath:@"rootViewController" options:NSKeyValueObservingOptionNew context:nil];
    
    //角标变成0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    

    // @"恭喜您已实名完成,接下来将指引您完成信用卡认证,认证完成可获得奖励";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTSHIMING"];
    return YES;
}

/// 进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [MQManager openMeiqiaService];
    
//    if (!MCModelStore.shared.updateViewIsShow) {
//        MCModelStore.shared.updateViewIsShow = YES;
//        [MCVerifyStore verifyVersionShowToast:NO];
//    }
}
/// 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [MQManager closeMeiqiaService];
}
/// 注册设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    MCLog(@"deviceToken:%@",deviceToken);
    [MQManager registerDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //极光
    [JANALYTICSService handleUrl:url];
    [JSHAREService handleOpenUrl:url];
    
    
    return YES;
}
#pragma mark - Notification
/// 长时间未操作
- (void)applicationDidTimeout:(NSDictionary *)info {
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"由于您长时间未操作，请重新登录"  isShowClose:YES];
    commonAlert.middleActionBlock = ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
    };
    
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"由于您长时间未操作，请重新登录" preferredStyle:QMUIAlertControllerStyleAlert];
//    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
//    }];
//    [alert addAction:action];
//    [alert showWithAnimated:YES];
}
/// app退出（包括主动退出和crash）
- (void)applicationEnd {
    if ([api_host containsString:@"://test"]) {
//        api_host = @"";
    }
    MCLog(@"remove test host");
}


#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      //从通知界面直接进入应用
    }else{
      //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    //MCLog(@"%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
    }
    [self mc_handleRemoteNotification:userInfo withCompletionHandler:completionHandler];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


/// 系统相关
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark - 处理推送信息
- (void)mc_handleRemoteNotification:(NSDictionary *)userInfo withCompletionHandler:(void (^)(NSInteger))completionHandler{
//    NSDictionary *aps = [(NSDictionary *)userInfo objectForKey:@"aps"];
//    if (aps) {
//        id alert = [aps objectForKey:@"alert"];
//        if ([alert isKindOfClass:NSString.class]) {
//            NSString *isPush = [NSString stringWithFormat:@"%@",userInfo[@"isPush"]];
//            NSString *msg = (NSString *)alert;
//            if ([isPush isEqualToString:@"0"]) {    //alert弹窗，只出声，不要系统的顶部的横幅
//                NSString *pushTitle = @"推送消息";
//                [MCAlertStore showWithTittle:pushTitle message:msg buttonTitles:@[@"好的"] sureBlock:^{
//                }];
////                [self mc_syntheticVoice:msg];
//                return completionHandler(UNNotificationPresentationOptionSound);
//            }
//        }
//        if ([alert isKindOfClass:NSDictionary.class]) {
//            if ([[alert objectForKey:@"body"] isKindOfClass:NSString.class]) {
//                NSString *pushTitle = @"推送消息";
//                NSString *msg = alert[@"body"];
//                [MCAlertStore showWithTittle:pushTitle message:msg buttonTitles:@[@"好的"] sureBlock:^{
//                }];
////                [self mc_syntheticVoice:msg];
//                return completionHandler(UNNotificationPresentationOptionSound);
//            }
//        }
//    }
//    // 角标置为0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//
//    return completionHandler(UNNotificationPresentationOptionAlert);    //其余情况就弹出横幅拉
}
- (void)mc_syntheticVoice:(NSString *)string {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    //创建一个会话
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
    //选择语言发音的类别，如果有中文，一定要选择中文，要不然无法播放语音
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //播放语言的速率，值越大，播放速率越快
    utterance.rate = 0.4f;
    //音调  --  为语句指定pitchMultiplier ，可以在播放特定语句时改变声音的音调、pitchMultiplier的允许值一般介于0.5(低音调)和2.0(高音调)之间
    utterance.pitchMultiplier = 1.3f;
    //让语音合成器在播放下一句之前有短暂时间的暂停，也可以类似的设置preUtteranceDelay
    utterance.postUtteranceDelay = 0.1f;
    //播放语言
    [synthesizer speakUtterance:utterance];
}
#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rootViewController"]) {
        MCLog(@"change:%@", change);
        id obj = [change objectForKey:NSKeyValueChangeNewKey];
        if ([obj isKindOfClass:[MCTabBarViewController class]]) {  //原生
            if (BCFI.block_login) { //目前展示的是原生且配置了该功能，展示悬浮按钮
                [self ShowBackToH5];
                return;
            }
        }
        [self hideBackToH5];
    }
}

- (void)backAction {
    //进原生页面
    SharedDefaults.not_auto_logonin = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
}
@end
