//
//  KDRepaymentBillModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRepaymentBillModel.h"

@implementation KDRepaymentBillModel

+ (NSDictionary *)mj_objectClassInArray
{
     return @{
              @"content" : KDDirectCardContentModel.class,
             };
}

@end
