//
//  ZAGoodsStatusModel.h
//  Project
//
//  Created by SS001 on 2019/7/17.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAGoodsStatusModel : NSObject

@property (nonatomic, assign) NSInteger isPayment;
@property (nonatomic, assign) NSInteger isExpress;
@property (nonatomic, assign) NSInteger isSend;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *detailedAddress;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
