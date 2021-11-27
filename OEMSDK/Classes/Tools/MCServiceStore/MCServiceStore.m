//
//  MCServiceStore.m
//  MCOEM
//
//  Created by wza on 2020/4/2.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCServiceStore.h"
//#import <MeiQiaSDK/MQChatViewController.h>
#import "MQChatViewController.h"
#import "MQChatViewManager.h"
#import "MCServiceAlert.h"
#import "KDCommonAlert.h"

@implementation MCServiceStore

+ (void)callBrand {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedBrandInfo.brandPhone]]];
}
+ (void)jumpWeixin {
    UIPasteboard.generalPasteboard.string = SharedBrandInfo.brandWeiXin;
    
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"微信号复制成功"  isShowClose:YES];

//    [commonAlert initKDCommonAlertTitle:@"" content:@"微信号复制成功" leftBtnTitle:@"取消" rightBtnTitle:@"打开微信" ];
    commonAlert.rightActionBlock = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
    };
    
    
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"微信号复制成功" preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"打开微信" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
//    }]];
//    [alert showWithAnimated:YES];
}
+ (void)jumpQQ {
    UIPasteboard.generalPasteboard.string = SharedBrandInfo.brandQQ;
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"QQ号复制成功"  isShowClose:YES];

//    [commonAlert initKDCommonAlertTitle:@"" content:@"QQ号复制成功" leftBtnTitle:@"取消" rightBtnTitle:@"打开QQ" ];
    commonAlert.rightActionBlock = ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", SharedBrandInfo.brandQQ]];
        [[UIApplication sharedApplication] openURL:url];
    };
    
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"QQ号复制成功" preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"打开QQ" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", SharedBrandInfo.brandQQ]];
//        [[UIApplication sharedApplication] openURL:url];
//    }]];
//    [alert showWithAnimated:YES];
}

+ (void)pushMeiqiaVC {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];

    
    
    if (TOKEN) {
        [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
            NSString * name = userInfo.realname;
            NSString * phone = userInfo.phone;
            NSString * avatar = SharedUserInfo.headImvUrl?:@"";
            [chatViewManager setClientInfo:@{@"name":name,@"tel":phone,@"avatar":avatar}];
            [chatViewManager enableRoundAvatar:YES];
            [chatViewManager setAgentName:SharedConfig.brand_name];
            [chatViewManager setoutgoingDefaultAvatarImage:SharedAppInfo.icon];
            [chatViewManager pushMQChatViewControllerInViewController:MCLATESTCONTROLLER];
        }];
    }else{
        NSString * name = @"未登录用户";
        NSString * phone = @"11111111111";
        NSString * avatar = @"";
        [chatViewManager setClientInfo:@{@"name":name,@"tel":phone,@"avatar":avatar}];
        [chatViewManager enableRoundAvatar:YES];
        [chatViewManager setAgentName:SharedConfig.brand_name];
        [chatViewManager setoutgoingDefaultAvatarImage:SharedAppInfo.icon];
        [chatViewManager pushMQChatViewControllerInViewController:MCLATESTCONTROLLER];
    }
}
+ (void)popServiceSheet {
    [self popServiceSheetTypes:@[@(0),@(1),@(2),@(3)]];
}
+ (void)popServiceSheetTypes:(NSArray *)type {
    [MCServiceAlert showWithTypes:type];
}

+ (void)call:(NSString *)phone {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

+ (UIView *)titleView {
    UIView *v = [[UIView alloc] init];
    QMUILabel *lab = [[QMUILabel alloc] init];
    lab.text = @"在线客服";
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [v addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return v;
}

@end
