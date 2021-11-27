//
//  KDTotalOrderModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTotalOrderModel : NSObject

/** eg. 2020-09-30 */
@property (nonatomic, copy) NSString *executeDate;
@property (nonatomic, copy) NSString *executeTime;
@property (nonatomic, copy) NSString *status;

/** eg. 0 */
@property (nonatomic, copy) NSString *orderCode;
/** eg. taskId */
@property (nonatomic, copy) NSString *taskId;
/** eg. description */
@property (nonatomic, copy) NSString *des;

/** eg. 334.12 */
@property (nonatomic, assign) CGFloat amount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat totalServiceCharge;
/** eg. executeDateTime */
@property (nonatomic, copy) NSString *executeDateTime;
/** eg. 3.88 */
@property (nonatomic, assign) CGFloat serviceCharge;
/** eg. creditCardNumber */
@property (nonatomic, copy) NSString *creditCardNumber;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg. 0 */
@property (nonatomic, assign) NSInteger orderStatus;
/** eg. 338 */
@property (nonatomic, assign) CGFloat realAmount;
/** eg.  */
@property (nonatomic, copy) NSString *channelName;
/** eg. 0 */
@property (nonatomic, assign) NSInteger taskStatus;
/** eg. 99-7 */
@property (nonatomic, copy) NSString *version;
/** eg.  */
@property (nonatomic, copy) NSString *returnMessage;
/** eg. 2 */
@property (nonatomic, assign) NSInteger taskType;
/** eg. 0 */
@property (nonatomic, assign) CGFloat rate;
/** eg. 100 */
@property (nonatomic, copy) NSString *brandId;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 10 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *taskStatusName;
@property (nonatomic, copy) NSString *typeName;
/** 是否显示小点 */
@property (nonatomic, assign) BOOL isShowPoint;

@property (nonatomic, strong) NSString * balancePlanId;//新的和老的区别
@property (nonatomic, strong) NSString * city;
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
