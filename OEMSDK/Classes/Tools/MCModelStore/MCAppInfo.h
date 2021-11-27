//
//  MCAppInfo.h
//  MCOEM
//
//  Created by wza on 2020/3/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAppInfo : NSObject
@property (nonatomic, strong) NSDictionary *infoDictionary;


#pragma mark - 工程相关


@property (nonatomic, copy, readonly) NSString *bundleID;
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *build;
@property (nonatomic, strong, readonly) UIImage *icon;




#pragma mark - 记录当前的 继承自MCBaseViewController的controller


@property (nonatomic, strong) MCBaseViewController *latestController;




@end

NS_ASSUME_NONNULL_END
