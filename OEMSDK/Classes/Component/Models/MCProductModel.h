//
//  MCProductModel.h
//  MCOEM
//
//  Created by wza on 2020/4/17.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCProductModel : NSObject

@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * rebateMoney;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * trueFalseBuy;
@property (nonatomic, copy) NSString * TrueFalseBuy;
@property (nonatomic, copy) NSString * upgradestate;
@property (nonatomic, copy) NSString * brandId;
@property (nonatomic, copy) NSString * grade;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * earningsState;

@property (nonatomic, copy) NSString *isBuy;


// Add
@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, assign) CGFloat updateCellHeight;

/* 用户当前等级 */
@property (nonatomic, copy) NSString *userGrade;
/* 商品个数 */
@property (nonatomic, assign) int productNum;
@end

NS_ASSUME_NONNULL_END
