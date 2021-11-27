//
//  MCNavigationController.m
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNavigationController.h"

@interface MCNavigationController ()

@end

@implementation MCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}


- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    
    NSArray<UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    // self.viewControllers has two items here on iOS14
    return viewControllers;
}

@end
