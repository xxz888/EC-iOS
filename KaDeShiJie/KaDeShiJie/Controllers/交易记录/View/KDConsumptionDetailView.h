//
//  KDConsumptionDetailView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTotalOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDConsumptionDetailView : UIView

- (void)showView;

@property (nonatomic, strong) KDTotalOrderModel *orderModel;
@property (nonatomic, strong) NSString * balancePlanId;//
@property (nonatomic, strong) NSString * message;//

@end

NS_ASSUME_NONNULL_END
