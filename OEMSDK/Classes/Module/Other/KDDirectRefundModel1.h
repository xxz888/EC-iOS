//
//  KDDirectRefundModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectRefundModel1 : NSObject
@property (nonatomic, copy) NSString *hasWaitingEmptyOrder;

@property (nonatomic, copy) NSString *emptyCardPlanStatus;

/** eg.  */
@property (nonatomic, copy) NSString *province;
/** eg. 200 */
@property (nonatomic, assign) NSInteger creditBlance;
/** eg. 招商银行 */
@property (nonatomic, copy) NSString *bankName;
/** eg. 100 */
@property (nonatomic, assign) NSInteger brandId;
/** eg.  */
@property (nonatomic, copy) NSString *lineNo;
/** eg. 0624 */
@property (nonatomic, copy) NSString *expiredTime;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg.  */
@property (nonatomic, copy) NSString *city;
/** eg. 0 */
@property (nonatomic, assign) NSInteger balance;
/** eg. 贷记卡 */
@property (nonatomic, copy) NSString *nature;
/** eg. 2020/09/24 */
@property (nonatomic, copy) NSString *planCreateTime;
/** eg. 1 */
@property (nonatomic, copy) NSString *idDef;
/** eg. 0 */
@property (nonatomic, assign) CGFloat successAmount;
/** eg. 5889.43 */
@property (nonatomic, assign) CGFloat allAmount;
/** eg. 0 */
@property (nonatomic, copy) NSString *state;
/** eg. 0 */
@property (nonatomic, assign) NSInteger paymentDueDate;
/** eg. 4 */
@property (nonatomic, assign) NSInteger allRepaymentCount;
/** eg. 0 */
@property (nonatomic, copy) NSString *priOrPub;
/** eg. idcard */
@property (nonatomic, copy) NSString *idcard;
/** eg. 0 */
@property (nonatomic, copy) NSString *type;
/** eg.  */
@property (nonatomic, copy) NSString *bankBranchName;
/** eg.  */
@property (nonatomic, copy) NSString *bankBrand;
/** eg. 0 */
@property (nonatomic, assign) NSInteger status;
/** eg. 0 */
@property (nonatomic, assign) NSInteger failedAmount;
/** eg. 5889.43 */
@property (nonatomic, assign) CGFloat undoAmount;
/** eg. 招商银行信用卡 */
@property (nonatomic, copy) NSString *cardType;
/** eg. 633 */
@property (nonatomic, copy) NSString *securityCode;
/** eg. 0 */
@property (nonatomic, copy) NSString *repaymentModel;
/** eg. 26 */
@property (nonatomic, assign) NSInteger repaymentDay;
/** eg. 0 */
@property (nonatomic, assign) NSInteger creditLimit;
/** eg. 18738108782 */
@property (nonatomic, copy) NSString *phone;
/** eg. 1 */
@property (nonatomic, assign) NSInteger billDay;
/** eg. userId */
@property (nonatomic, assign) NSInteger userId;
/** eg. 金可可 */
@property (nonatomic, copy) NSString *userName;

/** eg. 0 */
@property (nonatomic, assign) NSInteger billDate;
/** eg. cardNo */
@property (nonatomic, copy) NSString *cardNo;
/** eg. logo */
@property (nonatomic, copy) NSString *logo;
/** eg. 2252009 */
@property (nonatomic, assign) NSInteger itemId;

@end

NS_ASSUME_NONNULL_END
