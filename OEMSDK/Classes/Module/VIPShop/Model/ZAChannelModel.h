//
//  ZAChannelModel.h
//  Project
//
//  Created by SS001 on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAChannelModel : NSObject

@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *everyDayMaxLimit;
@property (nonatomic, copy) NSString *paymentStatus;
@property (nonatomic, copy) NSString *subChannelTag;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *extendedField;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) NSInteger singleMaxLimit;
@property (nonatomic, assign) NSInteger singleMinLimit;
@property (nonatomic, assign) NSInteger extraFee;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *notifyURL;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *withdrawFee;
@property (nonatomic, copy) NSString *channelParams;
@property (nonatomic, copy) NSString *minextrafee;
@property (nonatomic, copy) NSString *coinType;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *minwithdrawFee;
@property (nonatomic, copy) NSString *costRate;
@property (nonatomic, copy) NSString *channelNo;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *autoclearing;
@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, copy) NSString *brandChannelName;
@property (nonatomic, copy) NSString *returnURL;
@property (nonatomic, assign) BOOL isChose;

@end

NS_ASSUME_NONNULL_END
