//
//  KDExtendPerformanceModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/17.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDPerformanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDExtendPerformanceModel : NSObject
@property (nonatomic, assign) CGFloat totalRebate;
@property (nonatomic, assign) CGFloat todayRebate;
@property (nonatomic, assign) CGFloat monthRebate;
@property (nonatomic, strong) KDPerformanceModel *direc1;
@property (nonatomic, strong) KDPerformanceModel *direc2;
@property (nonatomic, strong) KDPerformanceModel *direc3;
@property (nonatomic, strong) KDPerformanceModel *total;
@end

NS_ASSUME_NONNULL_END
