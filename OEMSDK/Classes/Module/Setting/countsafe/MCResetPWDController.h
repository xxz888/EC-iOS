//
//  MCResetPWDController.h
//  MCOEM
//
//  Created by wza on 2020/4/21.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MCResetPWDTypeTrade,
    MCResetPWDTypeLogin
} MCResetPWDType;

@interface MCResetPWDController : MCBaseViewController

- (instancetype)initWithType:(MCResetPWDType)type;

@end

NS_ASSUME_NONNULL_END
