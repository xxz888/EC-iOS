//
//  MCEditBankCardController.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MCBankCardTypeXinyongka,
    MCBankCardTypeChuxuka,
} MCBankCardType;

@interface MCEditBankCardController : MCBaseViewController

- (instancetype)initWithType:(MCBankCardType)type cardModel:(nullable MCBankCardModel *)model;
@property (nonatomic, assign) BOOL loginVC;
@property (nonatomic, strong) NSString * whereCome;

@end

NS_ASSUME_NONNULL_END
