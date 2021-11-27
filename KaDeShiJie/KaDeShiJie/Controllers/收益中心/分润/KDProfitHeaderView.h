//
//  KDProfitHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDProfitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDProfitHeaderView : UIView

@property (nonatomic, strong) NSString *navTitle;
- (void)reloadData;
@property (weak, nonatomic) IBOutlet QMUIButton *yearBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *monthBtn;
@property (nonatomic, copy) void(^getDataWithReloadData)(KDProfitModel *profitModel);
@end

NS_ASSUME_NONNULL_END
