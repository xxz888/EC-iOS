//
//  KDWebContainer.h
//  KaDeShiJie
//
//  Created by wza on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
#import <OEMSDK/MCWebViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDWebContainer : NSObject

+ (instancetype)shared;

@property(nonatomic, strong) MCWebViewController *  kongkaVC;
@property(nonatomic, strong) MCWebViewController *  xinyongkaVC;
@property(nonatomic, strong) MCWebViewController *  jiaoyijiluVC;

- (void)setupContainer;

@end

NS_ASSUME_NONNULL_END
