//
//  MCTabBarModel.m
//  MCOEM
//
//  Created by wza on 2020/6/29.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTabBarModel.h"

@implementation MCTabBarModel



- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName selectedIconName:(NSString *)selectedIconName controller:(MCBaseViewController *)controller {
    self = [super init];
    if (self) {
        self.title = title;
        self.iconName = iconName;
        self.selectedIconName = selectedIconName;
        self.controller = controller;
    }
    return self;
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"controller"]) {    //controller属性不进行映射，复制地址即可
        self.controller = oldValue;
        return nil;
    }
    return oldValue;
}

@end
