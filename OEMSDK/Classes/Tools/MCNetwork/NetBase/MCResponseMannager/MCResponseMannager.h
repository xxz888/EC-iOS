//
//  MCResponseMannager.h
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/18.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MCNetResponse : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *messege;
@property (nonatomic, copy) NSString *whether;
@property (nonatomic, strong) NSString *sumAmount;
#pragma mark - 加密模式下的数据
/** AccessToken */
@property(nonatomic,readwrite,copy)  NSString *accessToken;
/** 安全模式 */
@property(nonatomic,readwrite,copy)  NSString *requestType;
/** 后台公钥 */
@property(nonatomic,readwrite,copy)  NSString *publicKey;


@property (nonatomic, strong) id repaymentCount;
@property (nonatomic, strong) id amount;
@property (nonatomic, strong) id allServiceCharge;




@end


@interface MCResponseMannager : NSObject
///**
// * 该类主要用于处理网络请求返回的数据,对客户端加密后的数据解密,处理返回的错误状态码.
// */
//+ (instancetype)shared;
//
///**
// * 处理网络返回成功的数据.
// */
//- (id) mc_handleSuccessDataWithResopnse:(id)response
//                                     ok:(nullable void (^)(MCNetResponse*okResponse))okResp
//                                  other:(nullable void (^)(MCNetResponse*otherResponse))otherResp;
//
///**
// * 处理网络返回失败的数据.
// */
//- (void) mc_handleErrorDataWithError:(id)error
//                             failure:(nullable void (^)(NSError *error))failure;
//
//
///**
//* 处理网络返回加密后的数据.
//*/
//- (id)mc_handleSafeData:(id)response;

@end

NS_ASSUME_NONNULL_END
