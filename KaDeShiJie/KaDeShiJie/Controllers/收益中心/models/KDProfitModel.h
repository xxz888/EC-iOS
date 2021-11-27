//
//  KDProfitModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/17.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDProfitEarnModdel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDProfitModel : NSObject

@property (nonatomic, copy) NSString *totalRebate;
@property (nonatomic, copy) NSString *todayRebate;
@property (nonatomic, copy) NSString *monthRebate;
@property (nonatomic, strong) KDProfitEarnModdel *direc1;
@property (nonatomic, strong) KDProfitEarnModdel *direc2;
@property (nonatomic, strong) KDProfitEarnModdel *direc3;
@end

NS_ASSUME_NONNULL_END
