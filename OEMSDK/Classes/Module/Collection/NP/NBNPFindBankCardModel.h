//
//  NBNPFindBankCardModel.h
//  Project
//
//  Created by SS001 on 2019/7/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCChannelRateModel.h"
#import "MCChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBNPFindBankCardModel : NSObject

@property (nonatomic, strong) NSString *bankCard;

@property (nonatomic, strong) NSString *channelTag;
@property (nonatomic, assign) NSInteger billDay;
@property (nonatomic, assign) NSInteger repaymentDay;
@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *tradTime;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, strong) NSString *regularRepaymentTime;
@property (nonatomic, strong) NSString *npRepaymentTime;

@property (nonatomic, strong)MCChannelRateModel *channelRate;

@property (nonatomic, strong)MCChannelModel *channel;

@property (nonatomic, strong) NSString *money;
@end

NS_ASSUME_NONNULL_END
