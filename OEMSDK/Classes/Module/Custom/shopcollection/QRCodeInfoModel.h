//
//  QRCodeInfoModel.h
//  Project
//
//  Created by SS001 on 2019/11/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeInfoModel : NSObject

@property (nonatomic, copy) NSString *brandIdReceived;
@property (nonatomic, copy) NSString *userIdReceived;
@property (nonatomic, copy) NSString *phoneReceived;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *phonePayment;
@property (nonatomic, copy) NSString *nickNamePayment;
@property (nonatomic, copy) NSString *userNameReceived;
@property (nonatomic, copy) NSString *brandIdPayment;
@property (nonatomic, copy) NSString *brandNameReceived;
@property (nonatomic, copy) NSString *brandNamePayment;
@property (nonatomic, copy) NSString *nickNameReceived;
@property (nonatomic, copy) NSString *userNamePayment;
@property (nonatomic, copy) NSString *userIdPayment;

@end

NS_ASSUME_NONNULL_END
