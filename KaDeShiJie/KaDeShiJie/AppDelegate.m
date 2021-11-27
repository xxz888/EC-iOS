//
//  AppDelegate.m
//  MCExample
//
//  Created by wza on 2020/7/2.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "AppDelegate.h"
#import <OEMSDK/MCModuleListController.h>
#import <OEMSDK/MCShareOverViewController.h>
#import "KDHomeViewController.h"
#import "KDNewsViewController.h"
#import "KDShareViewController.h"
#import "KDMineViewController.h"
#import "KDLoginViewController.h"
#import "LCServiceController.h"
#import "KDSlotCardOrderInfoViewController.h"
#import "KDWithDrawHistoryViewController.h"
#import "KDShareSingleVC.h"
#import "KDSlotCardHistoryModel.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "KDWelcomeAlertView.h"
#import "KDWebContainer.h"
#import "KDCommonAlert.h"

@interface AppDelegate ()

@property(nonatomic, strong) KDWelcomeAlertView *alertContent;
@property(nonatomic, strong) QMUIModalPresentationViewController *activityModal;
@property(nonatomic, strong) NSDictionary *extras;

@end

@implementation AppDelegate
- (KDWelcomeAlertView *)alertContent {
    if (!_alertContent) {
        _alertContent = [KDWelcomeAlertView alertView];
        [_alertContent.btn addTarget:self action:@selector(alertContentTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertContent;
}
- (QMUIModalPresentationViewController *)activityModal {
    if (!_activityModal) {
        _activityModal = [[QMUIModalPresentationViewController alloc] init];
        _activityModal.contentView = self.alertContent;
    }
    return _activityModal;
}
 
- (void)setupApp {
    MCLog(@"配置app基本信息");
    SharedDefaults.host = @"https://api.flyaworld.com";

    //正式环境域名
//    SharedDefaults.host = @"https://api.flyaworld.com";
    //正式环境IP
//      SharedDefaults.host = @"http://139.196.145.125";
    //金地址
//    SharedDefaults.host = @"http://192 .168.10.32";
    //陶地址
//    SharedDefaults.host = @"http://192.168.10.29";
    //测试环境
//    SharedDefaults.host = @"http://test1012.caderworld.com";
    SharedDefaults.deviceid = [UIDevice identifierByKeychain];
    /* Require，必填 */
    BCFI.brand_id = @"100";
    BCFI.key_jpush = @"ca5246c0e40eaf60a38794cd";
    BCFI.key_meiqia = @"1c392b4bf42c4c4988792714636ad6f5";
    BCFI.key_dns = @"41611";
    BCFI.color_main = [UIColor qmui_colorWithHexString:@"#7198ff"];//7198ff
    BCFI.image_logo = [UIImage imageNamed:@"logo"];
    BCFI.image_login_logo = [UIImage imageNamed:@"login_logo"];

    BCFI.tab_selected_index = 0;
    BCFI.is_guide_page = NO;
    BCFI.is_share_conin = YES;
    BCFI.safe_title = @"设置交易密码";
    [BCFI registerURLPattern:rt_share_single toObjectHandler:^id(NSDictionary *routerParameters) {
        return [KDShareSingleVC new];
    }];
    
    [BCFI registerURLPattern:rt_user_signupin toObjectHandler:^id(NSDictionary *routerParameters) {
        MCNavigationController *navVC = [[MCNavigationController alloc] initWithRootViewController:[KDLoginViewController new]];
        return navVC;
    }];
    
    [BCFI registerURLPattern:rt_card_shoukuanxiangqing toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        KDSlotCardOrderInfoViewController * vc = [[KDSlotCardOrderInfoViewController alloc] initWithClassification:info[@"param"]];
        return vc;
    }];
    
    [BCFI registerURLPattern:rt_card_jiaoyijilu toObjectHandler:^id(NSDictionary *routerParameters) {
        KDWithDrawHistoryViewController *vc = [[KDWithDrawHistoryViewController alloc] init];
        vc.titleString = @"提现记录";
        vc.queryType = @"8";
        return vc;
    }];
    
    
    
    NSArray *items = @[
        @{@"title":@"首页",
          @"iconName":@"tab_icon_home",
          @"selectedIconName":@"tab_icon_home_selected",
          @"controller":[KDHomeViewController new]
        },
        @{@"title":@"资讯",
          @"iconName":@"tab_icon_news",
          @"selectedIconName":@"tab_icon_news_selected",
          @"controller":[KDNewsViewController new]
        },
        @{@"title":@"推广",
          @"iconName":@"tab_icon_share",
          @"selectedIconName":@"tab_icon_share_selected",
          @"controller":[KDShareViewController new]
        },
        @{@"title":@"我的",
          @"iconName":@"tab_icon_mine",
          @"selectedIconName":@"tab_icon_mine_selected",
          @"controller":[KDMineViewController new]
        }
    ];

    BCFI.tab_items = [MCTabBarModel mj_objectArrayWithKeyValuesArray:items];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webContainerReset) name:@"mcNotificationWebContainnerReset" object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)webContainerReset {
    [KDWebContainer.shared setupContainer];
}

#pragma mark - 处理推送信息
- (void)mc_handleRemoteNotification:(NSDictionary *)userInfo withCompletionHandler:(void (^)(NSInteger))completionHandler{
    
    if ([MCLATESTCONTROLLER isKindOfClass:NSClassFromString(@"KDLoginViewController")]) {   //登录页面不弹
        return;
    }
    
    NSString *imgUrl = [userInfo objectForKey:@"image"];
    
    if (imgUrl) {
        self.extras = userInfo;
        [self.activityModal showWithAnimated:YES completion:nil];
        [self.alertContent.btn sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
        
        return completionHandler(UNNotificationPresentationOptionSound);
    }
    
    NSDictionary *aps = [(NSDictionary *)userInfo objectForKey:@"aps"];
    if (aps) {
        id alert = [aps objectForKey:@"alert"];
        if ([alert isKindOfClass:NSString.class]) {
            NSString *isPush = [NSString stringWithFormat:@"%@",userInfo[@"isPush"]];
            NSString *msg = (NSString *)alert;
            
            if ([isPush isEqualToString:@"0"]) {    //alert弹窗，只出声，不要系统的顶部的横幅
                NSString *pushTitle = @"推送消息";
                //分润不要弹框，在这里要判断一下
                if ([msg containsString:@"分润"]) {
                    
                }else{
                    __weak __typeof(self)weakSelf = self;
                    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                    [commonAlert initKDCommonAlertContent:msg  isShowClose:YES];
                    
//                    [MCAlertStore showWithTittle:pushTitle message:msg buttonTitles:@[@"好的"] sureBlock:^{}];
                    return completionHandler(UNNotificationPresentationOptionSound);
                }
            } else {
                [self mc_syntheticVoice:msg];
            }
        }
        if ([alert isKindOfClass:NSDictionary.class]) { //
            if ([[alert objectForKey:@"body"] isKindOfClass:NSString.class]) {
                NSString *pushTitle = @"推送消息";
                NSString *msg = alert[@"body"];
                if ([msg containsString:@"分润"]) {
                    
                }else{
                    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                    [commonAlert initKDCommonAlertContent:msg  isShowClose:YES];
//                    [MCAlertStore showWithTittle:pushTitle message:msg buttonTitles:@[@"好的"] sureBlock:^{}];
                    return completionHandler(UNNotificationPresentationOptionSound);
                }
            }
        }
    }
    // 角标置为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return completionHandler(UNNotificationPresentationOptionAlert);    //其余情况就弹出横幅拉
}

- (void)alertContentTouched {
    [self.activityModal hideWithAnimated:NO completion:nil];
    NSString *url = [self.extras objectForKey:@"pushLink"];
    
    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":url}];
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
@end
