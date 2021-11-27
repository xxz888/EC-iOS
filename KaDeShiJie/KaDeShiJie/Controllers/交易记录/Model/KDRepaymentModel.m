//
//  KDRepaymentModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRepaymentModel.h"

@implementation KDRepaymentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"itemId" : @"id",
    };
}

- (NSString *)statusName
{
    NSArray *status = @[@"执行中", @"已失败", @"执行中", @"已完成",@"已失败"];
    return status[self.taskStatus];
}

//- (NSString *)statusName
//{
//    NSArray *status = @[@"",@"初始状态",@"执行中", @"已完成", @"已失败", @"取消中",@"已取消"];
//    return status[self.status];
//}



-(NSString *)statuskongkaName{
    NSInteger value = self.status;
    if (value == 1) {
        return  @"审核中";
    }
    if (value == 2) {
        return  @"审核通过";
    }
    if (value == 3) {
        return  @"运行中";
    }
    if (value == 4) {
        return  @"已暂停";
    }
    if (value == 5) {
        return  @"已暂停";
    }
    if (value == 6) {
        return  @"已完成";
    }
    if (value == 7) {
        return  @"退还手续费中";
    }
    if (value == 8) {
        return  @"已取消";
    }
    return @"";
}
-(NSString *)statuskongkaColor{
    NSInteger value = self.status;
    if (value == 1 || value == 3) {
        return  @"#ffc107";
    }
    if (value == 2 || value == 6) {
        return  @"#9ae076";
    }
    if (value == 7 || value == 8) {
        return  @"#ffc107";
    }
    if (value == 4 || value == 5) {
        return  @"#ff5722";
    }
    
    return @"";
}
@end
