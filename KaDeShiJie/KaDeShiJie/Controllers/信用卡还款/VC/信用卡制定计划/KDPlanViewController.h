//
//  KDPlanViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
#import "KDDirectRefundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanViewController : MCBaseViewController
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) KDDirectRefundModel *directModel;
@end

NS_ASSUME_NONNULL_END
