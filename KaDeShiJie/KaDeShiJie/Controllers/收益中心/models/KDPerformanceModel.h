//
//  KDPerformanceModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/17.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPerformanceModel : NSObject
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat rebate;
@property (nonatomic, assign) NSInteger registerCount;
@property (nonatomic, assign) NSInteger realNameCount;
@property (nonatomic, assign) NSInteger activeCount;


@property (nonatomic, assign) NSInteger authCount;

@end

NS_ASSUME_NONNULL_END
