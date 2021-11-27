//
//  MCNPCashierController.h
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"

typedef void(^serviceOnLineBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MCNPCashierController : MCBaseViewController

@property (nonatomic, assign) serviceOnLineBlock serviceBlock;

@end

NS_ASSUME_NONNULL_END
