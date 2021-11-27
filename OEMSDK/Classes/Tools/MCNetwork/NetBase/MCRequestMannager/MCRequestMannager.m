//
//  MCRequestMannager.m
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/20.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCRequestMannager.h"

#import "MCSessionManager.h"
@interface MCRequestMannager ()
/** 当前请求的接口 */
@property(nonatomic,readwrite,copy)  NSString *url;
@end

@implementation MCRequestMannager
/**
 * 该类主要用于处理网络请求,对客户端请求前参数处理,部分业务处理.
 */
//+ (instancetype)shared{
//    static MCRequestMannager *shared;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shared = [[MCRequestMannager alloc] init];
//    });
//    return shared;
//}

/**
 * 对请求的url进行处理.`
 */
//- (NSString*)filterWithUrl:(NSString*)url{
//    self.url = url;
//    if ([url containsString:kHostPollingServiceAddress] || [url containsString:kAccessTokenUrl]){
//        NSString * host = MCModelStore.shared.appInfo.base_url;
//        if (![host hasSuffix:@"/"]) {
//               host = [NSString stringWithFormat:@"%@/",host];
//        }
//        return [NSString stringWithFormat:@"%@%@%@",host,MCModelStore.shared.appInfo.service_version,url];
//    }else{
//        NSString * host = MCModelStore.shared.appInfo.host_address;
//        if (![host hasSuffix:@"/"]) {
//               host = [NSString stringWithFormat:@"%@/",host];
//        }
//        host= [NSString stringWithFormat:@"%@%@%@",host,MCModelStore.shared.appInfo.service_version,url];
//        return host;
//    }
//}

/**
 * 对请求的参数进行处理.
 */
//- (NSDictionary*)filterWithParamters:(NSDictionary*)paramters{
//    NSLog(@"是加密:%d",GVUserDefaults.standardUserDefaults.mc_isEncryption);
//    if (GVUserDefaults.standardUserDefaults.mc_isEncryption) {
//        //请求参数加密处理
//        MCLog(@"当前url:%@",self.url);
//        if (![MCSafeHelpr.shared mc_filterAuthTokenWithUrl:self.url]) {
//            paramters = [MCSafeHelpr.shared mc_signMD5WithParameters:paramters];
//            //添加AccessToken到请求头
//            [[MCSessionManager shareManager].requestSerializer setValue:GVUserDefaults.standardUserDefaults.mc_accessToken forHTTPHeaderField:@"accessToken"];
//            [[MCSessionManager manager].requestSerializer setValue:GVUserDefaults.standardUserDefaults.mc_accessToken forHTTPHeaderField:@"accessToken"];
//        }
//    }
//    return paramters;
//}

@end
