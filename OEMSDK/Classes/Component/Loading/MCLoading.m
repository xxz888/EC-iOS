//
//  MCLoading.m
//  MCOEM
//
//  Created by wza on 2020/4/10.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCLoading.h"
#import <MBProgressHUD/MBProgressHUD.h>

static MCLoading *_single = nil;


@interface MCLoading ()

@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation MCLoading

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_single == nil) {
            _single = [[self alloc] init];
        }
    });
    return _single;;
}

- (UIView *)view {
    if (!_view) {
        _view = UIApplication.sharedApplication.keyWindow;
    }
    return _view;
}



+ (void)show {
    
    [[self shared] show];
}

- (void)show {

    if ([MBProgressHUD HUDForView:self.view]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.6 alpha:0.75];
    hud.removeFromSuperViewOnHide = YES;

    self.hud = hud;
}

+ (void)hidden {
    [[self shared] hidden];
}
- (void)hidden {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
