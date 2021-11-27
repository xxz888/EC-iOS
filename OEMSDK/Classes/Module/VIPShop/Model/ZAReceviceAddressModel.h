//
//  ZAReceviceAddressModel.h
//  Project
//
//  Created by SS001 on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAReceviceAddressModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *detailedAddress;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *isDefault;

@end

NS_ASSUME_NONNULL_END
