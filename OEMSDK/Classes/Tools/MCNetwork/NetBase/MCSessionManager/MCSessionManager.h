//
//  MCSessionManager.h
//  MCOEM
//
//  Created by wza on 2020/3/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MCResponseMannager.h"
NS_ASSUME_NONNULL_BEGIN

//  NSURLSessionDelegate代理方法
@protocol MCSessionManagerDelegate <NSObject>

- (void)mc_session:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveResponse:(nullable id)response;

@end

typedef void (^MCSMNormalHandler) (MCNetResponse *resp);
typedef void (^MCSMErrorHandler) (NSError *error);

@interface MCSessionManager : AFHTTPSessionManager

@property (nonatomic, weak) id <MCSessionManagerDelegate> delegate;



/// 全局的SessionManager，如果希望网络任务请求结束后tableview停止刷新，请使用MCBaseViewController的sessionManager
+ (instancetype)shareManager;

/// 在请求头中新增字段 目前用于加密接口中AccessToken的添加.
//- (void)mc_setHTTPHeaderFieldWithKey:(NSString*)key value:(NSString*)value;

/// 重发该session管理的网络任务
- (void)mc_reloadTasks;

#pragma mark - GET请求

/// GET请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
- (nullable NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString
                               parameters:(nullable id)parameters
                                       ok:(nullable MCSMNormalHandler)okResp;


/// GET请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
- (nullable NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString
                               parameters:(nullable id)parameters
                                       ok:(nullable MCSMNormalHandler)okResp
                                    other:(nullable MCSMNormalHandler)otherResp;
/// GET请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
/// @param failure 请求失败
- (nullable NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString
                               parameters:(nullable id)parameters
                                       ok:(nullable MCSMNormalHandler)okResp
                                    other:(nullable MCSMNormalHandler)otherResp
                                  failure:(nullable MCSMErrorHandler)failure;


#pragma mark - POST请求
/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                               parameters:(nullable id)parameters
                                       ok:(nullable MCSMNormalHandler)okResp;

/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                                parameters:(nullable id)parameters
                                        ok:(nullable MCSMNormalHandler)okResp
                                     other:(nullable MCSMNormalHandler)otherResp;

/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
/// @param failure 请求失败
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                               parameters:(nullable id)parameters
                                       ok:(nullable MCSMNormalHandler)okResp
                                    other:(nullable MCSMNormalHandler)otherResp
                                  failure:(nullable MCSMErrorHandler)failure;



/// 上传图片
/// @param shortURLString 地址
/// @param parameters 参数
/// @param images 图片集合
/// @param fields 每张图片对应的接口字段
/// @param names 图片名字集合
/// @param scale 图片压缩比
/// @param type 图片类型，默认jpg
/// @param okResp ok
/// @param otherResp other
/// @param failure failure
- (nullable NSURLSessionDataTask *)mc_UPLOAD:(NSString *)shortURLString
                                  parameters:(nullable id)parameters
                                      images:(nullable NSArray<UIImage*>*)images
                                remoteFields:(nullable NSArray<NSString *>*)fields
                                  imageNames:(nullable NSArray<NSString *>*)names
                                  imageScale:(CGFloat)scale
                                   imageType:(nullable NSString*)type
                                          ok:(nullable MCSMNormalHandler)okResp
                                       other:(nullable MCSMNormalHandler)otherResp
                                     failure:(nullable MCSMErrorHandler)failure;



//POST,设置body包含code
- (nullable NSURLSessionDataTask *)mc_Post_QingQiuTi:(NSString *)shortURLString
  parameters:(nullable id)parameters
          ok:(nullable MCSMNormalHandler)okResp
       other:(nullable MCSMNormalHandler)otherResp
                                             failure:(nullable MCSMErrorHandler)failure;

















/// 去掉多余斜杠
/// @param url url
- (NSString*)removeExtraSlashOfUrl:(NSString*)url;

+(NSMutableDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
@end







NS_ASSUME_NONNULL_END
