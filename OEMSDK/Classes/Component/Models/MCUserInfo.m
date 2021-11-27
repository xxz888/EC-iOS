//
//  MCUserInfo.m
//  MCOEM
//
//  Created by wza on 2020/3/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCUserInfo.h"

@implementation MCUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"id":@"userid"};
}

- (NSString *)realname {
    if (!_realname) {
        return @"-";
    }
    return _realname;
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
- (BOOL)isRealName {
    return [self.realnameStatus isEqualToString:@"1"];
}

- (NSString *)cTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.createTime integerValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
@end
