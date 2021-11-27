//
//  MCTabBarModel.h
//  MCOEM
//
//  Created by wza on 2020/6/29.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTabBarModel : NSObject

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName selectedIconName:(NSString *)selectedIconName controller:(MCBaseViewController *)controller;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *iconName;
@property(nonatomic, copy) NSString *selectedIconName;
@property(nonatomic, strong) MCBaseViewController *controller;

@end

NS_ASSUME_NONNULL_END
