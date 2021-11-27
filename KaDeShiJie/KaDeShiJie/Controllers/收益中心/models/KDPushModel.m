//
//  KDPushModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPushModel.h"

@implementation KDPushModel

- (NSString *)realNameStatusName
{
    NSString *nn = @"";
    
    if (self.activeSatatus.intValue == 1) {
        nn = @"已激活";
    } else if (self.authStatus.intValue == 1) {
        nn = @"已认证";
    } else if (self.realNameStatus.intValue == 1) {
        nn = @"已实名";
    } else if (self.realNameStatus.intValue == 3) {
        nn = @"已注册";
    }
    
    return nn;
}

- (NSString *)showPhone
{
    NSString *first = [self.phone substringWithRange:NSMakeRange(0, 3)];
    NSString *last = [self.phone substringWithRange:NSMakeRange(7, 4)];
    return [NSString stringWithFormat:@"%@****%@", first, last];
}
@end
