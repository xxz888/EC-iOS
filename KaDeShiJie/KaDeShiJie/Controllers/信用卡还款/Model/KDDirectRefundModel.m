//
//  KDDirectRefundModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectRefundModel.h"

@implementation KDDirectRefundModel

+ (NSDictionary *)mj_objectClassInArray
{
     return @{
              @"repaymentBill" : KDRepaymentBillModel.class,
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{
              @"itemId" : @"id",
             };
}


@end
