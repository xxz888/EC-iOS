//
//  KDWebContainer.m
//  KaDeShiJie
//
//  Created by wza on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWebContainer.h"

#import <OEMSDK/OEMSDK.h>

@interface KDWebContainer ()
@end

@implementation KDWebContainer

static KDWebContainer *_singleStore = nil;

+ (instancetype)shared {
    
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        if (_singleStore == nil) {
            _singleStore = [[self alloc] init];
        }
    });
    return _singleStore;
}

- (void)setupContainer {
    
    MCWebViewController *kk = [[MCWebViewController alloc] init];
    kk.title = @"空卡还款";
    [kk view]; //为了出发viewdidload
    self.kongkaVC = kk;

    MCWebViewController *xyk = [[MCWebViewController alloc] init];
    xyk.title = @"信用卡还款";
    [xyk view];
    self.xinyongkaVC = xyk;
    
    MCWebViewController *jyjl = [[MCWebViewController alloc] init];
    jyjl.title = @"交易记录";
    [jyjl view];
    self.jiaoyijiluVC = jyjl;
    
    
    
}

- (void)loadOther {
    
}

//- (MCWebViewController *)kongkaVC {
//    if (!_kongkaVC) {
//        _kongkaVC = [[MCWebViewController alloc] init];
//        _kongkaVC.title = @"空卡还款";
//    }
//    return _kongkaVC;
//}
//- (MCWebViewController *)xinyongkaVC {
//    if (!_xinyongkaVC) {
//        _xinyongkaVC = [[MCWebViewController alloc] init];
//        _xinyongkaVC.title = @"信用卡还款";
//    }
//    return _xinyongkaVC;
//}
//- (MCWebViewController *)jiaoyijiluVC {
//    if (!_jiaoyijiluVC) {
//        _jiaoyijiluVC = [[MCWebViewController alloc] init];
//        _jiaoyijiluVC.title = @"交易记录";
//    }
//    return _jiaoyijiluVC;
//}

@end
