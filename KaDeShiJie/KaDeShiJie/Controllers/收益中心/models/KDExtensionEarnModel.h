//
//  KDExtensionEarnModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/17.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDProfitEarnModdel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDExtensionEarnModel : NSObject

@property (nonatomic, assign) NSInteger todayActive;
@property (nonatomic, assign) NSInteger todayRealName;
@property (nonatomic, assign) CGFloat todayRebate;

@property (nonatomic, assign) NSInteger monthRealName;
@property (nonatomic, assign) NSInteger monthActive;
@property (nonatomic, assign) CGFloat monthRebate;

@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) CGFloat totalRebate;
@property (nonatomic, assign) NSInteger totalRealName;
@property (nonatomic, assign) NSInteger totalRegister;

@property (nonatomic, assign) NSInteger direc1;
@property (nonatomic, assign) NSInteger direc2;
@property (nonatomic, assign) NSInteger direc3;
@property (nonatomic, assign) NSInteger direct1ActiveCount;
@property (nonatomic, assign) NSInteger direct2ActiveCount;
@property (nonatomic, assign) NSInteger direct3ActiveCount;

@property (nonatomic, assign) NSInteger monthAuth;
@property (nonatomic, assign) NSInteger todayAuth;


@end

NS_ASSUME_NONNULL_END
