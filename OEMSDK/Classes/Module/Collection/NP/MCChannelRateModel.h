//
//  MCChannelRateModel.h
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCChannelRateModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *minrate;
@property (nonatomic, copy) NSString *extraFee;
@property (nonatomic, copy) NSString *withdrawFee;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
