//
//  MCApp.m
//  MCOEM
//
//  Created by wza on 2020/3/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCApp.h"

#import "MCGuidViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <JPush/JPUSHService.h>

#import <JShare/JSHAREService.h>
#import <MeiQiaSDK/MeiQiaSDK.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "MCAppDelegate.h"
#import <pdns-sdk-ios/DNSResolver.h>
@implementation MCApp

+ (void)setup:(UIApplication *)application options:(NSDictionary *)launchOptions appDelegate:(MCAppDelegate*)appDelegate {
    [self setAlertControllerAppearance];
    [self setMoreOperationAppearance];
    [self observeNetwork];
    [self registPlatforms:application options:launchOptions appDelegate:appDelegate];
//    [MCModelStore.shared getInfos];
    
    if (MCModelStore.shared.userDefaults.not_first_launch || !MCModelStore.shared.brandConfiguration.is_guide_page) {
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
        
    } else {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MCGuidViewController alloc] init];
    }
    
}


+ (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (void)observeNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (MCModelStore.shared.userDefaults.not_first_launch &&
            status == AFNetworkReachabilityStatusNotReachable) {
            [MCToast showMessage:@"网络已经断开，请检查后重试"];
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) { //有网了，加载最近的网络请求
            
            [MCLATESTCONTROLLER.sessionManager mc_reloadTasks];
            
        }
    }];
    [manager startMonitoring];
}

// 注册第三方平台
+ (void)registPlatforms:(UIApplication *)application options:(NSDictionary *)launchOptions appDelegate:(MCAppDelegate *)appDelegate{
    [self registJiguang:application options:launchOptions appDelegate:appDelegate];
    [self registMeiqia:application appDelegate:appDelegate];
    [self registUMShare:application appDelegate:appDelegate];
    //如果是测试环境，就不解析dns
    if ([SharedDefaults.host containsString:@"test1012"] || [SharedDefaults.host containsString:@"32"] || [SharedDefaults.host containsString:@"29"]) {
        
    }else{
        [self registDns:application options:launchOptions appDelegate:appDelegate];
    }

}
+(void)registDns:(UIApplication *)application options:(NSDictionary *)launchOptions appDelegate:(MCAppDelegate *)appDelegate{

    DNSResolver *resolver = [DNSResolver share];//DNSResolver初始化
    resolver.accountId = SharedConfig.key_dns;//替换为您在控制台注册应用时分配的Account ID
    resolver.scheme = DNSResolverSchemeHttp;//设置访问DNS服务器时使用http协议
    resolver.cacheEnable = YES;//设置开启缓存，使用预加载方法前请开启该功能
    resolver.speedTestEnable = YES;//设置开启对缓存数据的ip测速
    resolver.timeout = 3;//设置解析超时时间，建议2~5s，默认3s
    resolver.cacheCountLimit = 100;//设置域名解析缓存最大数量，默认为100个域名
    resolver.ipv6Enable = NO;//设置是否使用IPv6网络解析域名，默认为NO（确认当前网络是IPv6时开启）
    //预加载
    NSString *domain = [SharedDefaults.host replaceAll:@"https://" target:@""];;

    [resolver preloadIpv4Domains:@[domain] complete:^{
        NSArray *array = [resolver getIpv4ByCacheWithDomain:domain];
        if (array.count > 0) {
            SharedDefaults.host = [NSString stringWithFormat:@"https://%@", array[0]];
        }

    }];
}
+ (void)registJiguang:(UIApplication *)application options:(NSDictionary *)launchOptions appDelegate:(MCAppDelegate *)appDelegate{
    NSString *channel = [NSString stringWithFormat:@"%@_%@",SharedConfig.brand_name,SharedConfig.brand_id];
    NSString *appKey = MCModelStore.shared.brandConfiguration.key_jpush;
    //推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:appDelegate];
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    [JPUSHService setLogOFF];
    //统计
    JANALYTICSLaunchConfig * analConfig = [[JANALYTICSLaunchConfig alloc] init];
    analConfig.appKey = appKey;
    analConfig.channel = channel;
    [JANALYTICSService setupWithConfig:analConfig];
    //分享
    JSHARELaunchConfig *shareConfig = [[JSHARELaunchConfig alloc] init];
    shareConfig.appKey = appKey;
    [JSHAREService setupWithConfig:shareConfig];
}
+ (void)registMeiqia:(UIApplication *)application appDelegate:(MCAppDelegate *)appDelegate{
    if (SharedConfig.key_meiqia) {
        [MQManager initWithAppkey:MCModelStore.shared.brandConfiguration.key_meiqia completion:^(NSString *clientId, NSError *error) {
            if (!error) {
                MCLog(@"美洽 SDK：初始化成功");
            } else {
                MCLog(@"error:%@",error);
            }
        }];
    } else {
        MCLog(@"没有配置美洽key");
    }
    
}
+ (void)registUMShare:(UIApplication *)application appDelegate:(MCAppDelegate *)appDelegate{
    if (SharedConfig.key_umshare.length ) {}
    [UMConfigure initWithAppkey:@"5d25bfad3fc195a62f000f22" channel:@"ad-hoc"];
    
}

