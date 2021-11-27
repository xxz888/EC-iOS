//
//  MCAppInfo.m
//  MCOEM
//
//  Created by wza on 2020/3/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCAppInfo.h"

@interface MCAppInfo ()

//是否打开测试服务器地址 YES 开启 NO 关闭
@property (nonatomic, assign, readwrite) BOOL is_open_testserviceaddress;
@end

@implementation MCAppInfo

- (NSDictionary *)infoDictionary {
    if (!_infoDictionary) {
        _infoDictionary = [[NSBundle mainBundle] infoDictionary];
    }
    return _infoDictionary;
}

- (NSString *)bundleID {
    return [self.infoDictionary objectForKey:@"CFBundleIdentifier"];
}
- (NSString *)version {
    return [self.infoDictionary objectForKey:@"CFBundleVersion"];
}
- (NSString *)build {
    return [self.infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
- (UIImage *)icon {
    NSString *iconPath = [[self.infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* icon = [UIImage imageNamed:iconPath];
    if (icon == nil) {
        return [UIImage new];
    }
    return icon;
}





@end
