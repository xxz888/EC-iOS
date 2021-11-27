//
//  KDTotalOrderModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTotalOrderModel.h"

@implementation KDTotalOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"des":@"description"};
}

- (NSString *)taskStatusName
{
    if (self.taskStatus == 1 && self.orderStatus == 1) {
        return @"已成功";
    }else if(self.taskStatus == 0) {
        return @"待执行";
    }else if (self.taskStatus == 1 && self.orderStatus == 4) {
        return @"执行中";
    }else if (self.taskStatus == 1 || self.orderStatus == 5) {
        return @"待完成";
    }else if (self.taskStatus == 2 || self.taskStatus == 4) {
        return @"已失败";
    }else if (self.taskStatus == 2 || self.taskStatus == 5) {
        return @"待完成";
    }
    return @"";
}
- (NSString *)typeName
{
    if (self.type == 10) {
        return @"消费";
    } else if (self.type == 11) {
        return @"还款";
    }
    return @"";
}
@end
