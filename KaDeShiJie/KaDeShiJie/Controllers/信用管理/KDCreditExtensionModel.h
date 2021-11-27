//
//  KDCreditExtensionModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDCreditExtensionModel : NSObject

/** 授信时间 */
@property (nonatomic, copy) NSString *accreditTime;
/** 这个下级丢失的我授信的信用额度 */
@property (nonatomic, copy) NSString *lostSuperiorQuota;
/** 我授信给这个下级的信用额度 */
@property (nonatomic, copy) NSString *superiorQuota;
/** 下级实名状态,1:已实名,3:未提交 */
@property (nonatomic, copy) NSString *realNameStatus;
/** 下级用户姓名,实名之后才有值 */
@property (nonatomic, copy) NSString *firstUserName;
/** 下级用户手机号 */
@property (nonatomic, copy) NSString *firstUserPhone;
/** 下级用户id */
@property (nonatomic, copy) NSString *firstUserId;

@end

NS_ASSUME_NONNULL_END
