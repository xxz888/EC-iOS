//
//  MCUserInfo.h
//  MCOEM
//
//  Created by wza on 2020/3/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCUserInfo : NSObject

@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * directSum;
@property (nonatomic, copy) NSString * lastUpgradeTime;
@property (nonatomic, copy) NSString * county;
@property (nonatomic, copy) NSString * brandStatus;
@property (nonatomic, copy) NSString * grade;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * cardManagerTime;
@property (nonatomic, copy) NSString * betweenPushNum;
@property (nonatomic, copy) NSString * vipNum;
@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * teamSum;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * brandId;
@property (nonatomic, copy) NSString * usershopStatus;
@property (nonatomic, copy) NSString * bankCardManagerStatus;
@property (nonatomic, copy) NSString * realnameStatus;
@property (nonatomic, copy) NSString * coin;
@property (nonatomic, copy) NSString * gradeName;
@property (nonatomic, copy) NSString * indirectSum;
@property (nonatomic, copy) NSString * withdrawFee;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSString * firstUpgradeTime;
@property (nonatomic, copy) NSString * fullname;
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * realNameNum;
@property (nonatomic, copy) NSString * cardManagerStatus;
@property (nonatomic, copy) NSString * directPushNum;
@property (nonatomic, copy) NSString * idcard;
@property (nonatomic, copy) NSString * preUserPhone;

//自定义
@property(nonatomic, assign) BOOL isRealName;
@property(nonatomic, copy) NSString *realnameStatusName;

@property(nonatomic, copy) NSString *nickname;

@property(nonatomic, copy) NSString *whether;

@property(nonatomic, copy) NSString *cTime;
@property(nonatomic, copy) NSString * headImvUrl;
@property(nonatomic, copy) NSString * verificationStatus;


@end

NS_ASSUME_NONNULL_END



/*
{
    "userid": 20190418495840,
    "sex": null,
    "nickname": null,
    "phone": "18220392076",
    "realname": "李妍",
    "idcard": "610523199605118869",
    "grade": "4",
    "gradeName": "懂事股东",
    "remarks": "",
    "realnameStatus": "1",
    "usershopStatus": "3",
    "brandStatus": "0",
    "province": "上海市",
    "city": "上海市",
    "unionid": null,
    "bankCardManagerStatus": 0,
    "cardManagerStatus": 0,
    "cardManagerTime": "2020-04-17 09:35:15",
    "county": "静安区",
    "userShopName": null,
    "userShopAddress": null,
    "bankName": null,
    "bankBrand": null,
    "cardNo": null,
    "fullname": "李妍",
    "brandId": 0,
    "brandName": null,
    "balance": null,
    "freezeBalance": null,
    "rebateBalance": null,
    "freezerebateBalance": null,
    "coin": 0,
    "rechargeSum": null,
    "withdrawSum": null,
    "rebateSum": null,
    "withdrawFee": 3.00,
    "createTime": 1562405730000,
    "directPushNum": 0,
    "betweenPushNum": 0,
    "realNameNum": 0,
    "vipNum": 0,
    "teamSum": 0,
    "directSum": 0,
    "indirectSum": 0,
    "authTime": null,
    "developAgentStatus": null,
    "profession": null,
    "firstUpgradeTime": "2019-09-17 01:00:02",
    "lastUpgradeTime": "2020-04-07 23:05:12"
}
*/
