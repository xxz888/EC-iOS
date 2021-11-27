//
//  MCResponseMannager.m
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/18.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCResponseMannager.h"


@implementation MCNetResponse


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"code":@"resp_code",
        @"messege":@"resp_message",
        @"result":@"result",
        @"accessToken" : @"result",//前边的是你想用的key，后边的是返回的key
    };
}

@end

@interface MCResponseMannager ()

@end

@implementation MCResponseMannager
//+ (instancetype)shared{
//    static MCResponseMannager *shared;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shared = [[MCResponseMannager alloc] init];
//    });
//    return shared;
//}
//
///**
// * 处理网络返回数据.
// */
//- (id) mc_handleSuccessDataWithResopnse:(id)response
//                                     ok:(nullable void (^)(MCNetResponse*okResponse))okResp
//                                  other:(nullable void (^)(MCNetResponse*otherResponse))otherResp{
//
//    id resultData = response[@"data"];
//    if (resultData) { //加密数据存在
//        MCLog(@"加密数据%@",resultData);
//        response = [self mc_handleSafeData:response];
//    }
//    MCNetResponse *resp = [MCNetResponse mj_objectWithKeyValues:response];
//    if ([resp.code isEqualToString:@"000000"]) {  // ok
//        if (okResp) {
//            okResp(resp);
//        }
//    } else {    // other
//        if (otherResp) {
//            otherResp(resp);
//        } else {
//            //Messege提示
//            MCLog(@"默认弹出提示");
//        }
//    }
//    return response;
//}
//
//
///**
// * 处理网络返回失败的数据.
// */
//- (void) mc_handleErrorDataWithError:(id)error
//                             failure:(nullable void (^)(NSError *error))failure{
//    if (failure) {
//        failure(error);
//    } else {
//        // 默认的错误处理
//        MCLog(@"默认处理网络错误");
//    }
//}
//
///**
//* 处理网络返回加密后的数据.
//*/
//- (id)mc_handleSafeData:(id)response{
//    NSString* data =  [[RSAHandler decryptString:response[@"data"] privateKey:[MCSafeHelpr shared].privateKey] stringByRemovingPercentEncoding];
//    id object =  [data mj_JSONObject];
//    return object;
//}

@end
