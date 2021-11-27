//
//  KDHistoryModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHistoryModel.h"

@implementation KDHistoryModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"detail":[KDProfitDirectPushModel class]};
}

@end
