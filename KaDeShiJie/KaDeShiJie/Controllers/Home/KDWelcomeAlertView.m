//
//  KDWelcomeAlertView.m
//  KaDeShiJie
//
//  Created by wza on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWelcomeAlertView.h"

@implementation KDWelcomeAlertView

+ (instancetype)alertView {
    KDWelcomeAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KDWelcomeAlertView" owner:nil options:nil] lastObject];
    return view;
}

@end
