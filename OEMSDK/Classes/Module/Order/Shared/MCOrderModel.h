//
//  MCOrderModel.h
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCOrderModel : NSObject

@property (nonatomic, copy) NSString *costfee;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *brandid;
@property (nonatomic, copy) NSString *thirdlevelid;
@property (nonatomic, copy) NSString *channelname;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *openid;
/**  0：待完成，1：已成功，2：已取消，3：待处理，4：已成功待结算 */
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *outMerOrdercode;
@property (nonatomic, copy) NSString *phoneBill;
@property (nonatomic, copy) NSString *channelid;
@property (nonatomic, copy) NSString *bankcard;
@property (nonatomic, copy) NSString *createTime;

/**0:充值 1：支付 2：提现 10：信用卡消费 11：信用卡还款*/
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *outNotifyUrl;
@property (nonatomic, copy) NSString *thirdOrdercode;

@property (nonatomic, copy) NSString *outReturnUrl;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *carNo;
@property (nonatomic, copy) NSString *extraFee;
@property (nonatomic, copy) NSString *realAmount;

@property (nonatomic, copy) NSString *autoClearing;
@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *descCode;
@property (nonatomic, copy) NSString *brandname;

@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *ordercode;

@property (nonatomic, copy) NSString *channelImage;

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *debitBankName;
@property (nonatomic, copy) NSString *debitBankCard;

@end

NS_ASSUME_NONNULL_END
