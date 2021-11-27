//
//  MCVerifyStore.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCVerifyStore.h"
#import "MCUpdateAlertView.h"
#import "KDCommonAlert.h"
@implementation MCVerifyStore

+ (void)verifyRealName:(void (^)(MCUserInfo * _Nonnull))handler {
    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        
        if (userInfo.isRealName) {
            if (handler) {
                handler(userInfo);
            } else {
                [MCToast showMessage:@"您已实名"];
            }
        } else if ([userInfo.realnameStatus isEqualToString:@"0"]) {
            [MCToast showMessage:@"实名认证中"];
        } else {
            if (handler) {
                
                
                kWeakSelf(self);
                KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                [commonAlert initKDCommonAlertContent:@"您还未实名审核，请先实名审核！"  isShowClose:NO];
                commonAlert.rightActionBlock = ^{
                    [MCLATESTCONTROLLER.navigationController pushViewController:[MCRealNameViewController new] animated:YES];
                };
                
//                [MCAlertStore showWithTittle:@"温馨提示" message:@"您还未实名审核，请先实名审核！" buttonTitles:@[@"取消", @"确定"] sureBlock:^{
//                    [MCLATESTCONTROLLER.navigationController pushViewController:[MCRealNameViewController new] animated:YES];
//                } cancelBlock:^{
//
//                }];
            } else {
                [MCLATESTCONTROLLER.navigationController pushViewController:[MCRealNameViewController new] animated:YES];
            }
        }
    }];
}

+ (void)verifyVersionShowToast:(BOOL)show {
    
    [MCModelStore.shared reloadBrandInfo:^(MCBrandInfo * _Nonnull brandInfo) {
        NSString *remoteVersion = brandInfo.iosVersion;
        NSString *localVersion = SharedAppInfo.version;
        NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
        if (result == NSOrderedDescending) {
            MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
            NSString * str = [brandInfo.iosContent stringByReplacingOccurrencesOfString:@"，" withString:@"\n"];
            [updateView showWithVersion:remoteVersion content:str downloadUrl:brandInfo.iosDownload isForce:YES];
        } else {
            if (show) {
                [MCToast showMessage:@"当前已是最新版本"];
            }
        }
    }];
}

+ (NSString *)verifyURL:(NSString *)url {
    
    BeginIgnoreClangWarning(-Wdeprecated-declarations)
    NSString *encodedUrlPath = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    EndIgnoreClangWarning
    
    return encodedUrlPath;
}
@end