#pragma mark - 设置 QMUIAlertController 统一样式，在此修改
+ (void)setAlertControllerAppearance {
    
}
#pragma mark - 设置 QMUIMoreOperationController 统一样式，在此修改
+ (void)setMoreOperationAppearance {
    QMUIMoreOperationController.appearance.contentBackgroundColor = UIColorMake(250, 250, 250);
    QMUIMoreOperationController.appearance.cancelButtonSeparatorColor = UIColorMake(100, 100, 100);
    QMUIMoreOperationController.appearance.cancelButtonBackgroundColor = UIColorMake(250, 250, 250);
    QMUIMoreOperationController.appearance.cancelButtonTitleColor = UIColorMake(34, 34, 34);
    QMUIMoreOperationController.appearance.itemTitleColor = UIColorMake(34, 34, 34);
    QMUIMoreOperationController.appearance.automaticallyAdjustItemMargins = 0;
}
#pragma mark - 极光相关
+ (void)setJPushAlias:(NSString *)alias {
    [JPUSHService setAlias:[NSString stringWithFormat:@"%@",alias] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        MCLog(@"iResCode:%ld\niAlias:%@\nseq:%ld", iResCode,iAlias,seq);
    } seq:0];
}
+ (void)deleteJPushAlias {
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        MCLog(@"iResCode:%ld\niAlias:%@\nseq:%ld", iResCode,iAlias,seq);
    } seq:0];
}
+ (void)setJAnalyticsIdentifyAccount:(MCUserInfo *)userInfo {
    
    JANALYTICSUserInfo * jInfo = [[JANALYTICSUserInfo alloc] init];
    jInfo.accountID = [NSString stringWithFormat:@"%@",userInfo.userid];
    jInfo.name = userInfo.nickname ?: SharedConfig.brand_name;
    jInfo.phone = userInfo.phone;
    jInfo.creationTime = userInfo.createTime.longLongValue/1000;
    
    if (userInfo.idcard) {
        jInfo.birthdate = [self subsIDStrToDate:userInfo.idcard];
        jInfo.sex = ([[self getIdentityCardSex:[NSString stringWithFormat:@"%@",userInfo.idcard]] isEqualToString:@"1"] ? JANALYTICSSexMale : JANALYTICSSexFemale);
    } else {
        jInfo.sex = JANALYTICSSexUnknown;
    }
    [JANALYTICSService setDebug:NO];
    [JANALYTICSService identifyAccount:jInfo with:^(NSInteger err, NSString *msg) {
        if (err) {
          MCLog(@"identify ERR:%ld|%@", err, msg);
        }else {
          MCLog(@"identify success");
        }
    }];
}
+ (void)detachJAnalyticsAccount {
    [JANALYTICSService detachAccount:^(NSInteger err, NSString *msg) {
        if (err) {
          MCLog(@"detach ERR:%ld|%@", err, msg);
        }else {
          MCLog(@"detach success");
        }
    }];
}

//截取身份证的出生日期并转换为日期格式
+ (NSString *)subsIDStrToDate:(NSString *)str{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *dateStr = [str substringWithRange:NSMakeRange(6, 8)];
    NSString  *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString  *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString  *day = [dateStr substringWithRange:NSMakeRange(6,2)];
    
    [result appendString:year];
    [result appendString:@""];
    [result appendString:month];
    [result appendString:@""];
    [result appendString:day];
    
    return result;
}
//根据身份证号性别
+ (NSString *)getIdentityCardSex:(NSString *)numberStr {
    int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
    if(sexInt%2!=0) {
        return @"1";    //男
    }
    else {
        return @"2";    //女
    }
}

+ (void)userLogout {
    TOKEN = nil;
    SharedUserInfo = [[MCUserInfo alloc] init];
    SharedDefaults.not_auto_logonin = NO;
    if (!SharedDefaults.not_rember_pwd) {
        SharedDefaults.pwd = @"";
    }
    [self deleteJPushAlias];
    [self detachJAnalyticsAccount];
    
    MCLog(@"logIn: %@",[MGJRouter objectForURL:rt_user_signupin]);
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
    
    
    MCAppDelegate *appdelegate = (MCAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.window.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
}

@end
