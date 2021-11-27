//
//  MCFeilvModel.h
//  MCOEM
//
//  Created by wza on 2020/4/23.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCFeilvModel : NSObject

@property (nonatomic, copy) NSString *brandChannelName;
@property (nonatomic, copy) NSString *everyDayMaxLimit;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *singleMinLimit;
@property (nonatomic, copy) NSString *returnURL;
@property (nonatomic, copy) NSString *notifyURL;

@property (nonatomic, copy) NSString *subChannelTag;
@property (nonatomic, copy) NSString *autoclearing;
@property (nonatomic, copy) NSString *singleMaxLimit;
@property (nonatomic, copy) NSString *extendedField;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *coinType;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *minextrafee;
@property (nonatomic, copy) NSString *channelParams;
@property (nonatomic, copy) NSString *minwithdrawFee;
@property (nonatomic, copy) NSString *channelNo;
@property (nonatomic, copy) NSString *extraFee;

@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *costRate;

@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *withdrawFee;
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
