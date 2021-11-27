//
//  MCProductDetailController.h
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCProductDetailController : MCBaseViewController

- (instancetype)initWithProductModel:(MCProductModel *)model;

@end

NS_ASSUME_NONNULL_END
