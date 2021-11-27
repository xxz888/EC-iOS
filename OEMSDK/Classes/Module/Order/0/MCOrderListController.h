//
//  MCOrderListController.h
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MCOrderListTypeNormal,
    MCOrderListTypeNP,
} MCOrderListType;

@interface MCOrderListController : MCBaseViewController

- (instancetype)initWithType:(MCOrderListType)type;

@end

NS_ASSUME_NONNULL_END
