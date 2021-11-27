//
//  KDSlotCardHistoryModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDSlotCardHistoryModel : NSObject
/** eg. bankcard */
@property (nonatomic, copy) NSString *bankcard;
/** <#泛型#> */
@property (nonatomic, strong) NSString *carNo;
/** <#泛型#> */
@property (nonatomic, strong) NSString *thirdOrdercode;
/** eg. 广东发展银行 */
@property (nonatomic, copy) NSString *bankName;
/** eg. 3 */
@property (nonatomic, assign) NSInteger status;
/** eg. 911245432 */
@property (nonatomic, assign) NSInteger itemId;
/** eg.  */
@property (nonatomic, copy) NSString *outNotifyUrl;
/** eg. JFH_QUICK_1 */
@property (nonatomic, copy) NSString *channelTag;
/** eg. 3 */
@property (nonatomic, assign) CGFloat extraFee;
/** eg. userid */
@property (nonatomic, assign) NSInteger userid;
/** <#泛型#> */
@property (nonatomic, assign) CGFloat channelRate;
/** eg. 0.0055 */
@property (nonatomic, assign) CGFloat rate;
/** <#泛型#> */

/** eg. 0 */
@property (nonatomic, copy) NSString *type;
/** eg. 0.0046 */
@property (nonatomic, assign) CGFloat costRate;
/** eg. 卡提乐 */
@property (nonatomic, copy) NSString *brandname;
/** eg. 12 */
@property (nonatomic, assign) NSInteger channelid;
/** eg. debitBankCard */
@property (nonatomic, copy) NSString *debitBankCard;
/** eg. 工商银行 */
@property (nonatomic, copy) NSString *debitBankName;
/** eg. 1 */
@property (nonatomic, copy) NSString *autoClearing;
/** eg. 商旅快捷 */
@property (nonatomic, copy) NSString *channelname;
/** eg.  */
@property (nonatomic, copy) NSString *outReturnUrl;
/** <#泛型#> */
@property (nonatomic, assign) CGFloat channelFee;
/** eg.  */
@property (nonatomic, copy) NSString *remark;
/** eg. 1 */
@property (nonatomic, assign) CGFloat costfee;
/** eg. 18520149705 */
@property (nonatomic, copy) NSString *phone;
/** eg. 1 */
@property (nonatomic, assign) CGFloat minFee;
/** eg. 罗勇 */
@property (nonatomic, copy) NSString *userName;
/** eg. updateTime */
@property (nonatomic, copy) NSString *updateTime;
/** eg. 2 */
@property (nonatomic, copy) NSString *channelType;
/** eg.  */
@property (nonatomic, copy) NSString *descCode;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg.  */
@property (nonatomic, copy) NSString *openid;
/** eg. 100 */
@property (nonatomic, assign) NSInteger brandid;
/** eg. 96.45 */
@property (nonatomic, assign) CGFloat realAmount;
/** eg. 0.0055 */
@property (nonatomic, assign) CGFloat minRate;
/** eg.  */
@property (nonatomic, copy) NSString *outMerOrdercode;
/** eg. ordercode */
@property (nonatomic, copy) NSString *ordercode;
/** eg. 100 */
@property (nonatomic, assign) CGFloat amount;
/** eg. 商旅快捷D0 */
@property (nonatomic, copy) NSString *desc;
/** eg. 0 */
@property (nonatomic, copy) NSString *subChannelType;
@property (nonatomic, assign) NSInteger orderType;
@end

NS_ASSUME_NONNULL_END
