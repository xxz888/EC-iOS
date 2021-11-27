//
//  KDDirectCardContentModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectCardContentModel.h"

@implementation KDDirectCardContentModel

+ (NSDictionary *)mj_objectClassInArray
{
     return @{
              @"creditCardAccount" : KDCreditCardAccountModel.class,
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{
              @"itemId" : @"id",
             };
}

@end
