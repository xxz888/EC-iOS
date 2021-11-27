//
//  KDTopDelegateNewModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/27.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTopDelegateNewModel.h"

@implementation KDTopDelegateNewModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{
              @"itemId" : @"id",
             };
}
@end
