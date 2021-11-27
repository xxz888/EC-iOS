/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
//  当前版本：1.1.1

#import <Foundation/Foundation.h>
#import "DNSDomainInfo.h"

typedef NS_OPTIONS(NSUInteger, DNSResolverScheme) {
    DNSResolverSchemeHttp     = 0,
    DNSResolverSchemeHttps    = 1 << 0
};

@interface DNSResolver : NSObject

/// 唯一初始化方法
+ (instancetype)share;

///控制台注册生成，必传参数
@property (nonatomic, strong) NSString *accountId;

///是否开启缓存， 默认为NO
@property (nonatomic, assign) BOOL cacheEnable;


///是否开启IP测速， 默认为NO
@property (nonatomic, assign) BOOL speedTestEnable;

///是否只获取域名对应的ip， 默认为NO
@property (nonatomic, assign) BOOL shortEnable;

///是否使用ipv6网络解析域名，默认为NO
@property (nonatomic, assign) BOOL ipv6Enable;

///DNS scheme 类型， 默认为：DNSResolverSchemeHttp
@property (nonatomic, assign) DNSResolverScheme scheme;

///域名解析缓存最大数量，默认为100个域名
@property (nonatomic, assign) NSInteger cacheCountLimit;

///解析超时时间，建议2~5s，默认3s
@property (nonatomic, assign) NSTimeInterval timeout;

/// 获取域名解析后的ipv4信息数组
/// @param domain           域名
/// @param complete       回调(所有域名信息)
- (void)getIpv4InfoWithDomain:(NSString *)domain complete:(void(^)(NSArray<DNSDomainInfo *> *domainInfoArray))complete;

/// 获取域名解析后的ipv6信息数组
/// @param domain           域名
/// @param complete       回调(所有域名信息)
- (void)getIpv6InfoWithDomain:(NSString *)domain complete:(void(^)(NSArray<DNSDomainInfo *> *domainInfoArray))complete;

/// 获取域名解析后的ipv4信息
/// @param domain           域名
/// @param complete       回调(所有域名信息中ip测量最快的一个)
- (void)getRandomIpv4InfoWithDomain:(NSString *)domain complete:(void(^)(DNSDomainInfo *domainInfo))complete;

/// 获取域名解析后的ipv6信息
/// @param domain           域名
/// @param complete       回调(所有域名信息中ip测量最快的一个)
- (void)getRandomIpv6InfoWithDomain:(NSString *)domain complete:(void(^)(DNSDomainInfo *domainInfo))complete;

/// 获取域名解析后的ipv4地址数组
/// @param domain           域名
/// @param complete       回调(所有ip地址)
- (void)getIpv4DataWithDomain:(NSString *)domain complete:(void(^)(NSArray<NSString *> *dataArray))complete;

/// 获取域名解析后的ipv6地址数组
/// @param domain           域名
/// @param complete       回调(所有ip地址)
- (void)getIpv6DataWithDomain:(NSString *)domain complete:(void(^)(NSArray<NSString *> *dataArray))complete;

/// 获取域名解析后的ipv4地址
/// @param domain            域名
/// @param complete        回调(所有ip地址中ip测量最快的一个)
- (void)getRandomIpv4DataWithDomain:(NSString *)domain complete:(void(^)(NSString *data))complete;

/// 获取域名解析后的ipv6地址
/// @param domain            域名
/// @param complete        回调(所有ip地址中ip测量最快的一个)
- (void)getRandomIpv6DataWithDomain:(NSString *)domain complete:(void(^)(NSString *data))complete;

/// 预解析域名ipv4信息，可在程序启动时调用，加快后续域名解析速度
/// @param domainArray  域名数组
/// @param complete         解析完成后回调
- (void)preloadIpv4Domains:(NSArray<NSString *> *)domainArray complete:(void(^)(void))complete;

/// 预解析域名ipv6信息，可在程序启动时调用，加快后续域名解析速度
/// @param domainArray  域名数组
/// @param complete         解析完成后回调
- (void)preloadIpv6Domains:(NSArray<NSString *> *)domainArray complete:(void(^)(void))complete;

/// 直接从缓存中获取ipv4解析结果，无需等待.  如无缓存，或有缓存但已过期，返回 nil
/// @param domain   域名
- (NSArray<NSString *> *)getIpv4ByCacheWithDomain:(NSString *)domain;

/// 直接从缓存中获取ipv6解析结果，无需等待.  如无缓存，或有缓存但已过期，返回 nil
/// @param domain   域名
- (NSArray<NSString *> *)getIpv6ByCacheWithDomain:(NSString *)domain;

@end

