//
//  MCStore.h
//  Pods
//
//  Created by wza on 2020/9/2.
//  单例基类，单例可以继承自它，提供单例方法；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCStore : NSObject

+ (instancetype) shared;

@end

NS_ASSUME_NONNULL_END
