//
//  MCCashierChooseCard.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCChooseCardModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MCCashierChooseCardXinyong,
    MCCashierChooseCardChuxu
} MCCashierChooseCardType;

@class MCCashierChooseCard;
@protocol MCCashierChooseCardDelegate <NSObject>

- (void)cashierChoose:(MCCashierChooseCard *)choose DidSelectedCard:(MCChooseCardModel *)cardInfo;

@end

@interface MCCashierChooseCard : NSObject

@property(nonatomic, weak) id<MCCashierChooseCardDelegate> delegate;


- (instancetype)initWithType:(MCCashierChooseCardType)type;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
