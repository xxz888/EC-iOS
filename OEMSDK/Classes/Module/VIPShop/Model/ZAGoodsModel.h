//
//  ZAGoodsModel.h
//  Project
//
//  Created by SS001 on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAGoodsModel : NSObject

@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *earningsState;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *upgradestate;
@property (nonatomic, copy) NSString *trueFalseBuy;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic, assign) CGFloat discount;
@property (nonatomic, copy) NSString *ID;


@end

NS_ASSUME_NONNULL_END
