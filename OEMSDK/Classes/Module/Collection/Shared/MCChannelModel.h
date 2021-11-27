//
//  MCChannelModel.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCChannelModel : NSObject

@property (nonatomic, copy) NSString *singleMaxLimit;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *withdrawFee;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *channelParams;
@property (nonatomic, copy) NSString *channelNo;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *everyDayMaxLimit;
@property (nonatomic, copy) NSString *singleMinLimit;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *costRate;
@property (nonatomic, copy) NSString *extraFee;
@property (nonatomic, copy) NSString *paymentStatus;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, copy) NSString *autoclearing;
@property (nonatomic, copy) NSString *amount;

@end

NS_ASSUME_NONNULL_END
