//
//  MCPaymentModel.h
//  Project
//
//  Created by Li Ping on 2019/6/1.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCPaymentModel : NSObject

@property (nonatomic, copy) NSString * channelNo;
@property (nonatomic, copy) NSString * subName;
@property (nonatomic, copy) NSString * channelTag;
@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * log;

@end

NS_ASSUME_NONNULL_END
