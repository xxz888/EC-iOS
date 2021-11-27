//
//  MCLocationTools.h
//  MCOEM
//
//  Created by SS001 on 2020/3/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

// 使用方法
//[[MCLocationTools share] getlocationName:^(NSString * _Nonnull province, NSString * _Nonnull city, NSString * _Nonnull area) {
//    NSLog(@"%@------%@-------%@", province, city, area);
//}];

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocationName)(NSString *province, NSString *city, NSString *area);

@interface MCLocationTools : NSObject

+ (instancetype)share;

- (void)getlocationName:(LocationName)location;

@property (nonatomic, assign) LocationName location;

@end

NS_ASSUME_NONNULL_END
