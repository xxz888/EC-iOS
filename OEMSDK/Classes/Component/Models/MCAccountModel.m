//
//  MCAccountModel.m
//  Project
//
//  Created by Li Ping on 2019/7/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCAccountModel.h"

@implementation MCAccountModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSString *)realnameStatusName {
    NSString *nn = @"";
    if ([self.realnameStatus isEqualToString:@"0"]) {
        nn = @"实名中";
    }
    if ([self.realnameStatus isEqualToString:@"1"]) {
        nn = @"已实名";
    }
    if ([self.realnameStatus isEqualToString:@"2"]) {
        nn = @"实名失败";
    }
    if ([self.realnameStatus isEqualToString:@"3"]) {
        nn = @"未实名";
    }
    return nn;
}


@end
