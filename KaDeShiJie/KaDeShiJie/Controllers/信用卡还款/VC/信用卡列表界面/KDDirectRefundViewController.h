//
//  KDDirectRefundViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectRefundViewController : MCBaseViewController
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *orderType;//订单类型（2为还款、3为空卡）

@end

NS_ASSUME_NONNULL_END
