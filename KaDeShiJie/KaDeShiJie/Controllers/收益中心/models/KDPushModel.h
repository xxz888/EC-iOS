//
//  KDPushModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPushModel : NSObject
@property (nonatomic, copy) NSString *activeSatatus;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger direct1ActiveCount;
@property (nonatomic, assign) CGFloat direct1Amount;
@property (nonatomic, assign) NSInteger direct2ActiveCount;
@property (nonatomic, assign) CGFloat direct2Amount;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *realNameStatus;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *realNameStatusName;
@property (nonatomic, copy) NSString *showPhone;

@property(nonatomic, copy) NSString *authStatus;



@end

NS_ASSUME_NONNULL_END
