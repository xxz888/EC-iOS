//
//  KDDirectCardContentModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDCreditCardAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectCardContentModel : NSObject
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedAmount;
/** eg. 0 */
@property (nonatomic, assign) NSInteger usedCharge;
/** eg. 招商银行 */
@property (nonatomic, copy) NSString *bankName;
/** eg. selectCity */
@property (nonatomic, copy) NSString *selectCity;
/** eg. 100 */
@property (nonatomic, copy) NSString *brandId;
/** eg. 0 */
@property (nonatomic, assign) NSInteger consumedAmount;
/** eg.  */
@property (nonatomic, copy) NSString *couponId;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg.  */
@property (nonatomic, copy) NSString *executeDates;
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentDate;
/** eg. 0 */
@property (nonatomic, assign) NSInteger difference;
/** eg. 0 */
@property (nonatomic, assign) NSInteger isClosed;
/** eg.  */
@property (nonatomic, copy) NSString *startDate;
/** creditCardAccount */
@property (nonatomic, strong) KDCreditCardAccountModel *creditCardAccount;
/** eg. 5888 */
@property (nonatomic, assign) NSInteger taskAmount;
/** eg.  */
@property (nonatomic, copy) NSString *channelName;
/** eg. creditCardNumber */
@property (nonatomic, copy) NSString *creditCardNumber;
/** eg. 4 */
@property (nonatomic, assign) NSInteger taskCount;
/** eg. 0 */
@property (nonatomic, assign) NSInteger autoRepayment;
/** eg. 0 */
@property (nonatomic, assign) NSInteger type;
/** eg. 0 */
@property (nonatomic, assign) NSInteger isAutoConsume;
/** eg. 54.55 */
@property (nonatomic, assign) CGFloat totalServiceCharge;
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedSuccessCount;
/** eg.  */
@property (nonatomic, copy) NSString *orderCode;
/** eg. 1740.96 */
@property (nonatomic, assign) CGFloat reservedAmount;
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedCount;
/** eg. 0 */
@property (nonatomic, assign) NSInteger taskConsumeAmount;
/** eg. rate */
@property (nonatomic, assign) CGFloat rate;
/** eg. 0 */
@property (nonatomic, assign) NSInteger taskStatus;
/** eg. 99-7 */
@property (nonatomic, copy) NSString *version;
/** eg. 1 */
@property (nonatomic, assign) NSInteger isCanDelete;
/** eg. 5888 */
@property (nonatomic, assign) NSInteger oldTaskAmount;
/** eg. 15800633815 */
@property (nonatomic, copy) NSString *phone;
/** eg. 1 */
@property (nonatomic, assign) NSInteger serviceCharge;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 金可可 */
@property (nonatomic, copy) NSString *userName;
/** eg. lastExecuteDateTime */
@property (nonatomic, copy) NSString *lastExecuteDateTime;
/** eg. 18738108782 */
@property (nonatomic, copy) NSString *bankPhone;
/** eg. 3778965 */
@property (nonatomic, assign) NSInteger itemId;
@end

NS_ASSUME_NONNULL_END
