//
//  MCIncomeRateModel.h
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCIncomeRateModel : NSObject

@property(nonatomic,copy)NSString* name;

@property(nonatomic,copy)NSString* phone;

@property(nonatomic,copy)NSString* rebate;

@property(nonatomic,copy)NSString* ranking;

@property (nonatomic, strong) UIImage *icon;

@property(nonatomic,copy)NSString* teamCount;

@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* order;
@end

NS_ASSUME_NONNULL_END
