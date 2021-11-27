//
//  MCSMSController.h
//  MCOEM
//
//  Created by wza on 2020/4/21.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCResetPWDController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCSMSController : MCBaseViewController
- (instancetype)initWithType:(MCResetPWDType)type password:(NSString *)pwd;
@end

NS_ASSUME_NONNULL_END
