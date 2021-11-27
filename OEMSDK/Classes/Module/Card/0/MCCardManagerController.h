//
//  MCCardManagerController.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCSegementView.h"
#import "MCBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCCardManagerController : MCBaseViewController
@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) void (^selectCard)(MCBankCardModel *cardModel, NSInteger type);
@end

NS_ASSUME_NONNULL_END
