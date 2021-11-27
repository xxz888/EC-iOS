//
//  MCModuleListController.h
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCRouterModuleModel : NSObject

@property(nonatomic, copy) NSString *module;
@property(nonatomic, copy) NSArray<NSString *> *controllerUrls;

@end

@interface MCModuleListController : MCBaseViewController

@end

NS_ASSUME_NONNULL_END
