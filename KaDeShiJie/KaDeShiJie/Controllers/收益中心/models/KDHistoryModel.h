//
//  KDHistoryModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDProfitDirectPushModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDHistoryModel : NSObject

@property (nonatomic, assign) CGFloat monthAmount;
@property (nonatomic, assign) NSInteger monthCount;
@property (nonatomic, assign) CGFloat todayAmount;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, strong) NSArray<KDProfitDirectPushModel *> *detail;
@end

NS_ASSUME_NONNULL_END
