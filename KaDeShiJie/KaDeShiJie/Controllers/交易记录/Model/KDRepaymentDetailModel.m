//
//  KDRepaymentDetailModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRepaymentDetailModel.h"

@implementation KDRepaymentDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
     return @{
              @"totalAmount" : KDTotalAmountModel.class,
              @"totalOrder" : KDTotalOrderModel.class,
             };
}

@end
